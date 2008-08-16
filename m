Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYHPFQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYHPFQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYHPFQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:16:41 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:35486 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859AbYHPFQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:16:40 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/3] ATA Kconfig cleanup: text changes and break long lines
Date: Sat, 16 Aug 2008 15:16:30 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <bloca4hiv8p9lfuqfoivu903j8qcccquc0@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Grant Coady <gcoady.lk@gmail.com>

ATA Kconfig cleanup 3/3: A few text changes and break a couple long 
lines.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

--- linux-2.6.27-rc3b2/drivers/ata/Kconfig	2008-08-16 14:20:08.177922891 +1000
+++ linux-2.6.27-rc3b3/drivers/ata/Kconfig	2008-08-16 14:50:16.454342447 +1000
@@ -3,7 +3,7 @@
 #
 
 menuconfig ATA
-	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	tristate "Serial ATA and Parallel ATA (SATA/PATA) drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
@@ -118,7 +118,8 @@
 	help
 	  On Acorn systems, say Y here if you wish to use the ICS PATA
 	  interface card.  This is not required for ICS partition support.
-	  If you are unsure, say N to this.
+
+	  If unsure, say N.
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
@@ -550,12 +551,13 @@
 	tristate "Promise PATA 2027x support"
 	depends on ATA_SFF_PATA && PCI
 	help
-	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+	  This option enables support for Promise PATA pdc20268 to
+	  pdc20277 host adapters.
 
 	  If unsure, say N.
 
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support (Experimental)"
+	tristate "Promise older PATA controller support (Experimental)"
 	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
@@ -622,7 +624,7 @@
 	  If unsure, say N.
 
 config PATA_SERVERWORKS
-	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
+	tristate "ServerWorks OSB4/CSB5/CSB6/HT1000 PATA support"
 	depends on ATA_SFF_PATA && PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
@@ -695,7 +697,8 @@
 	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
 	depends on ATA_SFF_SATA && PCI
 	help
-	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
+	  This option enables support for Vitesse VSC7174 and
+	  Intel 31244 Serial ATA.
 
 	  If unsure, say N.
 
