Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZF3AYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZF3AYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZF3AYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:24:37 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45617 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZF3AYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:24:37 -0400
Subject: Re: Can't boot 2.6.30 powerpc kernel under qemu.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Rob Landley <rob@landley.net>
Cc: Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <200906291834.07902.rob@landley.net>
References: <200906281033.09842.jk@ozlabs.org>
	 <200906291834.07902.rob@landley.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-09JIW95yaypzlhlHwAmq"
Date: Tue, 30 Jun 2009 10:24:38 +1000
Message-Id: <1246321478.4621.11.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-09JIW95yaypzlhlHwAmq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-29 at 18:34 -0500, Rob Landley wrote:
> Which suggested that the problem was the new CONFIG_PPC_OF_BOOT_TRAMPOLIN=
E=20
> symbol wasn't set, and once I switched that on it started working again.

What defconfig are you using? It sounds like maybe something should be
'select'ing OF_BOOT_TRAMPOLINE.


> > linuxppc-dev@lists.ozlabs.org is the one you want for this:
> >
> >  https://lists.ozlabs.org/listinfo/linuxppc-dev
>=20
> Cool!  Is there a reason it's hidden?  (Or at least not listed in either=20
> vger.kernel.org's list info page or in the "Maling lists" page linked fro=
m=20
> ozlabs.org's top level web page.)  Just curious, I couldn't find it when =
I=20
> looked in the obvious (to me) places.

It's not hidden, it's just in the process of moving from ozlabs.org to
lists.ozlabs.org - and it's a bit hard to find in the process. I've
updated the ozlabs.org page to point to it in the meantime.

It's also in maintainers :D

LINUX FOR POWERPC (32-BIT AND 64-BIT)                                      =
                                   =20
P:      Benjamin Herrenschmidt
M:      benh@kernel.crashing.org
P:      Paul Mackerras
M:      paulus@samba.org
W:      http://www.penguinppc.org/
L:      linuxppc-dev@ozlabs.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
S:      Supported


cheers

--=-09JIW95yaypzlhlHwAmq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpJWzwACgkQdSjSd0sB4dIS5ACgt9cW2NcDis8oj/3Jr3JdhLy1
hV4An02xbRKHME4V/dOd2kIc9gY4zWhz
=n1Sd
-----END PGP SIGNATURE-----

--=-09JIW95yaypzlhlHwAmq--

