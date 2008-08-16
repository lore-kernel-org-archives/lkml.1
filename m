Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYHPFQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYHPFQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYHPFQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:16:21 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:35110 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754924AbYHPFQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:16:19 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/3] ATA Kconfig cleanup: sort drivers into one list
Date: Sat, 16 Aug 2008 15:16:06 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <akoca4dgk2uh8ps8l289eerku938b83uc2@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Grant Coady <gcoady.lk@gmail.com>

ATA Kconfig cleanup 2/3: Sort the ATA drivers into one list, leaving 
the PATA_PLATFORM items at the end.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |  464 ++++++++++++++++++++++++++++++++--------------------------------
 1 files changed, 232 insertions(+), 232 deletions(-)

--- linux-2.6.27-rc3b1/drivers/ata/Kconfig	2008-08-16 14:14:37.766129389 +1000
+++ linux-2.6.27-rc3b2/drivers/ata/Kconfig	2008-08-16 14:20:08.177922891 +1000
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
 config ATA_SFF_SATA
 	bool "SATA Serial ATA support"
 	default y
@@ -112,122 +112,13 @@
 
 if ATA_SFF
 
-config SATA_SVW
-	tristate "ServerWorks Frodo / Apple K2 SATA support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for Broadcom/Serverworks/Apple K2
-	  SATA support.
-
-	  If unsure, say N.
-
-config ATA_PIIX
-	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
-	depends on (ATA_SFF_SATA || ATA_SFF_PATA) && PCI
-	help
-	  This option enables support for ICH5/6/7/8 Serial ATA
-	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
-	  host controllers.
-
-	  If unsure, say N.
-
-config SATA_MV
-	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on ATA_SFF_SATA && EXPERIMENTAL
-	help
-	  This option enables support for the Marvell Serial ATA family.
-	  Currently supports 88SX[56]0[48][01] chips.
-
-	  If unsure, say N.
-
-config SATA_NV
-	tristate "NVIDIA SATA support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for NVIDIA Serial ATA.
-
-	  If unsure, say N.
-
-config PDC_ADMA
-	tristate "Pacific Digital ADMA support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for Pacific Digital ADMA controllers
-
-	  If unsure, say N.
-
-config SATA_QSTOR
-	tristate "Pacific Digital SATA QStor support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for Pacific Digital Serial ATA QStor.
-
-	  If unsure, say N.
-
-config SATA_PROMISE
-	tristate "Promise SATA TX2/TX4 support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for Promise Serial ATA TX2/TX4.
-
-	  If unsure, say N.
-
-config SATA_SX4
-	tristate "Promise SATA SX4 support"
-	depends on ATA_SFF_SATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for Promise Serial ATA SX4.
-
-	  If unsure, say N.
-
-config SATA_SIL
-	tristate "Silicon Image SATA support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for Silicon Image Serial ATA.
-
-	  If unsure, say N.
-
-config SATA_SIS
-	tristate "SiS 964/965/966/180 SATA support"
-	depends on ATA_SFF_SATA && PCI
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
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for ULi Electronics SATA.
-
-	  If unsure, say N.
-
-config SATA_VIA
-	tristate "VIA SATA support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for VIA Serial ATA.
-
-	  If unsure, say N.
-
-config SATA_VITESSE
-	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
-	depends on ATA_SFF_SATA && PCI
-	help
-	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
-
-	  If unsure, say N.
-
-config SATA_INIC162X
-	tristate "Initio 162x SATA support"
-	depends on ATA_SFF_SATA && PCI
+config PATA_ICSIDE
+	tristate "Acorn ICS PATA support"
+	depends on ATA_SFF_PATA && ARM && ARCH_ACORN
 	help
-	  This option enables support for Initio 162x Serial ATA.
+	  On Acorn systems, say Y here if you wish to use the ICS PATA
+	  interface card.  This is not required for ICS partition support.
+	  If you are unsure, say N to this.
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
@@ -282,6 +173,15 @@
 
 	  If unsure, say N.
 
+config PATA_BF54X
+	tristate "Blackfin 54x ATAPI support"
+	depends on ATA_SFF_PATA && (BF542 || BF548 || BF549)
+	help
+	  This option enables support for the built-in ATAPI controller on
+	  Blackfin 54x family chips.
+
+	  If unsure, say N.
+
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
 	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
@@ -301,6 +201,23 @@
 
 	  If unsure, say N.
 
+config PATA_SIL680
+	tristate "CMD / Silicon Image 680 PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for CMD / Silicon Image 680 PATA.
+
+	  If unsure, say N.
+
+config PATA_TRIFLEX
+	tristate "Compaq Triflex PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  Enable support for the Compaq 'Triflex' IDE controller as found
+	  on many Compaq Pentium-Pro systems, via the new ATA layer.
+
+	  If unsure, say N.
+
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
 	depends on ATA_SFF_PATA && PCI
@@ -355,6 +272,15 @@
 
 	  If unsure, say N.
 
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on ATA_SFF_PATA && PPC_MPC52xx
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
 config ATA_GENERIC
 	tristate "Generic ATA support"
 	depends on ATA_SFF_PATA && PCI
@@ -364,6 +290,23 @@
 
 	  If unsure, say N.
 
+config PATA_HPT3X3
+	tristate "HPT 343/363 PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for the HPT 343/363
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+config PATA_HPT3X3_DMA
+	bool "HPT 343/363 DMA support (Experimental)"
+	depends on ATA_SFF_PATA && PATA_HPT3X3
+	help
+	  This option enables DMA support for the HPT343/363
+	  controllers. Enable with care as there are still some
+	  problems with DMA on this chipset.
+
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
 	depends on ATA_SFF_PATA && PCI
@@ -391,22 +334,46 @@
 
 	  If unsure, say N.
 
-config PATA_HPT3X3
-	tristate "HPT 343/363 PATA support"
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Initio 162x Serial ATA.
+
+config ATA_PIIX
+	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
+	depends on (ATA_SFF_SATA || ATA_SFF_PATA) && PCI
+	help
+	  This option enables support for ICH5/6/7/8 Serial ATA
+	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
+	  host controllers.
+
+	  If unsure, say N.
+
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
 	depends on ATA_SFF_PATA && PCI
 	help
-	  This option enables support for the HPT 343/363
-	  PATA controllers via the new ATA layer
+	  This option enables support for MPIIX PATA support.
 
 	  If unsure, say N.
 
-config PATA_HPT3X3_DMA
-	bool "HPT 343/363 DMA support (Experimental)"
-	depends on ATA_SFF_PATA && PATA_HPT3X3
+config PATA_OLDPIIX
+	tristate "Intel PATA old PIIX support"
+	depends on ATA_SFF_PATA && PCI
 	help
-	  This option enables DMA support for the HPT343/363
-	  controllers. Enable with care as there are still some
-	  problems with DMA on this chipset.
+	  This option enables support for early PIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_SCH
+	tristate "Intel SCH PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for Intel SCH PATA on the Intel
+	  SCH (US15W, US15L, UL11L) series host controllers.
+
+	  If unsure, say N.
 
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
@@ -436,6 +403,16 @@
 
 	  If unsure, say N.
 
+config PATA_IXP4XX_CF
+	tristate "IXP4XX Compact Flash support"
+	depends on ATA_SFF_PATA && ARCH_IXP4XX
+	help
+	  This option enables support for a Compact Flash connected on
+	  the ixp4xx expansion bus. This driver had been written for
+	  Loft/Avila boards in mind but can work with others.
+
+	  If unsure, say N.
+
 config PATA_JMICRON
 	tristate "JMicron PATA support"
 	depends on ATA_SFF_PATA && PCI
@@ -454,15 +431,6 @@
 
 	  If unsure, say N.
 
-config PATA_TRIFLEX
-	tristate "Compaq Triflex PATA support"
-	depends on ATA_SFF_PATA && PCI
-	help
-	  Enable support for the Compaq 'Triflex' IDE controller as found
-	  on many Compaq Pentium-Pro systems, via the new ATA layer.
-
-	  If unsure, say N.
-
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
 	depends on ATA_SFF_PATA && PCI
@@ -472,28 +440,30 @@
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on ATA_SFF_PATA && PPC_MPC52xx
+config SATA_MV
+	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
+	depends on ATA_SFF_SATA && EXPERIMENTAL
 	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
+	  This option enables support for the Marvell Serial ATA family.
+	  Currently supports 88SX[56]0[48][01] chips.
 
 	  If unsure, say N.
 
-config PATA_MPIIX
-	tristate "Intel PATA MPIIX support"
-	depends on ATA_SFF_PATA && PCI
+config PATA_NS87410
+	tristate "Nat Semi NS87410 PATA support (Experimental)"
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
-	  This option enables support for MPIIX PATA support.
+	  This option enables support for the National Semiconductor
+	  NS87410 PCI-IDE controller.
 
 	  If unsure, say N.
 
-config PATA_OLDPIIX
-	tristate "Intel PATA old PIIX support"
-	depends on ATA_SFF_PATA && PCI
+config PATA_NS87415
+	tristate "Nat Semi NS87415 PATA support (Experimental)"
+	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
 	help
-	  This option enables support for early PIIX PATA support.
+	  This option enables support for the National Semiconductor
+	  NS87415 PCI-IDE controller.
 
 	  If unsure, say N.
 
@@ -515,21 +485,11 @@
 
 	  If unsure, say N.
 
-config PATA_NS87410
-	tristate "Nat Semi NS87410 PATA support (Experimental)"
-	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for the National Semiconductor
-	  NS87410 PCI-IDE controller.
-
-	  If unsure, say N.
-
-config PATA_NS87415
-	tristate "Nat Semi NS87415 PATA support (Experimental)"
-	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
+config SATA_NV
+	tristate "NVIDIA SATA support"
+	depends on ATA_SFF_SATA && PCI
 	help
-	  This option enables support for the National Semiconductor
-	  NS87415 PCI-IDE controller.
+	  This option enables support for NVIDIA Serial ATA.
 
 	  If unsure, say N.
 
@@ -552,6 +512,31 @@
 
 	  If unsure, say N.
 
+config PDC_ADMA
+	tristate "Pacific Digital ADMA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Pacific Digital ADMA controllers
+
+	  If unsure, say N.
+
+config SATA_QSTOR
+	tristate "Pacific Digital SATA QStor support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Pacific Digital Serial ATA QStor.
+
+	  If unsure, say N.
+
+config PATA_RZ1000
+	tristate "PC Tech RZ1000 PATA support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables basic support for the PC Tech RZ1000/1
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
 	depends on ATA_SFF_PATA && PCMCIA
@@ -561,6 +546,14 @@
 
 	  If unsure, say N.
 
+config PATA_PDC2027X
+	tristate "Promise PATA 2027x support"
+	depends on ATA_SFF_PATA && PCI
+	help
+	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+
+	  If unsure, say N.
+
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
 	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
@@ -570,6 +563,22 @@
 
 	  If unsure, say N.
 
+config SATA_SX4
+	tristate "Promise SATA SX4 support"
+	depends on ATA_SFF_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for Promise Serial ATA SX4.
+
+	  If unsure, say N.
+
+config SATA_PROMISE
+	tristate "Promise SATA TX2/TX4 support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Promise Serial ATA TX2/TX4.
+
+	  If unsure, say N.
+
 config PATA_QDI
 	tristate "QDI VLB PATA support"
 	depends on ATA_SFF_PATA && ISA
@@ -594,15 +603,6 @@
 
 	  If unsure, say N.
 
-config PATA_RZ1000
-	tristate "PC Tech RZ1000 PATA support"
-	depends on ATA_SFF_PATA && PCI
-	help
-	  This option enables basic support for the PC Tech RZ1000/1
-	  PATA controllers via the new ATA layer
-
-	  If unsure, say N.
-
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
 	depends on ATA_SFF_PATA && PCI && EXPERIMENTAL
@@ -612,6 +612,15 @@
 
 	  If unsure, say N.
 
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
+	  If unsure, say N.
+
 config PATA_SERVERWORKS
 	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
 	depends on ATA_SFF_PATA && PCI
@@ -621,20 +630,23 @@
 
 	  If unsure, say N.
 
-config PATA_PDC2027X
-	tristate "Promise PATA 2027x support"
-	depends on ATA_SFF_PATA && PCI
+config SATA_SIL
+	tristate "Silicon Image SATA support"
+	depends on ATA_SFF_SATA && PCI
 	help
-	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+	  This option enables support for Silicon Image Serial ATA.
 
 	  If unsure, say N.
 
-config PATA_SIL680
-	tristate "CMD / Silicon Image 680 PATA support"
-	depends on ATA_SFF_PATA && PCI
+config SATA_SIS
+	tristate "SiS 964/965/966/180 SATA support"
+	depends on ATA_SFF_SATA && PCI
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
@@ -645,6 +657,23 @@
 
 	  If unsure, say N.
 
+config PATA_SCC
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on ATA_SFF_PATA && PCI && PPC_CELLEB
+	help
+	  This option enables support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+
+	  If unsure, say N.
+
+config SATA_ULI
+	tristate "ULi Electronics SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for ULi Electronics SATA.
+
+	  If unsure, say N.
+
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on ATA_SFF_PATA && PCI
@@ -654,6 +683,22 @@
 
 	  If unsure, say N.
 
+config SATA_VIA
+	tristate "VIA SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for VIA Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_VITESSE
+	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
+	depends on ATA_SFF_SATA && PCI
+	help
+	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
+
+	  If unsure, say N.
+
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
 	depends on ATA_SFF_PATA && PCI
@@ -697,50 +742,5 @@
 
 	  If unsure, say N.
 
-config PATA_ICSIDE
-	tristate "Acorn ICS PATA support"
-	depends on ATA_SFF_PATA && ARM && ARCH_ACORN
-	help
-	  On Acorn systems, say Y here if you wish to use the ICS PATA
-	  interface card.  This is not required for ICS partition support.
-	  If you are unsure, say N to this.
-
-config PATA_IXP4XX_CF
-	tristate "IXP4XX Compact Flash support"
-	depends on ATA_SFF_PATA && ARCH_IXP4XX
-	help
-	  This option enables support for a Compact Flash connected on
-	  the ixp4xx expansion bus. This driver had been written for
-	  Loft/Avila boards in mind but can work with others.
-
-	  If unsure, say N.
-
-config PATA_SCC
-	tristate "Toshiba's Cell Reference Set IDE support"
-	depends on ATA_SFF_PATA && PCI && PPC_CELLEB
-	help
-	  This option enables support for the built-in IDE controller on
-	  Toshiba Cell Reference Board.
-
-	  If unsure, say N.
-
-config PATA_SCH
-	tristate "Intel SCH PATA support"
-	depends on ATA_SFF_PATA && PCI
-	help
-	  This option enables support for Intel SCH PATA on the Intel
-	  SCH (US15W, US15L, UL11L) series host controllers.
-
-	  If unsure, say N.
-
-config PATA_BF54X
-	tristate "Blackfin 54x ATAPI support"
-	depends on ATA_SFF_PATA && (BF542 || BF548 || BF549)
-	help
-	  This option enables support for the built-in ATAPI controller on
-	  Blackfin 54x family chips.
-
-	  If unsure, say N.
-
 endif # ATA_SFF
 endif # ATA
