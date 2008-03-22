Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYCVR5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYCVR5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbYCVR4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:56:49 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:43147 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbYCVR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:56:48 -0400
X-Trace: 684339771/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAFAJDl5EdRAVlC/2dsb2JhbACBW6ZD
Subject: Re: [PATCH] 1/3 mtd: add Kbuild support and makefile support for
	Dreamcast VMU
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: dwmw2 <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       Paul Mundt <lethal@users.sourceforge.net>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <1206207805.6324.13.camel@localhost.localdomain>
References: <1206207805.6324.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 17:56:32 +0000
Message-Id: <1206208592.6324.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
diff -ruN a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig	2008-03-22 17:26:24.000000000 +0000
+++ b/drivers/mtd/maps/Kconfig	2008-03-22 17:20:45.000000000 +0000
@@ -590,5 +590,19 @@
 
 	  This selection automatically selects the map_ram driver.
 
+config MTD_VMU_FLASH
+	tristate "Dreamcast Visual Memory devices and clones"
+	depends on SH_DREAMCAST
+	select MAPLE
+	help
+	  Flash map driver for the SEGA Dreamcast Visual Memory Unit
+	  and clones.
+
+	  Most Dreamcast users will have one of these and so will want
+	  to say Y here.
+
+	  To compile this driver as a module choose M here: the module
+	  will be called vmu-flash.
+
 endmenu
 
diff -ruN a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
--- a/drivers/mtd/maps/Makefile	2008-03-22 17:26:24.000000000 +0000
+++ b/drivers/mtd/maps/Makefile	2008-03-22 17:20:45.000000000 +0000
@@ -68,3 +68,4 @@
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_MTX1)		+= mtx-1_flash.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
+obj-$(CONFIG_MTD_VMU_FLASH)	+= vmu_flash.o


