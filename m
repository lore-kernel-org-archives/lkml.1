Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab0CGHbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 02:31:21 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59264 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0CGHbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 02:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xPaxSYzf619Vr8vx+xJ0Bj71KwimbXvwmkZP62rJdEqlXbugrmw08C1QXz5pzp8RB+
         xWLLnPhDV9tUq5mlXMP3aP0Pc9nsUEoWRXjTGFvFYpvT3IWYSQ4o383O73iTUM0+M6df
         Rfy3plZ8S6O7ge1pCAQf26hhagnY59/uftRII=
From: Stewart Malik <mali0037@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: richih.mailinglist@gmail.com, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stewart Malik <mali0037@gmail.com>
Subject: [PATCH] CRYPTO: Blowfish: Converted spaces to tabs in crypto/blowfish.c
Date: Sun,  7 Mar 2010 18:01:06 +1030
Message-Id: <1267947066-22399-1-git-send-email-mali0037@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 crypto/blowfish.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index a67d52e..29c5389 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -309,9 +309,13 @@ static const u32 bf_sbox[256 * 4] = {
 #define GET32_0(x) (((x) >> (24)) & (0xff))
 
 #define bf_F(x) (((S[GET32_0(x)] + S[256 + GET32_1(x)]) ^ \
-          S[512 + GET32_2(x)]) + S[768 + GET32_3(x)])
+		S[512 + GET32_2(x)]) + S[768 + GET32_3(x)])
 
-#define ROUND(a, b, n)  b ^= P[n]; a ^= bf_F (b)
+#define ROUND(a, b, n)
+	do {
+		b ^= P[n];
+		a ^= bf_F(b);
+	} while (0)
 
 /*
  * The blowfish encipher, processes 64-bit blocks.
@@ -452,17 +456,17 @@ static int bf_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 static struct crypto_alg alg = {
 	.cra_name		=	"blowfish",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	BF_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct bf_ctx),
-	.cra_alignmask		=	3,
+	.cra_blocksize	=	BF_BLOCK_SIZE,
+	.cra_ctxsize	=	sizeof(struct bf_ctx),
+	.cra_alignmask	=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	BF_MIN_KEY_SIZE,
 	.cia_max_keysize	=	BF_MAX_KEY_SIZE,
-	.cia_setkey   		= 	bf_setkey,
-	.cia_encrypt 		=	bf_encrypt,
-	.cia_decrypt  		=	bf_decrypt } }
+	.cia_setkey		=	bf_setkey,
+	.cia_encrypt	=	bf_encrypt,
+	.cia_decrypt	=	bf_decrypt } }
 };
 
 static int __init blowfish_mod_init(void)
-- 
1.6.0.4

