Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXGNEyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXGNEyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 00:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXGNEyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 00:54:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60729 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbXGNEyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 00:54:16 -0400
Date: Sat, 14 Jul 2007 06:53:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] crypto/Kconfig: remove "default m"s
Message-ID: <20070714045349.GF3565@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Other options requiring specific block cipher algorithms already have 
the appropriate select's.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 crypto/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.22-rc6-mm1/crypto/Kconfig.old	2007-07-14 06:24:23.000000000 +0200
+++ linux-2.6.22-rc6-mm1/crypto/Kconfig	2007-07-14 06:24:30.000000000 +0200
@@ -146,7 +146,6 @@
 	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	default m
 	help
 	  ECB: Electronic CodeBook mode
 	  This is the simplest block cipher algorithm.  It simply encrypts
@@ -156,7 +155,6 @@
 	tristate "CBC support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	default m
 	help
 	  CBC: Cipher Block Chaining mode
 	  This block cipher algorithm is required for IPSec.
@@ -165,7 +163,6 @@
 	tristate "PCBC support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
-	default m
 	help
 	  PCBC: Propagating Cipher Block Chaining mode
 	  This block cipher algorithm is required for RxRPC.

