Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0BSAWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:22:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63509 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0BSAWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CGLNxsYAbwhaJzbMxpZv0CGDjEB9SrX1hj0q9e4iwNm2T/wslGKmRPpO5telV1B8KP
         32yQLac34jb5kSejYjWr1qppZJfB6TTzHHr6oJLFmaideSG8YJiRR2Kwr7zwJ3Uo+/a3
         4ejGPhP3gAhp0n1Zx8be9tojR/ffQGZIam6xE=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/19] crypto: salsa20_generic - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:08 +0100
Message-Id: <1266538929-3278-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/salsa20_generic.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index eac10c1..31f03bb 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -50,8 +50,7 @@ Public domain.
 	(((u32)((p)[0])      ) | ((u32)((p)[1]) <<  8) | \
 	 ((u32)((p)[2]) << 16) | ((u32)((p)[3]) << 24)   )
 
-struct salsa20_ctx
-{
+struct salsa20_ctx {
 	u32 input[16];
 };
 
@@ -98,7 +97,7 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
 	for (i = 0; i < 16; ++i)
 		x[i] += input[i];
 	for (i = 0; i < 16; ++i)
-		U32TO8_LITTLE(output + 4 * i,x[i]);
+		U32TO8_LITTLE(output + 4 * i, x[i]);
 }
 
 static const char sigma[16] = "expand 32-byte k";
@@ -188,8 +187,7 @@ static int encrypt(struct blkcipher_desc *desc,
 
 	salsa20_ivsetup(ctx, walk.iv);
 
-	if (likely(walk.nbytes == nbytes))
-	{
+	if (likely(walk.nbytes == nbytes)) {
 		salsa20_encrypt_bytes(ctx, walk.dst.virt.addr,
 				      walk.src.virt.addr, nbytes);
 		return blkcipher_walk_done(desc, &walk, 0);
@@ -248,5 +246,5 @@ module_init(salsa20_generic_mod_init);
 module_exit(salsa20_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION ("Salsa20 stream cipher algorithm");
+MODULE_DESCRIPTION("Salsa20 stream cipher algorithm");
 MODULE_ALIAS("salsa20");
-- 
1.6.6.1

