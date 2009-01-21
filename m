Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZAUVxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZAUVxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZAUVxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:53:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44636 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZAUVxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:53:00 -0500
Date: Thu, 22 Jan 2009 08:52:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] regulator: Hoist struct regulator_dev out of core to
 fix notifiers
Message-Id: <20090122085253.fc2782d9.sfr@canb.auug.org.au>
In-Reply-To: <1232549863.16911.350.camel@vega.slimlogic.co.uk>
References: <1232546920-14915-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1232549863.16911.350.camel@vega.slimlogic.co.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Jan_2009_08_52_53_+1100_T8c4U2Qa7okdHpVM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Jan_2009_08_52_53_+1100_T8c4U2Qa7okdHpVM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Jan 2009 14:57:43 +0000 Liam Girdwood <lrg@slimlogic.co.uk> wrot=
e:
>
> On Wed, 2009-01-21 at 14:08 +0000, Mark Brown wrote:
> > Commit 872ed3fe176833f7d43748eb88010da4bbd2f983 caused regulator drivers
> > to take the struct regulator_dev lock themselves which requires that the
> > struct be visible to them. Band aid this by making the struct visible.
> >=20
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  drivers/regulator/core.c         |   27 ---------------------------
> >  include/linux/regulator/driver.h |   32 ++++++++++++++++++++++++++++++=
++
> >  2 files changed, 32 insertions(+), 27 deletions(-)
>=20
> Applied and fixed.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Jan_2009_08_52_53_+1100_T8c4U2Qa7okdHpVM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl3mTUACgkQjjKRsyhoI8zUcgCgpYayZZlzenQlqxcAlIZDFk7e
/aMAnRlPbK1kC0Sxdn8CZO49YLfjkxNW
=dZXF
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Jan_2009_08_52_53_+1100_T8c4U2Qa7okdHpVM--
