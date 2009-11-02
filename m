Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZKBMNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZKBMNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZKBMNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:13:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44074 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbZKBMNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:13:46 -0500
Date: Mon, 2 Nov 2009 13:13:34 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: trivial@kernel.org, David Brownell <dbrownell@users.sourceforge.net>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [PATCH] trivial: some fixes in spi
	documentation
Message-ID: <20091102121334.GA4696@pengutronix.de>
References: <1256938094-8137-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1256938094-8137-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

the typo fixes look good, still...

On Fri, Oct 30, 2009 at 07:28:14PM -0200, Thadeu Lima de Souza Cascardo wro=
te:
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/spi/spi-summary |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summary
> index deab51d..607aa97 100644
> --- a/Documentation/spi/spi-summary
> +++ b/Documentation/spi/spi-summary
> @@ -121,7 +121,7 @@ active.  So the master must set the clock to inactive=
 before selecting
>  a slave, and the slave can tell the chosen polarity by sampling the
>  clock level when its select line goes active.  That's why many devices
>  support for example both modes 0 and 3:  they don't care about polarity,
> -and alway clock data in/out on rising clock edges.
> +and always clock data in/out on rising clock edges.
> =20
> =20
>  How do these driver programming interfaces work?
> @@ -236,7 +236,7 @@ And SOC-specific utility code might look something li=
ke:
>  		struct mysoc_spi_data *pdata2;
> =20
>  		pdata2 =3D kmalloc(sizeof *pdata2, GFP_KERNEL);
> -		*pdata2 =3D pdata;
> +		*pdata2 =3D *pdata;

=2E.. this looks correct, because a few lines above it is stated:

        static struct mysoc_spi_data __initdata pdata =3D { ... };

No pointer here. But yeah, pretty confusing for an example.

>  		...
>  		if (n =3D=3D 2) {
>  			spi2->dev.platform_data =3D pdata2;
> @@ -427,8 +427,8 @@ any more such messages.
>      it, should only be used with small amounts of data where the
>      cost of an extra copy may be ignored.  It's designed to support
>      common RPC-style requests, such as writing an eight bit command
> -    and reading a sixteen bit response -- spi_w8r16() being one its
> -    wrappers, doing exactly that.
> +    and reading a sixteen bit response -- spi_w8r16() being one of
> +    its wrappers, doing exactly that.
> =20
>  Some drivers may need to modify spi_device characteristics like the
>  transfer mode, wordsize, or clock rate.  This is done with spi_setup(),
> --=20
> 1.6.3.3
>=20
>=20
> -------------------------------------------------------------------------=
-----
> Come build with us! The BlackBerry(R) Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay=
=20
> ahead of the curve. Join us from November 9 - 12, 2009. Register now!
> http://p.sf.net/sfu/devconference
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkruzO4ACgkQD27XaX1/VRttcACgq+6NGGvxtwflQt3uVs5LbyDx
2FMAn3JhWqcmdr8hDzA+AJctZ07HxPVW
=BOYp
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
