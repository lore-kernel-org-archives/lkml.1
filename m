Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYDKAvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYDKAvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 20:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYDKAuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 20:50:54 -0400
Received: from crypt.ethx.net ([82.165.27.140]:45485 "EHLO crypt.ethx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYDKAux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 20:50:53 -0400
Subject: Re: Samsung Q45 hard freeze during boot
From: Sam Morris <sam@robots.org.uk>
To: linux-kernel@vger.kernel.org
Cc: 475319@bugs.debian.org
In-Reply-To: <1207823931.8277.10.camel@tycho.robots.org.uk>
References: <1207823931.8277.10.camel@tycho.robots.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4kZ072qAPINkFG5hduh/"
Date: Fri, 11 Apr 2008 01:50:44 +0100
Message-Id: <1207875044.4594.2.camel@xerces>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
X-Spam-Bars: /
X-Spam-Report: hits=0.2: ALL_TRUSTED=-1.44, TVD_RCVD_IP=1.617 with SpamAssassin 3.2.3 (2007-08-08) on crypt.ethx.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4kZ072qAPINkFG5hduh/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-10 at 11:38 +0100, Sam Morris wrote:
> Hi there, I'm trying to get Linux working on a Samsung Q45 laptop.
> 2.6.22 works fine, but 2.6.24.3 and 2.6.25-rc8 both freeze hard during
> boot time after the following messages:
>=20
>         Waiting for /dev to be fully populated...
>         agpgart: Detected an Intel 965GM Chipset.
>         agpgart: AGP aperture is 256M @ 0xd0000000
>         input: Power Button (FF) as /class/input/input2
>         ACPI: Power Button (FF) [PWSRF]
>         inputL Lid Switch as /class/input/input3
>         ACPI: Lid Switch [LID0]
>         input: Power Button (CM) as /class/input/input4
>         ACPI: Power Button (CM) [PWRB]
>         input: Sleep Button (CM) as /class/input/input5
>         ACPI: Sleep Button (CM) [SLPB]
>         ACPI: AC Adapter [ADP1] (on-line)
>         ACPI: Battery Slot [BAT1] (battery present)

Further to this--I found that if I blacklist the 'video' driver then I can =
boot up normally.

--=20
Sam Morris
http://robots.org.uk/

PGP key id 1024D/5EA01078
3412 EA18 1277 354B 991B  C869 B219 7FDB 5EA0 1078

--=-4kZ072qAPINkFG5hduh/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH/rXkshl/216gEHgRAhvjAJ4tZ8f8SVtOYS4K5Y622dSe00bKpQCgxl2U
ZtSxYRq0DqqY+mFBjskO4rU=
=SWVv
-----END PGP SIGNATURE-----

--=-4kZ072qAPINkFG5hduh/--
