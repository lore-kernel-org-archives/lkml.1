Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbYJVJbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbYJVJbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYJVJb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:31:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52503 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYJVJb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:31:26 -0400
Date: Wed, 22 Oct 2008 20:31:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mfd/wm8350: don't export static functions
Message-Id: <20081022203112.5a213e8c.sfr@canb.auug.org.au>
In-Reply-To: <20081016120416.GA5753@rakim.wolfsonmicro.main>
References: <20081016204754.a41646e5.sfr@canb.auug.org.au>
	<20081016120416.GA5753@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Oct_2008_20_31_12_+1100_r+.2wIY8=+WLXGWb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Oct_2008_20_31_12_+1100_r+.2wIY8=+WLXGWb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, 16 Oct 2008 13:04:16 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Thu, Oct 16, 2008 at 08:47:54PM +1100, Stephen Rothwell wrote:
> > Today's linux-next build (powerpc allyesconfig) failed like this:
>=20
> > drivers/mfd/wm8350-core.c:1131: error: __ksymtab_wm8350_create_cache ca=
uses a section type conflict
>=20
> > Caused by commit 89b4012befb1abca5e86d232bc0e2a797b0d9825 ("mfd: Core
> > support for the WM8350 AudioPlus PMIC"). wm8350_create_cache is not used
> > elsewhere, so remove the EXPORT_SYMBOL.
>=20
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I thought that this had been applied, but I have had to apply it to my
tree today again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Oct_2008_20_31_12_+1100_r+.2wIY8=+WLXGWb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj+8uAACgkQjjKRsyhoI8xNjwCdETtkt2Q6PjaPlVDF/CxyyqLy
mEMAn2DX14shHWmFTfYwge1Tv6Q2KbDt
=Mztl
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Oct_2008_20_31_12_+1100_r+.2wIY8=+WLXGWb--
