Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXDJUrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXDJUrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030619AbXDJUrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:47:46 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:35413 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030614AbXDJUro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:47:44 -0400
Date: Tue, 10 Apr 2007 22:46:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
cc: linux-crypto@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/30] Use menuconfig objects - crypto hw
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102245310.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/crypto/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/crypto/Kconfig
+++ linux-2.6.21-rc5/drivers/crypto/Kconfig
@@ -1,4 +1,9 @@
-menu "Hardware crypto devices"
+
+menuconfig CRYPTO_HW
+	bool "Hardware crypto devices"
+	default y
+
+if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
@@ -66,4 +71,4 @@ config CRYPTO_DEV_GEODE
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
 
-endmenu
+endif # CRYPTO_HW
#<EOF>
