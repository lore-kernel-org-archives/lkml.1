Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbXDJVmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbXDJVmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbXDJVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:42:09 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:57421 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbXDJVmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:42:07 -0400
Date: Tue, 10 Apr 2007 23:41:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux PCMCIA Team <linux-pcmcia@lists.infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 27/30] Use menuconfig objects - PCMCIA
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102340370.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/pcmcia/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pcmcia/Kconfig
+++ linux-2.6.21-rc5/drivers/pcmcia/Kconfig
@@ -2,9 +2,7 @@
 # PCCARD (PCMCIA/CardBus) bus subsystem configuration
 #
 
-menu "PCCARD (PCMCIA/CardBus) support"
-
-config PCCARD
+menuconfig PCCARD
 	tristate "PCCard (PCMCIA/CardBus) support"
 	depends on HOTPLUG
 	---help---
@@ -277,5 +275,3 @@ config PCCARD_IODYN
 	bool
 
 endif	# PCCARD
-
-endmenu
#<EOF>
