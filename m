Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYHJBIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYHJBIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 21:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYHJBID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 21:08:03 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:65330 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbYHJBIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 21:08:01 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig try2
Date: Sun, 10 Aug 2008 11:07:30 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <nifs94lqm5a3qjr3rm2p9mks5tad33cbmi@4ax.com>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain> <20080808172629.232bed01@lxorguk.ukuu.org.uk> <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com> <m3sktfw1v5.fsf@maximus.localdomain> <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain> <20080809103331.1d475d5c@lxorguk.ukuu.org.uk> <m3zlnm75u1.fsf@maximus.localdomain> <20080809141028.14db9bc7@lxorguk.ukuu.org.uk> <m3skteuhod.fsf@maximus.localdomain> <20080809215918.32f25c4b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080809215918.32f25c4b@lxorguk.ukuu.org.uk>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008 21:59:18 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> Even if we do, we can still sort the single driver list
>> alphabetically, and we can still "select ATA_SFF" instead of the other
>> way around.
>
>That I agree with entirely.
>
>Alan

Okay, here's another try:

  ¦ ¦    --- Serial ATA (SATA) and Parallel ATA (PATA) drivers            ¦ ¦
  ¦ ¦    <*>   AHCI SATA support                                          ¦ ¦
  ¦ ¦    [*]   ATA ACPI Support                                           ¦ ¦
  ¦ ¦    [ ]   SATA Port Multiplier support                               ¦ ¦
  ¦ ¦    < >   Silicon Image 3124/3132 SATA support                       ¦ ¦
  ¦ ¦    [*]   Parallel ATA (PATA) support                                ¦ ¦
  ¦ ¦    [*]   Serial ATA (SATA) support                                  ¦ ¦
  ¦ ¦    < >   ACPI firmware driver for PATA                              ¦ ¦
  ¦ ¦    < >   ALi PATA support (Experimental)                            ¦ ¦
  ¦ ¦    < >   AMD/NVidia PATA support                                    ¦ ¦
  ¦ ¦    < >   ARTOP 6210/6260 PATA support                               ¦ ¦
  ¦ ¦    < >   ATI PATA support                                           ¦ ¦
  ¦ ¦    < >   CMD640 PCI PATA support (Very Experimental)                ¦ ¦
  ¦ ¦    < >   CMD64x PATA support                                        ¦ ¦
  ¦ ¦    < >   CMD / Silicon Image 680 PATA support                       ¦ ¦
  ¦ ¦    < >   Compaq Triflex PATA support                                ¦ ¦
  ¦ ¦    < >   CS5510/5520 PATA support                                   ¦ ¦
  ¦ ¦    < >   CS5530 PATA support (Experimental)                         ¦ ¦
  ¦ ¦    < >   Cypress CY82C693 PATA support (Very Experimental)          ¦ ¦
  ¦ ¦    < >   EFAR SLC90E66 support                                      ¦ ¦
  ¦ ¦    < >   Generic ATA support                                        ¦ ¦
  ¦ ¦    < >   HPT 366/368 PATA support                                   ¦ ¦
  ¦ ¦    < >   HPT 370/370A/371/372/374/302 PATA support (Experimental)   ¦ ¦
  ¦ ¦    < >   HPT 372N/302N PATA support (Very Experimental)             ¦ ¦
  ¦ ¦    < >   HPT 343/363 PATA support                                   ¦ ¦
  ¦ ¦    < >   Initio 162x SATA support (NEW)                             ¦ ¦
  ¦ ¦    < >   Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support (NEW)       ¦ ¦
  ¦ ¦    < >   Intel PATA MPIIX support                                   ¦ ¦
  ¦ ¦    < >   Intel PATA old PIIX support                                ¦ ¦
  ¦ ¦    < >   Intel SCH PATA support                                     ¦ ¦
  ¦ ¦    < >   IT8211/2 PATA support                                      ¦ ¦
  ¦ ¦    < >   IT8213 PATA support (Experimental)                         ¦ ¦
  ¦ ¦    <*>   JMicron PATA support                                       ¦ ¦
  ¦ ¦    < >   Marvell PATA support via legacy mode                       ¦ ¦
  ¦ ¦    < >   Marvell SATA support (HIGHLY EXPERIMENTAL) (NEW)           ¦ ¦
  ¦ ¦    < >   Nat Semi NS87410 PATA support (Experimental)               ¦ ¦
  ¦ ¦    < >   Nat Semi NS87415 PATA support (Experimental)               ¦ ¦
  ¦ ¦    < >   NETCELL Revolution RAID support                            ¦ ¦
  ¦ ¦    < >   Ninja32/Delkin Cardbus ATA support (Experimental)          ¦ ¦
  ¦ ¦    < >   NVIDIA SATA support (NEW)                                  ¦ ¦
  ¦ ¦    < >   OPTI621/6215 PATA support (Very Experimental)              ¦ ¦
  ¦ ¦    < >   OPTI FireStar PATA support (Very Experimental)             ¦ ¦
  ¦ ¦    < >   Pacific Digital ADMA support (NEW)                         ¦ ¦
  ¦ ¦    < >   Pacific Digital SATA QStor support (NEW)                   ¦ ¦
  ¦ ¦    < >   Promise PATA 2027x support                                 ¦ ¦
  ¦ ¦    < >   Promise old PATA controller support (Experimental)         ¦ ¦
  ¦ ¦    < >   Promise SATA SX4 support (NEW)                             ¦ ¦
  ¦ ¦    < >   Promise SATA TX2/TX4 support (NEW)                         ¦ ¦
  ¦ ¦    < >   RADISYS 82600 PATA support (Very Experimental)             ¦ ¦
  ¦ ¦    < >   PC Tech RZ1000 PATA support                                ¦ ¦
  ¦ ¦    < >   SC1200 PATA support (Very Experimental)                    ¦ ¦
  ¦ ¦    < >   ServerWorks Frodo / Apple K2 SATA support (NEW)            ¦ ¦
  ¦ ¦    < >   ServerWorks OSB4/CSB5/CSB6/HT1000 PATA support             ¦ ¦
  ¦ ¦    < >   Silicon Image SATA support (NEW)                           ¦ ¦
  ¦ ¦    < >   SiS 964/965/966/180 SATA support (NEW)                     ¦ ¦
  ¦ ¦    < >   SiS PATA support (Experimental)                            ¦ ¦
  ¦ ¦    < >   ULi Electronics SATA support (NEW)                         ¦ ¦
  ¦ ¦    < >   VIA PATA support                                           ¦ ¦
  ¦ ¦    < >   VIA SATA support (NEW)                                     ¦ ¦
  ¦ ¦    < >   VITESSE VSC-7174 / INTEL 31244 SATA support (NEW)          ¦ ¦
  ¦ ¦    < >   Winbond SL82C105 PATA support                              ¦ ¦


From: Grant Coady <gcoady.lk@gmail.com>

Cleanup ATA Kconfig

Cleanup ATA Kconfig, hide the SFF option behind new PATA and SATA menu 
items, sort drivers into a single list, add missing "if unsure, say..."
help text.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |  555 +++++++++++++++++++++++++++++++++++++---------------------------
 1 files changed, 328 insertions(+), 227 deletions(-)

--- linux-2.6.27-rc2/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
+++ linux-2.6.27-rc2d/drivers/ata/Kconfig	2008-08-10 10:57:33.642213799 +1000
@@ -3,7 +3,7 @@
 #
 
 menuconfig ATA
-	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	tristate "Serial ATA (SATA) and Parallel ATA (PATA) drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
@@ -27,6 +27,14 @@
        bool
        default n
 
+config SATA_AHCI
+	tristate "AHCI SATA support"
+	depends on PCI
+	help
+	  This option enables support for AHCI Serial ATA.
+
+	  If unsure, say N.
+
 config ATA_ACPI
 	bool "ATA ACPI Support"
 	depends on ACPI && PCI
@@ -41,28 +49,7 @@
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
-config SATA_PMP
-	bool "SATA Port Multiplier support"
-	default y
-	help
-	  This option adds support for SATA Port Multipliers
-	  (the SATA version of an ethernet hub, or SAS expander).
-
-config SATA_AHCI
-	tristate "AHCI SATA support"
-	depends on PCI
-	help
-	  This option enables support for AHCI Serial ATA.
-
-	  If unsure, say N.
-
-config SATA_SIL24
-	tristate "Silicon Image 3124/3132 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Silicon Image 3124/3132 Serial ATA.
-
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
@@ -73,155 +60,82 @@
 
 	  If unsure, say N.
 
-config ATA_SFF
-	bool "ATA SFF support"
+config SATA_PMP
+	bool "SATA Port Multiplier support"
 	default y
 	help
-	  This option adds support for ATA controllers with SFF
-	  compliant or similar programming interface.
-
-	  SFF is the legacy IDE interface that has been around since
-	  the dawn of time.  Almost all PATA controllers have an
-	  SFF interface.  Many SATA controllers have an SFF interface
-	  when configured into a legacy compatibility mode.
-
-	  For users with exclusively modern controllers like AHCI,
-	  Silicon Image 3124, or Marvell 6440, you may choose to
-	  disable this uneeded SFF support.
+	  This option adds support for SATA Port Multipliers
+	  (the SATA version of an ethernet hub, or SAS expander).
 
 	  If unsure, say Y.
 
-if ATA_SFF
-
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
+config SATA_SIL24
+	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
 	help
-	  This option enables support for Pacific Digital Serial ATA QStor.
+	  This option enables support for Silicon Image 3124/3132 Serial ATA.
 
 	  If unsure, say N.
 
-config SATA_PROMISE
-	tristate "Promise SATA TX2/TX4 support"
-	depends on PCI
-	help
-	  This option enables support for Promise Serial ATA TX2/TX4.
-
-	  If unsure, say N.
+config ATA_SFF
+	bool
+	default n
 
-config SATA_SX4
-	tristate "Promise SATA SX4 support"
-	depends on PCI && EXPERIMENTAL
+config ATA_SFF_PATA
+	bool "Parallel ATA (PATA) support"
+	default y
+	select ATA_SFF
 	help
-	  This option enables support for Promise Serial ATA SX4.
-
-	  If unsure, say N.
+	  Say Y here if you want support for Parallel ATA (PATA) devices, 
+	  also known as IDE devices.
 
-config SATA_SIL
-	tristate "Silicon Image SATA support"
-	depends on PCI
-	help
-	  This option enables support for Silicon Image Serial ATA.
+	  This option enables a list of available PATA drivers.
 
-	  If unsure, say N.
+	  You may turn this option off if running AHCI or similar devices.
 
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
+	  If unsure, say Y.
 
-config SATA_VIA
-	tristate "VIA SATA support"
-	depends on PCI
+config ATA_SFF_SATA
+	bool "Serial ATA (SATA) support"
+	default y
+	select ATA_SFF
 	help
-	  This option enables support for VIA Serial ATA.
+	  Say Y here if you want support for Serial ATA (SATA) devices.
 
-	  If unsure, say N.
+	  This option enables a list of available SATA drivers.
 
-config SATA_VITESSE
-	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
-	depends on PCI
-	help
-	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
+	  You may turn this option off if running AHCI or similar devices. 
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
-config SATA_INIC162X
-	tristate "Initio 162x SATA support"
-	depends on PCI
-	help
-	  This option enables support for Initio 162x Serial ATA.
+if ATA_SFF
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
 	depends on ATA_ACPI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables an ACPI method driver which drives
 	  motherboard PATA controller interfaces through the ACPI
 	  firmware in the BIOS. This driver can sometimes handle
 	  otherwise unsupported hardware.
 
+	  If unsure, say Y.
+
+config PATA_ICSIDE
+	tristate "Acorn ICS PATA support"
+	depends on ARM && ARCH_ACORN
+	depends on ATA_SFF_PATA
+	help
+	  On Acorn systems, say Y here if you wish to use the ICS PATA
+	  interface card.  This is not required for ICS partition support.
+
+	  If unsure, say N.
+
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the ALi ATA interfaces
 	  found on the many ALi chipsets.
@@ -231,6 +145,7 @@
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the AMD and NVidia PATA
 	  interfaces found on the chipsets for Athlon/Athlon64.
@@ -240,6 +155,7 @@
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -248,6 +164,7 @@
 config PATA_AT32
 	tristate "Atmel AVR32 PATA support (Experimental)"
 	depends on AVR32 && PLATFORM_AT32AP && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the IDE devices on the
 	  Atmel AT32AP platform.
@@ -257,15 +174,27 @@
 config PATA_ATIIXP
 	tristate "ATI PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the ATI ATA interfaces
 	  found on the many ATI chipsets.
 
 	  If unsure, say N.
 
+config PATA_BF54X
+	tristate "Blackfin 54x ATAPI support"
+	depends on BF542 || BF548 || BF549
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for the built-in ATAPI controller on
+	  Blackfin 54x family chips.
+
+	  If unsure, say N.
+
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the CMD640 PCI IDE
 	  interface chip. Only the primary channel is currently
@@ -276,15 +205,36 @@
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
 
 	  If unsure, say N.
 
+config PATA_SIL680
+	tristate "CMD / Silicon Image 680 PATA support"
+	depends on PCI
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for CMD / Silicon Image 680 PATA.
+
+	  If unsure, say N.
+
+config PATA_TRIFLEX
+	tristate "Compaq Triflex PATA support"
+	depends on PCI
+	depends on ATA_SFF_PATA
+	help
+	  Enable support for the Compaq 'Triflex' IDE controller as found
+	  on many Compaq Pentium-Pro systems, via the new ATA layer.
+
+	  If unsure, say N.
+
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the Cyrix 5510/5520
 	  companion chip used with the MediaGX/Geode processor family.
@@ -294,6 +244,7 @@
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
 	  companion chip used with the MediaGX/Geode processor family.
@@ -303,6 +254,7 @@
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
 	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
@@ -312,6 +264,7 @@
 config PATA_CS5536
 	tristate "CS5536 PATA support (Experimental)"
 	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -321,6 +274,7 @@
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
@@ -330,15 +284,27 @@
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the EFAR SLC90E66
 	  IDE controller found on some older machines.
 
 	  If unsure, say N.
 
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on PPC_MPC52xx
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
 config ATA_GENERIC
 	tristate "Generic ATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for generic BIOS configured
 	  ATA controllers via the new ATA layer
@@ -348,6 +314,7 @@
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
@@ -357,6 +324,7 @@
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -366,6 +334,7 @@
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer
@@ -375,6 +344,7 @@
 config PATA_HPT3X3
 	tristate "HPT 343/363 PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the HPT 343/363
 	  PATA controllers via the new ATA layer
@@ -384,14 +354,64 @@
 config PATA_HPT3X3_DMA
 	bool "HPT 343/363 DMA support (Experimental)"
 	depends on PATA_HPT3X3
+	depends on ATA_SFF_PATA
 	help
 	  This option enables DMA support for the HPT343/363
 	  controllers. Enable with care as there are still some
 	  problems with DMA on this chipset.
 
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
+	depends on PCI
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for Initio 162x Serial ATA.
+
+	  If unsure, say N.
+
+config ATA_PIIX
+	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
+	depends on PCI
+	depends on ATA_SFF_PATA_SUPPORT || ATA_SFF_SATA
+	help
+	  This option enables support for ICH5/6/7/8 Serial ATA
+	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
+	  host controllers.
+
+	  If unsure, say N.
+
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
+	depends on PCI
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for MPIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_OLDPIIX
+	tristate "Intel PATA old PIIX support"
+	depends on PCI
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for early PIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_SCH
+	tristate "Intel SCH PATA support"
+	depends on PCI
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for Intel SCH PATA on the Intel
+	  SCH (US15W, US15L, UL11L) series host controllers.
+
+	  If unsure, say N.
+
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for ISA plug & play ATA
 	  controllers such as those found on old soundcards.
@@ -401,6 +421,7 @@
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -411,15 +432,28 @@
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the ITE 821 PATA
           controllers via the new ATA layer.
 
 	  If unsure, say N.
 
+config PATA_IXP4XX_CF
+	tristate "IXP4XX Compact Flash support"
+	depends on ARCH_IXP4XX
+	depends on ATA_SFF_PATA
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
+	depends on ATA_SFF_PATA
 	help
 	  Enable support for the JMicron IDE controller, via the new
 	  ATA layer.
@@ -429,58 +463,57 @@
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
 
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
+	depends on ATA_SFF_PATA
 	help
 	  This option enables limited support for the Marvell 88SE6145 ATA
 	  controller.
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx
+config SATA_MV
+	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on ATA_SFF_SATA
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
+	depends on ATA_SFF_PATA
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
+	depends on ATA_SFF_PATA
 	help
-	  This option enables support for early PIIX PATA support.
+	  This option enables support for the National Semiconductor
+	  NS87415 PCI-IDE controller.
 
 	  If unsure, say N.
 
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the Netcell Revolution RAID
 	  PATA controller.
@@ -490,33 +523,26 @@
 config PATA_NINJA32
 	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the Ninja32, Delkin and
 	  possibly other brands of Cardbus ATA adapter
 
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
+	depends on ATA_SFF_SATA
 	help
-	  This option enables support for the National Semiconductor
-	  NS87415 PCI-IDE controller.
+	  This option enables support for NVIDIA Serial ATA.
 
 	  If unsure, say N.
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -526,6 +552,7 @@
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -533,33 +560,85 @@
 
 	  If unsure, say N.
 
+config PDC_ADMA
+	tristate "Pacific Digital ADMA support"
+	depends on PCI
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for Pacific Digital ADMA controllers
+
+	  If unsure, say N.
+
+config SATA_QSTOR
+	tristate "Pacific Digital SATA QStor support"
+	depends on PCI
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for Pacific Digital Serial ATA QStor.
+
+	  If unsure, say N.
+
 config PATA_PCMCIA
 	tristate "PCMCIA PATA support"
 	depends on PCMCIA
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for PCMCIA ATA interfaces, including
 	  compact flash card adapters via the new ATA layer.
 
 	  If unsure, say N.
 
+config PATA_PDC2027X
+	tristate "Promise PATA 2027x support"
+	depends on PCI
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for Promise PATA pdc20268
+	  to pdc20277 host adapters.
+
+	  If unsure, say N.
+
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support (Experimental)"
+	tristate "Promise old PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
 
 	  If unsure, say N.
 
+config SATA_SX4
+	tristate "Promise SATA SX4 support"
+	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for Promise Serial ATA SX4.
+
+	  If unsure, say N.
+
+config SATA_PROMISE
+	tristate "Promise SATA TX2/TX4 support"
+	depends on PCI
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for Promise Serial ATA TX2/TX4.
+
+	  If unsure, say N.
+
 config PATA_QDI
 	tristate "QDI VLB PATA support"
 	depends on ISA
+	depends on ATA_SFF_PATA
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
+	  If unsure, say N.
+
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the RADISYS 82600
 	  PATA controllers via the new ATA layer
@@ -569,6 +648,7 @@
 config PATA_RB532
 	tristate "RouterBoard 532 PATA CompactFlash support"
 	depends on MIKROTIK_RB532
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the RouterBoard 532
 	  PATA CompactFlash controller.
@@ -578,6 +658,7 @@
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables basic support for the PC Tech RZ1000/1
 	  PATA controllers via the new ATA layer
@@ -587,57 +668,116 @@
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
 
 	  If unsure, say N.
 
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	depends on PCI
+	depends on ATA_SFF_SATA
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
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
 
 	  If unsure, say N.
 
-config PATA_PDC2027X
-	tristate "Promise PATA 2027x support"
+config SATA_SIL
+	tristate "Silicon Image SATA support"
 	depends on PCI
+	depends on ATA_SFF_SATA
 	help
-	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+	  This option enables support for Silicon Image Serial ATA.
 
 	  If unsure, say N.
 
-config PATA_SIL680
-	tristate "CMD / Silicon Image 680 PATA support"
+config SATA_SIS
+	tristate "SiS 964/965/966/180 SATA support"
 	depends on PCI
+	depends on ATA_SFF_SATA
+	select PATA_SIS
 	help
-	  This option enables support for CMD / Silicon Image 680 PATA.
+	  This option enables support for SiS Serial ATA on
+	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
+	  The PATA support for SiS 180 requires additionally to
+	  enable the PATA_SIS driver in the config.
 
 	  If unsure, say N.
 
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for SiS PATA controllers
 
 	  If unsure, say N.
 
+config PATA_SCC
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on PCI && PPC_CELLEB
+	depends on ATA_SFF_PATA
+	help
+	  This option enables support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+
+	  If unsure, say N.
+
+config SATA_ULI
+	tristate "ULi Electronics SATA support"
+	depends on PCI
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for ULi Electronics SATA.
+
+	  If unsure, say N.
+
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for the VIA PATA interfaces
 	  found on the many VIA chipsets.
 
 	  If unsure, say N.
 
+config SATA_VIA
+	tristate "VIA SATA support"
+	depends on PCI
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for VIA Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_VITESSE
+	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
+	depends on PCI
+	depends on ATA_SFF_SATA
+	help
+	  This option enables support for Vitesse VSC7174 and
+	  Intel 31244 Serial ATA.
+
+	  If unsure, say N.
+
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
 	depends on PCI
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for SL82C105 PATA devices found in the
 	  Netwinder and some other systems
@@ -647,12 +787,16 @@
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	depends on ATA_SFF_PATA
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
 
+	  If unsure, say N.
+
 config HAVE_PATA_PLATFORM
 	bool
+	depends on ATA_SFF_PATA
 	help
 	  This is an internal configuration node for any machine that
 	  uses pata-platform driver to enable the relevant driver in the
@@ -662,6 +806,7 @@
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
 	depends on EMBEDDED || ARCH_RPC || PPC || HAVE_PATA_PLATFORM
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
@@ -671,6 +816,7 @@
 config PATA_OF_PLATFORM
 	tristate "OpenFirmware platform device PATA support"
 	depends on PATA_PLATFORM && PPC_OF
+	depends on ATA_SFF_PATA
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems with OpenFirmware
@@ -678,50 +824,5 @@
 
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
