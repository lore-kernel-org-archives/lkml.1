Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbZAOJWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbZAOJWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZAOJVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:21:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:22169 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZAOJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:21:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,268,1231142400"; 
   d="asc'?scan'208";a="422581265"
Subject: Re: [PATCH crypto -v4 1/2] AES-NI: Add support to
	access	underlying blkcipher under cryptd ablkcipher
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090115084750.GA32239@gondor.apana.org.au>
References: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com>
	 <20090115084750.GA32239@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AD0AjA9WQ+R5xnAG6R87"
Date: Thu, 15 Jan 2009 17:21:47 +0800
Message-Id: <1232011307.5937.204.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AD0AjA9WQ+R5xnAG6R87
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:47 +0800, Herbert Xu wrote:
> On Thu, Jan 15, 2009 at 04:28:33PM +0800, Huang Ying wrote:
> >
> > +	tfm =3D crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
> > +	BUG_ON(crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D
> > +	       THIS_MODULE);
>=20
> You need to check whether tfm is an error before dereferencing it.
> Also it's probably better to free the tfm and return an error rather
> than invoking BUG.

Why do we need this check? Someone else may register cryptd template?
Which error number should be return? -EINVAL?

> > --- a/include/crypto/algapi.h
> > +++ b/include/crypto/algapi.h
>=20
> Please create a new file for this, e.g., include/crypto/cryptd.h.

OK. I will do that.

Best Regards,
Huang Ying

--=-AD0AjA9WQ+R5xnAG6R87
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklvACkACgkQKhFGF+eHlpittACfR9st94CYff7LlUjcv0eOYcbJ
1lYAn2n7yJGbuzpP2ozmmeKRK0FuglfD
=J46t
-----END PGP SIGNATURE-----

--=-AD0AjA9WQ+R5xnAG6R87--

