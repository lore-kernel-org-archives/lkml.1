Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZGACdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZGACdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZGACdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:33:12 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44329 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720AbZGACdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:33:11 -0400
Subject: Re: Can't boot 2.6.30 powerpc kernel under qemu.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Landley <rob@landley.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linuxppc-dev@lists.ozlabs.org, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1246359020.31413.12.camel@pasglop>
References: <200906281033.09842.jk@ozlabs.org>
	 <200906291834.07902.rob@landley.net>  <1246321478.4621.11.camel@concordia>
	 <1246359020.31413.12.camel@pasglop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-b9CyhzJnrhz9IoEFlB1c"
Date: Wed, 01 Jul 2009 00:04:56 +1000
Message-Id: <1246370696.8542.2.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b9CyhzJnrhz9IoEFlB1c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-30 at 20:50 +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2009-06-30 at 10:24 +1000, Michael Ellerman wrote:
> > On Mon, 2009-06-29 at 18:34 -0500, Rob Landley wrote:
> > > Which suggested that the problem was the new CONFIG_PPC_OF_BOOT_TRAMP=
OLINE=20
> > > symbol wasn't set, and once I switched that on it started working aga=
in.
> >=20
> > What defconfig are you using? It sounds like maybe something should be
> > 'select'ing OF_BOOT_TRAMPOLINE.
>=20
> Right, pmac, pseries and chrp probably ... though I don't like select
> for a user-visible option, I'd rather fix things if I inadvertently
> forgot the "default y" here, after all, one may want to do a minimum
> kdump kernel without prom_init.c in it.

Yeah true. In that case there's not much to do, it's default y, and the
help text says "In case of doubt, say Y".

Rob, do you remember saying "no" to this option when it came up, or did
you run 'make <something defconfig>' and end up with it unset? The
latter would be a bug, the former would not :)

cheers

--=-b9CyhzJnrhz9IoEFlB1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpKG4UACgkQdSjSd0sB4dJzrwCfVhAwipQ+UrYF4BRBzZNp2iS6
aCsAoJ6fj/9iWISc1zBlrpCV/joX62F1
=iO7M
-----END PGP SIGNATURE-----

--=-b9CyhzJnrhz9IoEFlB1c--

