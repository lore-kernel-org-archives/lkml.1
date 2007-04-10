Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbXDJTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbXDJTwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXDJTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:52:18 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:36838 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbXDJTwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:52:17 -0400
Date: Tue, 10 Apr 2007 21:50:30 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeff Garzik <jgarzik@pobox.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/30] Use menuconfig objects - libata
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102149220.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/ata/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/ata/Kconfig
+++ linux-2.6.21-rc5/drivers/ata/Kconfig
@@ -2,10 +2,8 @@
 # SATA/PATA driver configuration
 #
 
-menu "Serial ATA (prod) and Parallel ATA (experimental) drivers"
-
-config ATA
-	tristate "ATA device support"
+menuconfig ATA
+	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
 	depends on !SUN4 || BROKEN
@@ -571,6 +569,4 @@ config PATA_SCC
 
 	  If unsure, say N.
 
-endif
-endmenu
-
+endif # ATA
#<EOF>
