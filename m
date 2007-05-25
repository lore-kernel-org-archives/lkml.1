Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXEYLzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXEYLzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXEYLzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:55:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38544 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbXEYLzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:55:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 25 May 2007 13:54:49 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [rfc patch] firewire: prefix modules with firewire- instead of fw-
To: linux1394-user@lists.sourceforge.net
cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.68cdceb78a7f6e10@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Of course everybody immediately associates "fw-" with FireWire, not
firmware or firewall or whatever.  But "firewire-" has a nice ring to
it too.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

So everybody, do you prefer the longer names?

Alas this RFC is a little bit late before release,
but perhaps not too late.


 drivers/firewire/Kconfig  |   14 +++++++-------
 drivers/firewire/Makefile |   12 +++++++-----
 2 files changed, 14 insertions(+), 12 deletions(-)

Index: linux/drivers/firewire/Kconfig
===================================================================
--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -18,7 +18,7 @@ config FIREWIRE
 	  your IEEE 1394 adapter.
 
 	  To compile this driver as a module, say M here: the module will be
-	  called fw-core.
+	  called firewire-core.
 
 	  This is the "JUJU" FireWire stack, an alternative implementation
 	  designed for robustness and simplicity.  You can build either this
@@ -34,11 +34,11 @@ config FIREWIRE_OHCI
 	  is the only chipset in use, so say Y here.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called fw-ohci.
+	  called firewire-ohci.
 
 	  If you also build ohci1394 of the classic IEEE 1394 driver stack,
-	  blacklist either ohci1394 or fw-ohci to let hotplug load the desired
-	  driver.
+	  blacklist either ohci1394 or firewire-ohci to let hotplug load the
+	  desired driver.
 
 config FIREWIRE_SBP2
 	tristate "Support for storage devices (SBP-2 protocol driver)"
@@ -50,12 +50,12 @@ config FIREWIRE_SBP2
 	  like scanners.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called fw-sbp2.
+	  called firewire-sbp2.
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
 
 	  If you also build sbp2 of the classic IEEE 1394 driver stack,
-	  blacklist either sbp2 or fw-sbp2 to let hotplug load the desired
-	  driver.
+	  blacklist either sbp2 or firewire-sbp2 to let hotplug load the
+	  desired driver.
 
Index: linux/drivers/firewire/Makefile
===================================================================
--- linux.orig/drivers/firewire/Makefile
+++ linux/drivers/firewire/Makefile
@@ -2,9 +2,11 @@
 # Makefile for the Linux IEEE 1394 implementation
 #
 
-fw-core-y += fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
-	fw-device.o fw-cdev.o
+firewire-core-y += fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
+                   fw-device.o fw-cdev.o
+firewire-ohci-y += fw-ohci.o
+firewire-sbp2-y += fw-sbp2.o
 
-obj-$(CONFIG_FIREWIRE) += fw-core.o
-obj-$(CONFIG_FIREWIRE_OHCI) += fw-ohci.o
-obj-$(CONFIG_FIREWIRE_SBP2) += fw-sbp2.o
+obj-$(CONFIG_FIREWIRE) += firewire-core.o
+obj-$(CONFIG_FIREWIRE_OHCI) += firewire-ohci.o
+obj-$(CONFIG_FIREWIRE_SBP2) += firewire-sbp2.o

-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/

