Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZFNIf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZFNIf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 04:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZFNIfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 04:35:19 -0400
Received: from b186.blue.fastwebserver.de ([62.141.42.186]:60288 "EHLO
	mail.gw90.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbZFNIfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 04:35:17 -0400
Subject: Re: [BUG] [input] Sometimes mouse gets detected as PS2++ Logitech
 Mouse instead of ImPS/2 Logitech Wheel Mouse
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0906121649440.31685@twin.jikos.cz>
References: <1244788506.6039.41.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.2.00.0906121649440.31685@twin.jikos.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5+84C9hSv2tTiSYlYZ5L"
Date: Sun, 14 Jun 2009 10:35:10 +0200
Message-Id: <1244968510.5898.53.camel@mattotaupa.wohnung.familie-menzel.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5+84C9hSv2tTiSYlYZ5L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 12.06.2009, 16:51 +0200 schrieb Jiri Kosina:
> [ added linux-input@ to CC ]

Maybe the contact address in MAINTAINERS should be set to linux-input@?

> On Fri, 12 Jun 2009, Paul Menzel wrote:
>=20
> > arbitrarily (I would say every two month) my Logitech Cordless MouseMan
> > Wheel gets detected as (in dmesg)
> >=20
> > PS2++ Logitech Mouse
> >=20
> > instead of
> >=20
> > ImPS/2 Logitech Wheel Mouse.
>=20
> It would be nice if you could capture the dmesg output with i8042.debug=20
> command-line from the situation the mouse gets mis-detected. But I=20
> understand that with so low frequency of occurence, that would be a major=
=20
> pain.

No problem. The problem has not yet surfaced again. But do I need to
rebuild Linux or are those debug messages enough?

Jun 14 10:34:16 x kernel: [ 4667.683375] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: 28 <- i8042 (interrupt, 1, 12) [1166664]
Jun 14 10:34:16 x kernel: [ 4667.684331] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1166665]
Jun 14 10:34:16 x kernel: [ 4667.685311] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: fb <- i8042 (interrupt, 1, 12) [1166665]
Jun 14 10:34:16 x kernel: [ 4667.686329] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1166665]
Jun 14 10:34:16 x kernel: [ 4667.703063] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: 28 <- i8042 (interrupt, 1, 12) [1166669]
Jun 14 10:34:16 x kernel: [ 4667.704016] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1166670]
Jun 14 10:34:16 x kernel: [ 4667.704980] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: f9 <- i8042 (interrupt, 1, 12) [1166670]
Jun 14 10:34:16 x kernel: [ 4667.705966] /build/buildd-linux-2.6_2.6.29-5-i=
386-xtBC0n/linux-2.6-2.6.29/debian/build/source_i386_none/drivers/input/ser=
io/i8042.c: 00 <- i8042 (interrupt, 1, 12) [1166670]


Thanks,

Paul

--=-5+84C9hSv2tTiSYlYZ5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko0tj0ACgkQPX1aK2wOHVh55ACfY3727XYTkQs1VPimFEQO9c7j
DBMAnAynsjysEleOpJfyFKBX3pY+97sc
=BYCk
-----END PGP SIGNATURE-----

--=-5+84C9hSv2tTiSYlYZ5L--

