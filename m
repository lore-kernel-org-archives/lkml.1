Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZG1RBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZG1RBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZG1RBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:01:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59934 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZG1RBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:01:06 -0400
Date: Tue, 28 Jul 2009 18:31:04 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: p_gortmaker@yahoo.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 7/9] drivers/rtc: correct error-handling
	code
Message-ID: <20090728163104.GA15033@pengutronix.de>
References: <Pine.LNX.4.64.0907281755000.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907281755000.28189@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2009 at 05:55:33PM +0200, Julia Lawall wrote:
>=20
> From: Julia Lawall <julia@diku.dk>
>=20
> This code is not executed before ds1307->rtc has been successfully
> initialized to the result of calling rtc_device_register.  Thus the test
> that ds1307->rtc is not NULL is always true.
>=20
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @match exists@
> expression x, E;
> statement S1, S2;
> @@
>=20
> x =3D rtc_device_register(...)
> ... when !=3D x =3D E
> (
> *  if (x =3D=3D NULL || ...) S1 else S2
> |
> *  if (x =3D=3D NULL && ...) S1 else S2
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpvJ8gACgkQD27XaX1/VRsSigCfTHe/XDNQayLcO0AEucqjr9rH
PT4AoIVxzAQLC7hVJ/s1QBfelzqno9AM
=pgDD
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
