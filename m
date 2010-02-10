Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0BJBfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:35:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab0BJBfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BGKHXRMGSVMi2htZ67Kyov82IE5GHeYbHDOJX7QGQX6Uyv6pjvlfFQSbQrrpCgmlHJ
         gZ/YVP1nQn9p33KLDg6HEkLlTWnAkUr3Sy7Bn/SAmcYJLT3YPx3UuhJUTf9kRR1jPT1t
         Ggi/BjFNyUTrSgFDmA6CyCbuQACfOEUlQQiow=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in ecb.c
Date: Wed, 10 Feb 2010 02:35:08 +0100
Message-Id: <1265765709-26802-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/ecb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/ecb.c b/crypto/ecb.c
index a46838e..935cfef 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -55,7 +55,7 @@ static int crypto_ecb_crypt(struct blkcipher_desc *desc,
 
 		do {
 			fn(crypto_cipher_tfm(tfm), wdst, wsrc);
-	
+
 			wsrc += bsize;
 			wdst += bsize;
 		} while ((nbytes -= bsize) >= bsize);
-- 
1.6.6.1

