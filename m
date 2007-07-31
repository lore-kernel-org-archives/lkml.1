Return-Path: <linux-kernel-owner+w=401wt.eu-S939748AbXGaAzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939748AbXGaAzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935115AbXGaAz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:55:29 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:57921
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756673AbXGaAz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:55:28 -0400
X-Greylist: delayed 2363 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 20:55:27 EDT
Date: Mon, 30 Jul 2007 17:13:47 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Adrian Bunk <bunk@stusta.de>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] usbat_check_status(): fix check-after-use
Message-ID: <20070731001347.GA14124@one-eyed-alien.net>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>, gregkh@suse.de,
	linux-usb-devel@lists.sourceforge.net,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
References: <20070730222822.GG3972@stusta.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20070730222822.GG3972@stusta.de>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 30 Jul 2007 17:13:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

On Tue, Jul 31, 2007 at 12:28:22AM +0200, Adrian Bunk wrote:
> The Coverity checker spotted that we have already oops'ed if "us"
> was NULL.
>=20
> Since "us" can't be NULL in the only caller this patch removes the
> NULL check.
>=20
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>=20
> ---
> --- linux-2.6.23-rc1-mm1/drivers/usb/storage/shuttle_usbat.c.old	2007-07-=
30 16:56:34.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/usb/storage/shuttle_usbat.c	2007-07-30 1=
6:57:24.000000000 +0200
> @@ -190,9 +190,6 @@ static int usbat_check_status(struct us_
>  	unsigned char *reply =3D us->iobuf;
>  	int rc;
> =20
> -	if (!us)
> -		return USB_STOR_TRANSPORT_ERROR;
> -
>  	rc =3D usbat_get_status(us, reply);
>  	if (rc !=3D USB_STOR_XFER_GOOD)
>  		return USB_STOR_TRANSPORT_FAILED;

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I need a computer?
					-- Customer
User Friendly, 2/19/1998

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGrn67HL9iwnUZqnkRAojgAJ9xwu8BP0jXMS5ZyVudabQyAgUo8QCgkOf8
HBMMiufkYFVBRICGchYVu7U=
=Eb7Z
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
