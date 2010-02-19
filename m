Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0BSAVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:21:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63509 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0BSAVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IfGgBWd2Hsl2WgXALq5diZtPgnFde1SCiLx4N94lgVS4Kt71kqdyLrq86vXfz6kA0+
         UiDgGQWtL8hTliEIv5DxNsJwNFrVGszlmeYd8TKBQaMbB19h77kDlDh+72ujBLeO9Ghq
         mjTyA6BU3Sp93ztQYwgV6wvmYCq4Ypp0tTk4k=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in aes_generic
Date: Fri, 19 Feb 2010 01:21:24 +0100
Message-Id: <1266538885-3079-1-git-send-email-richih.mailinglist@gmail.com>
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

