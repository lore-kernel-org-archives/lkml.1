Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYFNMZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYFNMZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 08:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYFNMZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 08:25:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56929 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbYFNMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 08:25:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Jun 2008 14:24:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: Kconfig menu touch-up
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.e8d86d7d304b0005@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emphasize the recommendation to build only one stack.
Trim the prompts to better fit into short attention spans.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

Index: linux/drivers/firewire/Kconfig
===================================================================
--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -1,28 +1,26 @@
-comment "An alternative FireWire stack is available with EXPERIMENTAL=y"
+comment "A new alternative FireWire stack is available with EXPERIMENTAL=y"
 	depends on EXPERIMENTAL=n
 
+comment "Enable only one of the two stacks, unless you know what you are doing"
+	depends on EXPERIMENTAL
+
 config FIREWIRE
-	tristate "IEEE 1394 (FireWire) support - alternative stack, EXPERIMENTAL"
+	tristate "New FireWire stack, EXPERIMENTAL"
 	depends on EXPERIMENTAL
 	select CRC_ITU_T
 	help
 	  This is the "Juju" FireWire stack, a new alternative implementation
 	  designed for robustness and simplicity.  You can build either this
-	  stack, or the classic stack (the ieee1394 driver, ohci1394 etc.)
-	  or both.  Please read http://wiki.linux1394.org/JujuMigration before
-	  you enable the new stack.
+	  stack, or the old stack (the ieee1394 driver, ohci1394 etc.) or both.
+	  Please read http://wiki.linux1394.org/JujuMigration before you
+	  enable the new stack.
 
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.  It functionally replaces ieee1394, raw1394,
 	  and video1394.
 
-          NOTE:
-
-	  You should only build ONE of the stacks, unless you REALLY know what
-	  you are doing.
-
 config FIREWIRE_OHCI
-	tristate "Support for OHCI FireWire host controllers"
+	tristate "OHCI-1394 controllers"
 	depends on PCI && FIREWIRE
 	help
 	  Enable this driver if you have a FireWire controller based
@@ -33,12 +31,12 @@ config FIREWIRE_OHCI
 	  called firewire-ohci.  It replaces ohci1394 of the classic IEEE 1394
 	  stack.
 
-          NOTE:
+	  NOTE:
 
-	  You should only build ohci1394 or firewire-ohci, but not both.
-	  If you nevertheless want to install both, you should configure them
-	  only as modules and blacklist the driver(s) which you don't want to
-	  have auto-loaded.  Add either
+	  You should only build either firewire-ohci or the old ohci1394 driver,
+	  but not both.  If you nevertheless want to install both, you should
+	  configure them only as modules and blacklist the driver(s) which you
+	  don't want to have auto-loaded.  Add either
 
 	      blacklist firewire-ohci
 	  or
@@ -60,7 +58,7 @@ config FIREWIRE_OHCI_DEBUG
 	default y
 
 config FIREWIRE_SBP2
-	tristate "Support for storage devices (SBP-2 protocol driver)"
+	tristate "Storage devices (SBP-2 protocol)"
 	depends on FIREWIRE && SCSI
 	help
 	  This option enables you to use SBP-2 devices connected to a

-- 
Stefan Richter
-=====-==--- -==- -===-
http://arcgraph.de/sr/

