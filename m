Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYIGEUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYIGEUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 00:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbYIGEUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 00:20:38 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:33128 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYIGEUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 00:20:37 -0400
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
From: Tony Vroon <tony@vroon.org>
To: Jeroen van Rijn <jvrnix@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <8ee0b8e80809062016r12388b59nea95f820079c39f8@mail.gmail.com>
References: <1220754742.8530.12.camel@localhost>
	 <8ee0b8e80809062016r12388b59nea95f820079c39f8@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+DtZTRs8Y/2F16PNPuxj"
Date: Sun, 07 Sep 2008 05:22:07 +0100
Message-Id: <1220761327.8530.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+DtZTRs8Y/2F16PNPuxj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 05:16 +0200, Jeroen van Rijn wrote:
> Still, before I sign off, have you tried running "mcelog
> --ascii"? It needs to be run on the machine the check occured on. It
> might give you something to go on before the cavalry arrives.

That worked, thank you. Had to feed it back in as /dev/mcelog was empty,
but it made a bit more sense of it:

MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 0 data cache        bit57 =3D processor context corrupt
       bit59 =3D misc error valid
       bit61 =3D error uncorrected
       bit62 =3D error overflow (multiple errors)
  bus error 'local node observed, request didn't time out
      generic error mem transaction
      generic access, level generic'
STATUS fa00002000020c0f MCGSTATUS 0
MCE 1
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 4 0 data cache        bit57 =3D processor context corrupt
       bit59 =3D misc error valid
       bit61 =3D error uncorrected
       bit62 =3D error overflow (multiple errors)
  bus error 'generic participation, request timed out
      generic error mem transaction
      generic access, level generic'
STATUS fa00000000070f0f MCGSTATUS 0

> Best regards,
>   Jeroen.

Regards,
Tony V.

--=-+DtZTRs8Y/2F16PNPuxj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjDVu8ACgkQp5vW4rUFj5qQagCgicbpvVJX66dPgxoGfPkN4sRx
ot4An0YsKhy/Y1X2MMtbhMeeOD5s2OjG
=pHii
-----END PGP SIGNATURE-----

--=-+DtZTRs8Y/2F16PNPuxj--

