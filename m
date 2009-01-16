Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbZAPDKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbZAPDKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZAPDKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:10:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:48676 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbZAPDKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:10:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,274,1231142400"; 
   d="asc'?scan'208";a="422844903"
Subject: [RFC] per-CPU cryptd thread implementation based on workqueue
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yQm4J2R5nORAQuLHb0py"
Date: Fri, 16 Jan 2009 11:10:36 +0800
Message-Id: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yQm4J2R5nORAQuLHb0py
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Herbert,

The scalability of current cryptd implementation is not good. So a
per-CPU cryptd kthread implementation is necessary. The per-CPU kthread
pool implementation need to consider many issues such as CPU hotplug, so
I suggest to base cryptd kthread implementation on workqueue, that is,
create a dedicate workqueue for crypto subsystem. This way, chainiv can
use this crypto workqueue too.

I will implement it if you have no plan to do it yourself.

Best Regards,
Huang Ying


--=-yQm4J2R5nORAQuLHb0py
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklv+qoACgkQKhFGF+eHlphKzACfQlNVSZUsKiPeCypAnCNlqJxZ
tGYAoIH/NMlRCMUcGKKGv3dGifeC+WEj
=Dn+/
-----END PGP SIGNATURE-----

--=-yQm4J2R5nORAQuLHb0py--

