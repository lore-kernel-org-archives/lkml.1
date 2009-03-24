Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbZCXUSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbZCXUSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCXURz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:17:55 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:59244 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZCXURy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:17:54 -0400
Date: Tue, 24 Mar 2009 21:17:48 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: =?UTF-8?B?Sm9zw6kgTWFyw63CrWEgRmVybsOhbmRleiBHb256w6FsZXo=?= 
	<josemariafg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Some microSD cards are not recognized by
 PCIxx12 SDA controller
Message-ID: <20090324211748.30cd7429@mjolnir.ossman.eu>
In-Reply-To: <49B5C091.3090303@gmail.com>
References: <49B5C091.3090303@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-18827-1237925869-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-18827-1237925869-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Mar 2009 02:21:21 +0100
Jos=C3=A9 Mar=C3=AD=C2=ADa Fern=C3=A1ndez Gonz=C3=A1lez <josemariafg@gmail.=
com> wrote:

>=20
> I don't know whether this patch can break something in the behavior of ot=
her
> SD controllers, but at least it works for my laptop.
>=20

Should be fairly safe, it just slows things down.

> diff -Nrpu linux-2.6.28.5/drivers/mmc/core/core.c.orig linux-2.6.28.5/dri=
vers/mmc/core/core.c
> --- linux-2.6.28.5/drivers/mmc/core/core.c.orig	2009-03-10 01:30:19.00000=
0000 +0100
> +++ linux-2.6.28.5/drivers/mmc/core/core.c	2009-03-10 01:29:44.000000000 =
+0100
> @@ -514,7 +514,7 @@ static void mmc_power_up(struct mmc_host
>  	 * This delay should be sufficient to allow the power supply
>  	 * to reach the minimum voltage.
>  	 */
> -	mmc_delay(2);
> +	mmc_delay(10);
> =20

A delay of 10 is just enough to trigger a sleep on most kernels
(HZ=3D100). Have you determined the lower bound of these two values?

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-18827-1237925869-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknJP+4ACgkQ7b8eESbyJLgaiwCeN+A9Qg+HtC/Olb+eztQZ5TAl
x8QAoOTdPl6EBydnPRW0nLaN56/0acHK
=SoEO
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-18827-1237925869-0001-2--
