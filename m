Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXDMD6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXDMD6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 23:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXDMD6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 23:58:32 -0400
Received: from ozlabs.org ([203.10.76.45]:39864 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXDMD6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 23:58:31 -0400
Subject: Re: xmon debugger doc?
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Olof Johansson <olof@lixom.net>
Cc: Steve Wise <swise@opengridcomputing.com>, linuxppc-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070413034850.GA12654@lixom.net>
References: <1176410647.27519.6.camel@stevo-desktop>
	 <20070413034850.GA12654@lixom.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A8OM2OulcIobFejKOQEo"
Date: Fri, 13 Apr 2007 13:58:29 +1000
Message-Id: <1176436709.4734.19.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A8OM2OulcIobFejKOQEo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-12 at 22:48 -0500, Olof Johansson wrote:
> On Thu, Apr 12, 2007 at 03:44:07PM -0500, Steve Wise wrote:
> > Can someone please point me at ppc64 xmon debugger usage /
> > documentation? I've had little luck finding info on-line.
>=20
> The help output from it is pretty much all there is.
>=20
> You might have better luck asking on linuxppc-dev@ozlabs.org though
> (adding as Cc).
>=20
> There's also an old writeup at
> http://mbligh.org/linuxdocs/Kernel/DebuggingPPC64 for the very basics
> of digging through a crash. Some of it is likely out of date by now.

A good trick which the help output doesn't mention is that % and $ are
special in input, so you can do:

0:mon> di %pc

disassemble instructions at address pointed to by register PC

Other regs are eg: %lr, %r1, %r12.
And it works with di, d and other commands.

Also:

0:mon> di $.xmon_register_spus

disassemble instructions at address of symbol .xmon_register_spus.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-A8OM2OulcIobFejKOQEo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGHv/ldSjSd0sB4dIRAk7JAJ9NY+aKw3VhQus0jAUd2ei1LiLUpwCfe+5t
dG3ZFDrI15ADUOjwkYJ73Xc=
=XXGf
-----END PGP SIGNATURE-----

--=-A8OM2OulcIobFejKOQEo--

