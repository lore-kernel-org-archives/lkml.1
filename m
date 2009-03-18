Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZCRIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZCRIwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZCRIwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:52:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:22920 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbZCRIwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:52:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,383,1233561600"; 
   d="asc'?scan'208";a="395441539"
Subject: Accelerate GCM with PCLMULQDQ-NI
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EkkVgnBVuB/dPcXZpoic"
Date: Wed, 18 Mar 2009 16:52:12 +0800
Message-Id: <1237366332.24215.260.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EkkVgnBVuB/dPcXZpoic
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

In addition to AES-NI, Intel will provide PCLMULQDQ-NI (carry-less
multiplication) in future CPU to accelerate GCM mode. The document can
be found here:

http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-=
usage-for-computing-the-gcm-mode/

It follows the same design as that of AES-NI, that is, XMM registers are
used.

To accelerate GCM with it, I make the following design:

1. Implement ghash as an ahash algorithm, Use ghash in gcm
implementation.
2. Provide a new implementation of ghash with PCLMULQDQ-NI.

What do you think about that?

Best Regards,
Huang Ying


--=-EkkVgnBVuB/dPcXZpoic
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknAtjMACgkQKhFGF+eHlpgW2gCeOAf4TntXHaISbNu7uTqHvjKe
oSMAoIw5qb2+9mA87+vqQYtEV5GvLsMa
=9uRP
-----END PGP SIGNATURE-----

--=-EkkVgnBVuB/dPcXZpoic--

