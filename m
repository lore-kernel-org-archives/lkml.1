Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZB0FcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZB0FcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZB0FcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:32:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:11018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbZB0FcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:32:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,274,1233561600"; 
   d="asc'?scan'208";a="668936826"
Subject: Bug of dm-crypt?
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C8aD9h2TUTjVKanprVlB"
Date: Fri, 27 Feb 2009 13:31:56 +0800
Message-Id: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C8aD9h2TUTjVKanprVlB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Herbert,

I had ever heard from you that the only thing guaranteed in the
completion function of async ablkcipher cryption is the req->data has
the value you set before. The request pointer itself may be changed. But
in dm-crypt, I found they rely on request pointer in completion
function: kcryptd_async_done. This makes my AES-NI cryptd usage panic.

Do you think that is a bug?

Best Regards,
Huang Ying


--=-C8aD9h2TUTjVKanprVlB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmneskACgkQKhFGF+eHlphtiwCfQ9im6KaQMLtOzmVh3i++vMum
KNEAn2iRukI6aTTMK19O6JcRkHW4GPQf
=36Y9
-----END PGP SIGNATURE-----

--=-C8aD9h2TUTjVKanprVlB--

