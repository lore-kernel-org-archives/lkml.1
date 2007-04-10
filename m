Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbXDJUrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbXDJUrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXDJUrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:47:13 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:35192 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbXDJUrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:47:12 -0400
Date: Tue, 10 Apr 2007 22:45:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
cc: linux-crypto@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/30] Use menuconfig objects - crypto
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102243520.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/crypto/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/crypto/Kconfig
+++ linux-2.6.21-rc5/crypto/Kconfig
@@ -2,9 +2,7 @@
 # Cryptographic API Configuration
 #
 
-menu "Cryptographic options"
-
-config CRYPTO
+menuconfig CRYPTO
 	bool "Cryptographic API"
 	help
 	  This option provides the core Cryptographic API.
@@ -450,5 +448,3 @@ config CRYPTO_TEST
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
-
-endmenu
#<EOF>
