Return-Path: <linux-kernel-owner+w=401wt.eu-S935359AbXGRSEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359AbXGRSEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935812AbXGRSEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:04:01 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:38139 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935797AbXGRSEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:04:00 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: adobriyan@sw.ru
Subject: [PATCH] Revert part of 3f1b0e1f287547903f11fa1e6de7d2765597766e
Date: Wed, 18 Jul 2007 21:03:13 +0300
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1810460.kzW5aH01a0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707182103.13500.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1810460.kzW5aH01a0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

With 3f1b0e1f287547903f11fa1e6de7d2765597766e Linus's current git tree star=
ts=20
to ignore any *.orig or *.rej files (for example "git status" cannot show=20
what are they) but if there are some *.orig or *.rej files exists, for=20
whatever reason, that means some unresolved merge conflicts occured for tha=
t=20
code tree and this tree is no longer trusted so better not to ignore these.

Signed-off-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
=20
 .gitignore |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 8d15830..060a71d 100644
=2D-- a/.gitignore
+++ b/.gitignore
@@ -45,6 +45,3 @@ series
=20
 # cscope files
 cscope.*
=2D
=2D*.orig
=2D*.rej


Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1810460.kzW5aH01a0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGnlXgy7E6i0LKo6YRAqtWAKCnXpLxcIpmLhGSmMVXYRqB4HLrXACfcdVa
IMaGDc7W+The/9kI8ic9J0Q=
=UxhB
-----END PGP SIGNATURE-----

--nextPart1810460.kzW5aH01a0--
