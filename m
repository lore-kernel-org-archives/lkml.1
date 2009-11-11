Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZKKKjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZKKKjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZKKKjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:39:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49461 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZKKKjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:39:02 -0500
Date: Wed, 11 Nov 2009 11:38:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/3] mpc52xx_spi: add missing mode_bits definition
Message-ID: <20091111103853.GB4234@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de> <1257844329-20687-2-git-send-email-l.fu@pengutronix.de> <1257844329-20687-3-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1257844329-20687-3-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2009 at 10:12:08AM +0100, Luotao Fu wrote:
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

SPI_CS_HIGH should be dropped, otherwise:

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

> ---
>  drivers/spi/mpc52xx_spi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
> index 5b036f2..79ba678 100644
> --- a/drivers/spi/mpc52xx_spi.c
> +++ b/drivers/spi/mpc52xx_spi.c
> @@ -430,6 +430,8 @@ static int __devinit mpc52xx_spi_probe(struct of_devi=
ce *op,
>  	master->num_chipselect =3D 1;
>  	master->setup =3D mpc52xx_spi_setup;
>  	master->transfer =3D mpc52xx_spi_transfer;
> +	master->mode_bits =3D SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST;
> +
>  	dev_set_drvdata(&op->dev, master);
> =20
>  	ms =3D spi_master_get_devdata(master);
> --=20
> 1.6.5.2
>=20
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr6lD0ACgkQD27XaX1/VRts5gCeMIoCcdxQ1HfutQ0PsKq60GR5
+mEAnjM2LXjIpDuZJ43GElcC4l9SFHmk
=2J75
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
