Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYHRBsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYHRBsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYHRBsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:48:24 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:60938 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbYHRBsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:48:23 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Grant Coady <gcoady.lk@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ATA Kconfig cleanup: sort the driver list and modify some text
Date: Mon, 18 Aug 2008 11:47:46 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <5rkha4l846d0benss3hip3nvr0cmnfi1k4@4ax.com>
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com> <18598.42334.73411.476062@harpo.it.uu.se> <20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
In-Reply-To: <20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 11:32:24 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> I suspect sata_via will want this too.
>
>Lust about any PATA chip may be on boards with SATA bridges so the divide
>doesn't really work.

Okay, following patch is just the driver sort and text changes.  I have a 
4/3 fixup patch for the last lot but suspect it's a lost cause.

Grant.

From: Grant Coady <gcoady.lk@gmail.com>

ATA Kconfig cleanup: Sort the driver list, and some text changes.

Sort the ATA_SFF driver list, and modify some text for consistency, 
break a couple long lines, remove the 'prod' and 'experimental' text 
from the menu name.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |  465 ++++++++++++++++++++++++++++++++--------------------------------
 1 files changed, 234 insertions(+), 231 deletions(-)

--- linux-2.6.27-rc3a/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
+++ linux-2.6.27-rc3c/drivers/ata/Kconfig	2008-08-18 11:29:20.871422237 +1000
@@ -3,7 +3,7 @@
 #
 
 menuconfig ATA
-	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	tristate "Serial ATA and Parallel ATA (SATA/PATA) drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
@@ -56,14 +56,6 @@
 
 	  If unsure, say N.
 
-config SATA_SIL24
-	tristate "Silicon Image 3124/3132 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Silicon Image 3124/3132 Serial ATA.
-
-	  If unsure, say N.
-
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
 	depends on FSL_SOC
@@ -73,6 +65,14 @@
 
 	  If unsure, say N.
 
+config SATA_SIL24
+	tristate "Silicon Image 3124/3132 SATA support"
+	depends on PCI
+	help
+	  This option enables support for Silicon Image 3124/3132 Serial ATA.
+
+	  If unsure, say N.
+
 config ATA_SFF
 	bool "ATA SFF support"
 	default y
@@ -93,123 +93,15 @@
 
 if ATA_SFF
 
-config SATA_SVW
-	tristate "ServerWorks Frodo / Apple K2 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Broadcom/Serverworks/Apple K2
-	  SATA support.
-
-	  If unsure, say N.
-
-config ATA_PIIX
-	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
-	depends on PCI
-	help
-	  This option enables support for ICH5/6/7/8 Serial ATA
-	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
-	  host controllers.
-
-	  If unsure, say N.
-
-config SATA_MV
-	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  This option enables support for the Marvell Serial ATA family.
-	  Currently supports 88SX[56]0[48][01] chips.
-
-	  If unsure, say N.
-
-config SATA_NV
-	tristate "NVIDIA SATA support"
-	depends on PCI
-	help
-	  This option enables support for NVIDIA Serial ATA.
-
-	  If unsure, say N.
-
-config PDC_ADMA
-	tristate "Pacific Digital ADMA support"
-	depends on PCI
-	help
-	  This option enables support for Pacific Digital ADMA controllers
-
-	  If unsure, say N.
-
-config SATA_QSTOR
-	tristate "Pacific Digital SATA QStor support"
-	depends on PCI
-	help
-	  This option enables support for Pacific Digital Serial ATA QStor.
-
-	  If unsure, say N.
-
-config SATA_PROMISE
-	tristate "Promise SATA TX2/TX4 support"
-	depends on PCI
-	help
-	  This option enables support for Promise Serial ATA TX2/TX4.
-
-	  If unsure, say N.
-
-config SATA_SX4
-	tristate "Promise SATA SX4 support"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for Promise Serial ATA SX4.
-
-	  If unsure, say N.
-
-config SATA_SIL
-	tristate "Silicon Image SATA support"
-	depends on PCI
-	help
-	  This option enables support for Silicon Image Serial ATA.
-
-	  If unsure, say N.
-
-config SATA_SIS
-	tristate "SiS 964/965/966/180 SATA support"
-	depends on PCI
-	select PATA_SIS
-	help
-	  This option enables support for SiS Serial ATA on
-	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
-	  The PATA support for SiS 180 requires additionally to
-	  enable the PATA_SIS driver in the config.
-	  If unsure, say N.
-
-config SATA_ULI
-	tristate "ULi Electronics SATA support"
-	depends on PCI
-	help
-	  This option enables support for ULi Electronics SATA.
-
-	  If unsure, say N.
-
-config SATA_VIA
-	tristate "VIA SATA support"
-	depends on PCI
-	help
-	  This option enables support for VIA Serial ATA.
-
-	  If unsure, say N.
-
-config SATA_VITESSE
-	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
-	depends on PCI
+config PATA_ICSIDE
+	tristate "Acorn ICS PATA support"
+	depends on ARM && ARCH_ACORN
 	help
-	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
+	  On Acorn systems, say Y here if you wish to use the ICS PATA
+	  interface card.  This is not required for ICS partition support.
 
 	  If unsure, say N.
 
-config SATA_INIC162X
-	tristate "Initio 162x SATA support"
-	depends on PCI
-	help
-	  This option enables support for Initio 162x Serial ATA.
-
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
 	depends on ATA_ACPI
@@ -263,6 +155,15 @@
 
 	  If unsure, say N.
 
+config PATA_BF54X
+	tristate "Blackfin 54x ATAPI support"
+	depends on BF542 || BF548 || BF549
+	help
+	  This option enables support for the built-in ATAPI controller on
+	  Blackfin 54x family chips.
+
+	  If unsure, say N.
+
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -282,6 +183,23 @@
 
 	  If unsure, say N.
 
+config PATA_SIL680
+	tristate "CMD / Silicon Image 680 PATA support"
+	depends on PCI
+	help
+	  This option enables support for CMD / Silicon Image 680 PATA.
+
+	  If unsure, say N.
+
+config PATA_TRIFLEX
+	tristate "Compaq Triflex PATA support"
+	depends on PCI
+	help
+	  Enable support for the Compaq 'Triflex' IDE controller as found
+	  on many Compaq Pentium-Pro systems, via the new ATA layer.
+
+	  If unsure, say N.
+
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
 	depends on PCI
@@ -336,6 +254,15 @@
 
 	  If unsure, say N.
 
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on PPC_MPC52xx
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
 config ATA_GENERIC
 	tristate "Generic ATA support"
 	depends on PCI
@@ -345,6 +272,23 @@
 
 	  If unsure, say N.
 
+config PATA_HPT3X3
+	tristate "HPT 343/363 PATA support"
+	depends on PCI
+	help
+	  This option enables support for the HPT 343/363
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+config PATA_HPT3X3_DMA
+	bool "HPT 343/363 DMA support (Experimental)"
+	depends on PATA_HPT3X3
+	help
+	  This option enables DMA support for the HPT343/363
+	  controllers. Enable with care as there are still some
+	  problems with DMA on this chipset.
+
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
 	depends on PCI
@@ -372,22 +316,46 @@
 
 	  If unsure, say N.
 
-config PATA_HPT3X3
-	tristate "HPT 343/363 PATA support"
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
 	depends on PCI
 	help
-	  This option enables support for the HPT 343/363
-	  PATA controllers via the new ATA layer
+	  This option enables support for Initio 162x Serial ATA.
+
+config ATA_PIIX
+	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
+	depends on PCI
+	help
+	  This option enables support for ICH5 or later Serial ATA
+	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
+	  host controllers.
 
 	  If unsure, say N.
 
-config PATA_HPT3X3_DMA
-	bool "HPT 343/363 DMA support (Experimental)"
-	depends on PATA_HPT3X3
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
+	depends on PCI
 	help
-	  This option enables DMA support for the HPT343/363
-	  controllers. Enable with care as there are still some
-	  problems with DMA on this chipset.
+	  This option enables support for MPIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_OLDPIIX
+	tristate "Intel PATA old PIIX support"
+	depends on PCI
+	help
+	  This option enables support for early PIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_SCH
+	tristate "Intel SCH PATA support"
+	depends on PCI
+	help
+	  This option enables support for Intel SCH PATA on the Intel
+	  SCH (US15W, US15L, UL11L) series host controllers.
+
+	  If unsure, say N.
 
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
@@ -417,6 +385,16 @@
 
 	  If unsure, say N.
 
+config PATA_IXP4XX_CF
+	tristate "IXP4XX Compact Flash support"
+	depends on ARCH_IXP4XX
+	help
+	  This option enables support for a Compact Flash connected on
+	  the ixp4xx expansion bus. This driver had been written for
+	  Loft/Avila boards in mind but can work with others.
+
+	  If unsure, say N.
+
 config PATA_JMICRON
 	tristate "JMicron PATA support"
 	depends on PCI
@@ -435,15 +413,6 @@
 
 	  If unsure, say N.
 
-config PATA_TRIFLEX
-	tristate "Compaq Triflex PATA support"
-	depends on PCI
-	help
-	  Enable support for the Compaq 'Triflex' IDE controller as found
-	  on many Compaq Pentium-Pro systems, via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
 	depends on PCI
@@ -453,28 +422,30 @@
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx
+config SATA_MV
+	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
+	depends on EXPERIMENTAL
 	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
+	  This option enables support for the Marvell Serial ATA family.
+	  Currently supports 88SX[56]0[48][01] chips.
 
 	  If unsure, say N.
 
-config PATA_MPIIX
-	tristate "Intel PATA MPIIX support"
-	depends on PCI
+config PATA_NS87410
+	tristate "Nat Semi NS87410 PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
 	help
-	  This option enables support for MPIIX PATA support.
+	  This option enables support for the National Semiconductor
+	  NS87410 PCI-IDE controller.
 
 	  If unsure, say N.
 
-config PATA_OLDPIIX
-	tristate "Intel PATA old PIIX support"
-	depends on PCI
+config PATA_NS87415
+	tristate "Nat Semi NS87415 PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
 	help
-	  This option enables support for early PIIX PATA support.
+	  This option enables support for the National Semiconductor
+	  NS87415 PCI-IDE controller.
 
 	  If unsure, say N.
 
@@ -496,21 +467,11 @@
 
 	  If unsure, say N.
 
-config PATA_NS87410
-	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
-	help
-	  This option enables support for the National Semiconductor
-	  NS87410 PCI-IDE controller.
-
-	  If unsure, say N.
-
-config PATA_NS87415
-	tristate "Nat Semi NS87415 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+config SATA_NV
+	tristate "NVIDIA SATA support"
+	depends on PCI
 	help
-	  This option enables support for the National Semiconductor
-	  NS87415 PCI-IDE controller.
+	  This option enables support for NVIDIA Serial ATA.
 
 	  If unsure, say N.
 
@@ -533,6 +494,31 @@
 
 	  If unsure, say N.
 
+config PDC_ADMA
+	tristate "Pacific Digital ADMA support"
+	depends on PCI
+	help
+	  This option enables support for Pacific Digital ADMA controllers
+
+	  If unsure, say N.
+
+config SATA_QSTOR
+	tristate "Pacific Digital SATA QStor support"
+	depends on PCI
+	help
+	  This option enables support for Pacific Digital Serial ATA QStor.
+
+	  If unsure, say N.
+
+config PATA_RZ1000
+	tristate "PC Tech RZ1000 PATA support"
+	depends on PCI
+	help
+	  This option enables basic support for the PC Tech RZ1000/1
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
 	depends on PCMCIA
@@ -542,8 +528,17 @@
 
 	  If unsure, say N.
 
+config PATA_PDC2027X
+	tristate "Promise PATA 2027x support"
+	depends on PCI
+	help
+	  This option enables support for Promise PATA pdc20268 to
+	  pdc20277 host adapters.
+
+	  If unsure, say N.
+
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support (Experimental)"
+	tristate "Promise older PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
@@ -551,6 +546,22 @@
 
 	  If unsure, say N.
 
+config SATA_SX4
+	tristate "Promise SATA SX4 support"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for Promise Serial ATA SX4.
+
+	  If unsure, say N.
+
+config SATA_PROMISE
+	tristate "Promise SATA TX2/TX4 support"
+	depends on PCI
+	help
+	  This option enables support for Promise Serial ATA TX2/TX4.
+
+	  If unsure, say N.
+
 config PATA_QDI
 	tristate "QDI VLB PATA support"
 	depends on ISA
@@ -575,15 +586,6 @@
 
 	  If unsure, say N.
 
-config PATA_RZ1000
-	tristate "PC Tech RZ1000 PATA support"
-	depends on PCI
-	help
-	  This option enables basic support for the PC Tech RZ1000/1
-	  PATA controllers via the new ATA layer
-
-	  If unsure, say N.
-
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -593,8 +595,17 @@
 
 	  If unsure, say N.
 
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	depends on PCI
+	help
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
+	  If unsure, say N.
+
 config PATA_SERVERWORKS
-	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
+	tristate "ServerWorks OSB4/CSB5/CSB6/HT1000 PATA support"
 	depends on PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
@@ -602,20 +613,23 @@
 
 	  If unsure, say N.
 
-config PATA_PDC2027X
-	tristate "Promise PATA 2027x support"
+config SATA_SIL
+	tristate "Silicon Image SATA support"
 	depends on PCI
 	help
-	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+	  This option enables support for Silicon Image Serial ATA.
 
 	  If unsure, say N.
 
-config PATA_SIL680
-	tristate "CMD / Silicon Image 680 PATA support"
+config SATA_SIS
+	tristate "SiS 964/965/966/180 SATA support"
 	depends on PCI
+	select PATA_SIS
 	help
-	  This option enables support for CMD / Silicon Image 680 PATA.
-
+	  This option enables support for SiS Serial ATA on
+	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
+	  The PATA support for SiS 180 requires additionally to
+	  enable the PATA_SIS driver in the config.
 	  If unsure, say N.
 
 config PATA_SIS
@@ -626,6 +640,23 @@
 
 	  If unsure, say N.
 
+config PATA_SCC
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on PCI && PPC_CELLEB
+	help
+	  This option enables support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+
+	  If unsure, say N.
+
+config SATA_ULI
+	tristate "ULi Electronics SATA support"
+	depends on PCI
+	help
+	  This option enables support for ULi Electronics SATA.
+
+	  If unsure, say N.
+
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
@@ -635,6 +666,23 @@
 
 	  If unsure, say N.
 
+config SATA_VIA
+	tristate "VIA SATA support"
+	depends on PCI
+	help
+	  This option enables support for VIA Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_VITESSE
+	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
+	depends on PCI
+	help
+	  This option enables support for Vitesse VSC7174 and
+	  Intel 31244 Serial ATA.
+
+	  If unsure, say N.
+
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
 	depends on PCI
@@ -678,50 +726,5 @@
 
 	  If unsure, say N.
 
-config PATA_ICSIDE
-	tristate "Acorn ICS PATA support"
-	depends on ARM && ARCH_ACORN
-	help
-	  On Acorn systems, say Y here if you wish to use the ICS PATA
-	  interface card.  This is not required for ICS partition support.
-	  If you are unsure, say N to this.
-
-config PATA_IXP4XX_CF
-	tristate "IXP4XX Compact Flash support"
-	depends on ARCH_IXP4XX
-	help
-	  This option enables support for a Compact Flash connected on
-	  the ixp4xx expansion bus. This driver had been written for
-	  Loft/Avila boards in mind but can work with others.
-
-	  If unsure, say N.
-
-config PATA_SCC
-	tristate "Toshiba's Cell Reference Set IDE support"
-	depends on PCI && PPC_CELLEB
-	help
-	  This option enables support for the built-in IDE controller on
-	  Toshiba Cell Reference Board.
-
-	  If unsure, say N.
-
-config PATA_SCH
-	tristate "Intel SCH PATA support"
-	depends on PCI
-	help
-	  This option enables support for Intel SCH PATA on the Intel
-	  SCH (US15W, US15L, UL11L) series host controllers.
-
-	  If unsure, say N.
-
-config PATA_BF54X
-	tristate "Blackfin 54x ATAPI support"
-	depends on BF542 || BF548 || BF549
-	help
-	  This option enables support for the built-in ATAPI controller on
-	  Blackfin 54x family chips.
-
-	  If unsure, say N.
-
 endif # ATA_SFF
 endif # ATA
