Return-Path: <linux-kernel-owner+w=401wt.eu-S2992445AbXCBOBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992445AbXCBOBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992447AbXCBOBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:01:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49164 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992445AbXCBOBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:01:16 -0500
Date: Fri, 2 Mar 2007 15:05:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] libata Kconfig: Update the various experimentality levels
Message-ID: <20070302150512.281af8d3@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/Kconfig linux-2.6.21-rc2/drivers/ata/Kconfig
--- linux.vanilla-2.6.21-rc2/drivers/ata/Kconfig	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/Kconfig	2007-03-02 13:30:50.535164824 +0000
@@ -184,7 +184,7 @@
 	  If unsure, say N.
 
 config PATA_AMD
-	tristate "AMD/NVidia PATA support (Experimental)"
+	tristate "AMD/NVidia PATA support"
 	depends on PCI
 	help
 	  This option enables support for the AMD and NVidia PATA
@@ -273,7 +283,7 @@
 	  If unsure, say N.
 
 config PATA_HPT366
-	tristate "HPT 366/368 PATA support (Very Experimental)"
+	tristate "HPT 366/368 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the HPT 366 and 368
@@ -282,7 +292,7 @@
 	  If unsure, say N.
 
 config PATA_HPT37X
-	tristate "HPT 370/370A/371/372/374/302 PATA support (Very Experimental)"
+	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the majority of the later HPT
@@ -309,7 +319,7 @@
 	  If unsure, say N.
 
 config PATA_ISAPNP
-	tristate "ISA Plug and Play PATA support (Very Experimental)"
+	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
 	help
 	  This option enables support for ISA plug & play ATA
@@ -318,8 +328,8 @@
 	  If unsure, say N.
 
 config PATA_IT821X
-	tristate "IT8211/2 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "IT8211/2 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -390,10 +400,10 @@
 	  If unsure, say N.
 
 config PATA_OLDPIIX
-	tristate "Intel PATA old PIIX support (Experimental)"
+	tristate "Intel PATA support for the original PIIX"
 	depends on PCI && EXPERIMENTAL
 	help
-	  This option enables support for old(?) PIIX PATA support.
+	  This option enables support for early Intel PIIX PATA support.
 
 	  If unsure, say N.
 
@@ -444,7 +454,7 @@
 	  If unsure, say N.
 
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support (Very Experimental)"
+	tristate "Older Promise PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
@@ -477,7 +487,7 @@
 	  If unsure, say N.
 
 config PATA_SC1200
-	tristate "SC1200 PATA support (Raving Lunatic)"
+	tristate "SC1200 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
@@ -486,8 +496,8 @@
 	  If unsure, say N.
 
 config PATA_SERVERWORKS
-	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
