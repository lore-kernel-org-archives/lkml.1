Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0BSAYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:24:36 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52179 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0BSAYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:24:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LkJZy69FwfE+kdsSdP6Ijl5ueUjSpItiJRBBowwU1vnb11hMIijYqxNbLID1TocK2X
         71Te/Qgalzw5m+fgTPAww+1uMz4csMi3hKJlAyyYdmEtd1LI3z8/u8//VdJBjh6GoZsS
         ZbpfIE6+cT7zvJushe5sZYB2s/7bEuv0CS2lA=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Steffen Klassert <steffen.klassert@secunet.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] crypto: xcbc - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:24:03 +0100
Message-Id: <1266539044-3716-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/xcbc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index bb7b67f..63e9181 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -24,8 +24,8 @@
 #include <linux/kernel.h>
 
 static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
-			   0x02020202, 0x02020202, 0x02020202, 0x02020202,
-			   0x03030303, 0x03030303, 0x03030303, 0x03030303};
+                           0x02020202, 0x02020202, 0x02020202, 0x02020202,
+                           0x03030303, 0x03030303, 0x03030303, 0x03030303};
 
 /*
  * +------------------------
@@ -158,7 +158,7 @@ static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 		*p = 0x80;
 		p++;
 
-		rlen = bs - ctx->len -1;
+		rlen = bs - ctx->len - 1;
 		if (rlen)
 			memset(p, 0, rlen);
 
@@ -211,7 +211,7 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
-	switch(alg->cra_blocksize) {
+	switch (alg->cra_blocksize) {
 	case 16:
 		break;
 	default:
-- 
1.6.6.1

