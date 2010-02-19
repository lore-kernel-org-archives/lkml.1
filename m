Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0BSAXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:23:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63509 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0BSAX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:23:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Jdj8gav6MRTrT+SbeMCzo7FHiieWS2Lcye5X3ustTkKi4wO3SrI9XkI3jHtWkyn2Ai
         2vlug04dncS3ya6E6JWxdPaZEvZiUhoUdhj78NeL+Ec32mZ1i327OFahC2MZ0inZ0t6T
         Ov4WOaOjCsKNk2mzPAapxriMo8hnDuCdveo+k=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Jarod Wilson <jarod@redhat.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] crypto: testmgr - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:23:07 +0100
Message-Id: <1266538988-3575-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/testmgr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7620bfc..520127a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -657,7 +657,7 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 		goto out_nobuf;
 
 	if (enc == ENCRYPT)
-	        e = "encryption";
+		e = "encryption";
 	else
 		e = "decryption";
 
@@ -737,7 +737,7 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		goto out_nobuf;
 
 	if (enc == ENCRYPT)
-	        e = "encryption";
+		e = "encryption";
 	else
 		e = "decryption";
 
@@ -952,7 +952,7 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		int ilen;
 		unsigned int dlen = COMP_BUF_SIZE;
 
-		memset(result, 0, sizeof (result));
+		memset(result, 0, sizeof(result));
 
 		ilen = ctemplate[i].inlen;
 		ret = crypto_comp_compress(tfm, ctemplate[i].input,
@@ -985,7 +985,7 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		int ilen;
 		unsigned int dlen = COMP_BUF_SIZE;
 
-		memset(result, 0, sizeof (result));
+		memset(result, 0, sizeof(result));
 
 		ilen = dtemplate[i].inlen;
 		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
-- 
1.6.6.1

