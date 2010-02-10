Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0BJBsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:48:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:11394 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0BJBsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:48:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mlWRV/0XZdjfIm7rxQQBqLpTZ9/HGmP2pdGD2KZzLkN8OOuUXIWUjz7VLnH0g2lKYQ
         Obg3D51d/dKTrXwdg5N1oWDdd4AgigH3j8MY5kblgAcx08looTm1PnGDDRKzu1r/RuQC
         /iba+t1CWRxu+bs35RuwWo6KNUlEiAipbV1fs=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in aes_generic
Date: Wed, 10 Feb 2010 02:48:11 +0100
Message-Id: <1265766491-28159-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/aes_generic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index e78b7ee..a68c73d 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API.
  *
  * AES Cipher Algorithm.
@@ -1127,7 +1127,7 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
 
 #define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
 
-#define imix_col(y,x)	do {		\
+#define imix_col(y, x)	do {		\
 	u	= star_x(x);		\
 	v	= star_x(u);		\
 	w	= star_x(v);		\
-- 
1.6.6.1

