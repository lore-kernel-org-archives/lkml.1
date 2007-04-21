Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXDUSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXDUSzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 14:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXDUSzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 14:55:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37151 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXDUSy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 14:54:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 21 Apr 2007 20:54:37 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: more help in Kconfig
To: linux1394-devel <linux1394-devel@lists.sourceforge.net>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <tkrat.35ad9ef1322ef863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  - s/Device Drivers/Controllers/
  - clarify who needs pcilynx
  - don't recommend Y for raw1394; M is typically used

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/Kconfig |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: linux/drivers/ieee1394/Kconfig
===================================================================
--- linux.orig/drivers/ieee1394/Kconfig
+++ linux/drivers/ieee1394/Kconfig
@@ -36,7 +36,7 @@ config IEEE1394_VERBOSEDEBUG
 	  Say Y if you really want or need the debugging output, everyone
 	  else says N.
 
-comment "Device Drivers"
+comment "Controllers"
 	depends on IEEE1394
 
 comment "Texas Instruments PCILynx requires I2C"
@@ -54,6 +54,10 @@ config IEEE1394_PCILYNX
 	  To compile this driver as a module, say M here: the
 	  module will be called pcilynx.
 
+	  Only some old and now very rare PCI and CardBus cards and
+	  PowerMacs G3 B&W contain the PCILynx controller.  Therefore
+	  almost everybody can say N here.
+
 config IEEE1394_OHCI1394
 	tristate "OHCI-1394 support"
 	depends on PCI && IEEE1394
@@ -67,7 +71,7 @@ config IEEE1394_OHCI1394
 	  To compile this driver as a module, say M here: the
 	  module will be called ohci1394.
 
-comment "Protocol Drivers"
+comment "Protocols"
 	depends on IEEE1394
 
 config IEEE1394_VIDEO1394
@@ -136,12 +140,12 @@ config IEEE1394_RAWIO
 	tristate "Raw IEEE1394 I/O support"
 	depends on IEEE1394
 	help
-	  Say Y here if you want support for the raw device. This is generally
-	  a good idea, so you should say Y here. The raw device enables
-	  direct communication of user programs with the IEEE 1394 bus and
-	  thus with the attached peripherals.
+	  This option adds support for the raw1394 device file which enables
+	  direct communication of user programs with the IEEE 1394 bus and thus
+	  with the attached peripherals.  Almost all application programs which
+	  access FireWire require this option.
 
-	  To compile this driver as a module, say M here: the
-	  module will be called raw1394.
+	  To compile this driver as a module, say M here: the module will be
+	  called raw1394.
 
 endmenu

-- 
Stefan Richter
-=====-=-=== -=-- =-=-=
http://arcgraph.de/sr/

