Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0BSAWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:22:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63509 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0BSAWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:22:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T/iEVjzhDP8JnS+zW2fEnv9HbgGOeHGakJ2wPG3nS3LeKylJqOXB3Y1/LHNeV9hMks
         /MwHybQFRFdm4iti8rPSoI37nMp/fBA8io/hzFguwS5hKX0/pTbQTmxvcclyYFCHfi5S
         0Ol7vP/LNWAD1AQv6j5l3NdOdFLmPGiJrR5pM=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] crypto: md5 - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:21:56 +0100
Message-Id: <1266538917-3212-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/md5.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/md5.c b/crypto/md5.c
index 83eb529..d7cc5f8 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API.
  *
  * MD5 Message Digest Algorithm (RFC1321).
@@ -8,10 +8,10 @@
  *
  * Copyright (c) Cryptoapi developers.
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -201,7 +201,7 @@ static int md5_final(struct shash_desc *desc, u8 *out)
 
 	*p++ = 0x80;
 	if (padding < 0) {
-		memset(p, 0x00, padding + sizeof (u64));
+		memset(p, 0x00, padding + sizeof(u64));
 		md5_transform_helper(mctx);
 		p = (char *)mctx->block;
 		padding = 56;
-- 
1.6.6.1

