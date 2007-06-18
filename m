Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbXFRFRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbXFRFRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXFRFRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:17:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46869 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbXFRFRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:17:40 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Date: Mon, 18 Jun 2007 01:17:46 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706171854.24763.vapier@gentoo.org> <20070617221140.f1564f92.akpm@linux-foundation.org>
In-Reply-To: <20070617221140.f1564f92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart90940402.jTUKYM2Jo7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706180117.46809.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart90940402.jTUKYM2Jo7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 June 2007, Andrew Morton wrote:
> On Sun, 17 Jun 2007 18:54:24 -0400 Mike Frysinger <vapier@gentoo.org> wro=
te:
> > This updates scripts/hdrschecks.sh by grepping for asm() constructs and
> > rejecting them in favor of __asm__() in exported headers.
>
> And does the kernel pass these checks?

nope ... should i audit the arches before this gets merged ?

> Which architectures have been tested?

i386 passes, blackfin/x86_64 fail a simple asm/unistd.h, and x86_64 fails a=
=20
bunch in asm/msr.h, but last time i tried to patch that, the maintainer sai=
d=20
they were going to be hiding a bunch of that stuff anyways
=2Dmike

--nextPart90940402.jTUKYM2Jo7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARnYVekFjO5/oN/WBAQLVsQ//U5RLDSEvjpnQGpZLVSarPRV2Dxfl6ECJ
vcLU4BSqJfrRD4YXb/UdC6RptinTzOhK/ZioORJ+Q9AScrYNrCNpJChY2TsSxTmK
so4a0P9S7LUcrjGO5YDl9wojYysxuAMB2A8QiEQ2iFM/yED+9nM30psZiKZ93pXI
LCI2SnjVSCqO0NuZwvebC9pDiPPkj0Khiyo6s3eunPBJwYD7NWwLwKFybI60NC+S
+t0UGKcr/HYbio1Kd6KB+m5czlrwRPr7IqtEjIeMDmXlrVVjXdguL1qANIxVgII5
/RNyiXxYfUQjlHhg9dBd4hWUexo0OzLFfLaknP6GNvWVtFR431+VNhKKcoZ/unEI
jc4wjoDVSqkl3cFfhLamS9zrM45SUmSYrWnRWHm5rWcit4qiGo5naCUFmWg+oa7d
yp+fLvqUes2jSwcEVUYVawJNRh5VfVsoseM8qyTxkyJS+In5Yg4dcflsynX9p+WN
eNkM8yMW9MBbtprgwDwNwOO3lyWtTpLw4KPsjOUfhZtoBODhagREs6+uHz4m3Nxs
WGOUws1hBIW0TdefKydlDwyeKuVv0CtQy9q1nnPfhpJzjr3kHdm8gxx1Hzj5o0vR
x/CbraTotMGl2QZQH0d4ThCEDnuCV5GR7XkfScIT4k0aFVz860yf50nF66OwaX2d
43sHn0IpuV8=
=JLqW
-----END PGP SIGNATURE-----

--nextPart90940402.jTUKYM2Jo7--
