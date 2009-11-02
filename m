Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZKBQyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZKBQyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZKBQyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:54:51 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:55971
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935AbZKBQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:54:50 -0500
Date: Mon, 2 Nov 2009 14:54:51 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: trivial@kernel.org, David Brownell <dbrownell@users.sourceforge.net>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [PATCH] trivial: some fixes in spi
	documentation
Message-ID: <20091102165451.GA20277@vespa.holoscopio.com>
References: <1256938094-8137-1-git-send-email-cascardo@holoscopio.com> <20091102121334.GA4696@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20091102121334.GA4696@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2009 at 01:13:34PM +0100, Wolfram Sang wrote:
> Hi,
>=20
> the typo fixes look good, still...
>=20
> On Fri, Oct 30, 2009 at 07:28:14PM -0200, Thadeu Lima de Souza Cascardo w=
rote:
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  Documentation/spi/spi-summary |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summ=
ary
> > index deab51d..607aa97 100644
> > --- a/Documentation/spi/spi-summary
> > +++ b/Documentation/spi/spi-summary
> > @@ -121,7 +121,7 @@ active.  So the master must set the clock to inacti=
ve before selecting
> >  a slave, and the slave can tell the chosen polarity by sampling the
> >  clock level when its select line goes active.  That's why many devices
> >  support for example both modes 0 and 3:  they don't care about polarit=
y,
> > -and alway clock data in/out on rising clock edges.
> > +and always clock data in/out on rising clock edges.
> > =20
> > =20
> >  How do these driver programming interfaces work?
> > @@ -236,7 +236,7 @@ And SOC-specific utility code might look something =
like:
> >  		struct mysoc_spi_data *pdata2;
> > =20
> >  		pdata2 =3D kmalloc(sizeof *pdata2, GFP_KERNEL);
> > -		*pdata2 =3D pdata;
> > +		*pdata2 =3D *pdata;
>=20
> ... this looks correct, because a few lines above it is stated:
>=20
>         static struct mysoc_spi_data __initdata pdata =3D { ... };
>=20
> No pointer here. But yeah, pretty confusing for an example.
>=20

Oh. Right. I may have thought that was an array or something. I will
resend without it or think of a more clear example (perhaps, get some
real but simple code).

> >  		...
> >  		if (n =3D=3D 2) {
> >  			spi2->dev.platform_data =3D pdata2;
> > @@ -427,8 +427,8 @@ any more such messages.
> >      it, should only be used with small amounts of data where the
> >      cost of an extra copy may be ignored.  It's designed to support
> >      common RPC-style requests, such as writing an eight bit command
> > -    and reading a sixteen bit response -- spi_w8r16() being one its
> > -    wrappers, doing exactly that.
> > +    and reading a sixteen bit response -- spi_w8r16() being one of
> > +    its wrappers, doing exactly that.
> > =20
> >  Some drivers may need to modify spi_device characteristics like the
> >  transfer mode, wordsize, or clock rate.  This is done with spi_setup(),
> > --=20
> > 1.6.3.3
> >=20
> >=20
> > -----------------------------------------------------------------------=
-------
> > Come build with us! The BlackBerry(R) Developer Conference in SF, CA
> > is the only developer event you need to attend this year. Jumpstart your
> > developing skills, take BlackBerry mobile applications to market and st=
ay=20
> > ahead of the curve. Join us from November 9 - 12, 2009. Register now!
> > http://p.sf.net/sfu/devconference
> > _______________________________________________
> > spi-devel-general mailing list
> > spi-devel-general@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/spi-devel-general
>=20
> --=20
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |



--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrvDtoACgkQyTpryRcqtS0isACfRo5J5o+I5OsMK17bq/vzSrSC
SRMAoIGzFNTi8/dw2Rx82Q4eJ/JWhzDs
=MIY+
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
