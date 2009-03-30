Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZC3Bgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZC3Bgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZC3Bgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:36:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:62611 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbZC3Bgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,443,1233561600"; 
   d="asc'?scan'208";a="125470523"
Subject: Re: Accelerate GCM with PCLMULQDQ-NI
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090329074326.GB11735@gondor.apana.org.au>
References: <1237366332.24215.260.camel@yhuang-dev.sh.intel.com>
	 <20090329074326.GB11735@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZT24eGYiBapoGWK5d4tS"
Date: Mon, 30 Mar 2009 09:36:35 +0800
Message-Id: <1238376995.6639.80.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZT24eGYiBapoGWK5d4tS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-29 at 15:43 +0800, Herbert Xu wrote:
> On Wed, Mar 18, 2009 at 04:52:12PM +0800, Huang Ying wrote:
> >
> > To accelerate GCM with it, I make the following design:
> >=20
> > 1. Implement ghash as an ahash algorithm, Use ghash in gcm
> > implementation.
> > 2. Provide a new implementation of ghash with PCLMULQDQ-NI.
> >=20
> > What do you think about that?
>=20
> Sounds OK to me.  I presume the choice of ahash instead of shash
> is due to the use of XMM registers, just like AES?

Yes, because PCLMULQDQ touches XMMs too. Just like AES, there is a raw
shash: ghash-clmul and an ahash via cryptd(ghash-clmul).

Best Regards,
Huang Ying


--=-ZT24eGYiBapoGWK5d4tS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknQIh8ACgkQKhFGF+eHlpjiyQCdGZnZKSWJiZpyQET0G2m66wvC
UAsAnii91nPpLBW1pHWMKdt5aAIhMn0+
=PIwQ
-----END PGP SIGNATURE-----

--=-ZT24eGYiBapoGWK5d4tS--

