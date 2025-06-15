{
  description = "My Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nvf,
    }:
    {
      homeManagerModules.default =
        { pkgs, ... }:
        {
          imports = [ ./nvim.nix ];
          _module.args = { inherit nvf; };
        };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # For standalone usage without home-manager
        packages.default = (import ./nvim.nix { inherit pkgs nvf; }).programs.nvf.finalPackage;

        # Development shell for testing
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            nixfmt-rfc-style
          ];
        };
      }
    );
}
