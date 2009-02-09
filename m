Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbZBIIf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbZBIIf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZBIIfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:35:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52244 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZBIIfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:35:47 -0500
Date: Mon, 9 Feb 2009 09:35:37 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Frank Seidel <frank@f-seidel.de>, Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090209083537.GA3438@pengutronix.de>
References: <498C3EEA.5060508@suse.de> <20090208000553.059a0732@hyperion.delvare> <498EDA18.1090300@f-seidel.de> <20090208144751.46184041@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20090208144751.46184041@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I mean the (first) printk in the loop, not the last printk in this
> function. So what I am suggesting is:
>=20
> +	printk(KERN_DEBUG);
> 	for (i =3D 0; i < i2c->irqlogidx; i++)
> 		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
> 	printk("\n");

Hmm, I was told (by Jean ;)) that every printk should end with newline,
otherwise it might get interrupted with other output -> mess.

Bye,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmP6tkACgkQD27XaX1/VRvAFACghhFugQU2E+yF8jSMZ2W3tU0n
m9AAoIzP6diwB1m0Nou2CUegk+SHBSKF
=pkji
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
