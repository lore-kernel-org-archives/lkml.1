Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZCFBCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZCFBCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 20:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZCFBB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 20:01:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:64420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZCFBB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 20:01:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,310,1233561600"; 
   d="asc'?scan'208";a="117336648"
Subject: Re: [PATCH 3/3] crypto: Add AES-NI support for more modes
From: Huang Ying <ying.huang@intel.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305120041.GB4101@Chamillionaire.breakpoint.cc>
References: <1236219949.24215.39.camel@yhuang-dev.sh.intel.com>
	 <20090305120041.GB4101@Chamillionaire.breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a/cLVGKuZQV4sA0TqL++"
Date: Fri, 06 Mar 2009 09:01:53 +0800
Message-Id: <1236301313.24215.61.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a/cLVGKuZQV4sA0TqL++
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-05 at 20:00 +0800, Sebastian Andrzej Siewior wrote:
> * Huang Ying | 2009-03-05 10:25:49 [+0800]:
>=20
> >--- a/crypto/Kconfig
> >+++ b/crypto/Kconfig
> >@@ -488,6 +488,7 @@ config CRYPTO_AES_NI_INTEL
> > 	select CRYPTO_AES_X86_64
> > 	select CRYPTO_CRYPTD
> > 	select CRYPTO_ALGAPI
> >+	select CRYPTO_FPU
> > 	help
> > 	  Use Intel AES-NI instructions for AES algorithm.
> >=20
> >
> Please add that you also accelerate block modes like lrw & xts. A full
> list would be nice. There is no direct HW-support for this block modes
> where the user could expect this from a marketing paper :)

OK, I will add that.

Best Regards,
Huang Ying


--=-a/cLVGKuZQV4sA0TqL++
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmwdf0ACgkQKhFGF+eHlpga+QCdHUGTjvYtULNE06BbjZgHqGCZ
FUEAn1QeOREc/Gwb8g6esdBzymgIpplw
=8NgN
-----END PGP SIGNATURE-----

--=-a/cLVGKuZQV4sA0TqL++--

