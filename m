Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZAMCtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZAMCtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZAMCtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:49:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:25984 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZAMCtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:49:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,256,1231142400"; 
   d="asc'?scan'208";a="421833798"
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090113023937.GA14460@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
	 <20090109070144.GA7358@gondor.apana.org.au>
	 <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
	 <20090112104335.GA4942@gondor.apana.org.au>
	 <1231814053.5937.120.camel@yhuang-dev.sh.intel.com>
	 <20090113023937.GA14460@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+842ud+X4RNHP3dxuXuy"
Date: Tue, 13 Jan 2009 10:49:07 +0800
Message-Id: <1231814947.5937.124.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+842ud+X4RNHP3dxuXuy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 10:39 +0800, Herbert Xu wrote:
> On Tue, Jan 13, 2009 at 10:34:13AM +0800, Huang Ying wrote:
> >=20
> > static void ablk_complete(struct crypto_async_request *req, int err)
> > {
> >         struct ablkcipher_request *ablk_req =3D ablkcipher_request_cast=
(req);
> >         struct async_aes_req_ctx *req_ctx =3D
> >                 ablk_aes_req_ctx(ablk_req, crypto_ablkcipher_reqtfm(abl=
k_req));
>=20
> This is not guaranteed to work.  Your completion caller may be
> called with a request pointer other than the one that you passed
> to it.  The only thing we guarantee is that req->data has the
> value that you set at the beginning.

I can set req->data in xx_encrypt() to my original request to solve this
issue. Except that, does this solution work?

Best Regards,
Huang Ying


--=-+842ud+X4RNHP3dxuXuy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklsAR0ACgkQKhFGF+eHlpizzACfU1EuelmD5xIoqPSy+JX1vhLq
xBgAniZ1f6NDnDJ70wkTNr2804vuv49k
=gtbc
-----END PGP SIGNATURE-----

--=-+842ud+X4RNHP3dxuXuy--

