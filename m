Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZK1QVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZK1QVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 11:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZK1QVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 11:21:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35515 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbZK1QVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 11:21:15 -0500
Date: Sat, 28 Nov 2009 17:21:17 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-11-24-16-47 uploaded (gpio_max7301)
Message-ID: <20091128162117.GA9663@pengutronix.de>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org> <4B0DDDFE.5060600@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <4B0DDDFE.5060600@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> This driver has build failures when CONFIG_I2C=3Dm and
> MAX7301=3Dy, MAX7301_I2C=3Dy, MAX7301_SPI=3Dy:
>=20
> drivers/built-in.o: In function `max7301_i2c_write':
> max7301.c:(.text+0x2d9e): undefined reference to `i2c_smbus_write_byte_da=
ta'
> drivers/built-in.o: In function `max7301_i2c_read':
> max7301.c:(.text+0x2dc6): undefined reference to `i2c_smbus_read_byte_dat=
a'
> drivers/built-in.o: In function `max7301_init':
> max7301.c:(.init.text+0x42e): undefined reference to `i2c_register_driver'
> max7301.c:(.init.text+0x496): undefined reference to `i2c_del_driver'
> drivers/built-in.o: In function `max7301_exit':
> max7301.c:(.exit.text+0x14): undefined reference to `i2c_del_driver'
>=20
>=20
> This kconfig syntax:
>=20
> config GPIO_MAX7301
>         tristate "Maxim MAX730x GPIO expander"
>         depends on I2C || SPI_MASTER
>=20
> allows GPIO_MAX7301 to be y when SPI_MASTER=3Dy and I2C=3Dm.
> If you want to do that, you'll need to handle CONFIG_I2C=3Dm somehow.

ACK, will fix it.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksRTf0ACgkQD27XaX1/VRtjrQCfV7DSExMdU/1FkQwrmFBpr0D+
vvIAoJasMd+VZVsBcA2GV2unZ73rgF4V
=IZyk
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
