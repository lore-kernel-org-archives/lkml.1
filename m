Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbYHHWfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbYHHWfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYHHWfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:35:00 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:55748 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbYHHWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:34:58 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
Date: Sat, 09 Aug 2008 08:34:40 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain> <20080808172629.232bed01@lxorguk.ukuu.org.uk>
In-Reply-To: <20080808172629.232bed01@lxorguk.ukuu.org.uk>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 17:26:29 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>On Fri, 8 Aug 2008 12:32:23 -0400 (EDT)
>"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
>
>> 
>>   asked from a position of appalling ignorance, but would it be more
>> organized to be able to select serial ATA functionality separately
>> from parallel ATA? 
>
>The correct fix is to remove the (experimental) from the Parallel ATA
>drivers Kconfig
>
>For the rest of the menu the list is SATA first, then PATA (and PATA is
>roughly alphabetic but both want a tidy)

Well, since Robert didn't have a go, I did ;)  How about:

 .config - Linux Kernel v2.6.27-rc2 Configuration
 ------------------------------------------------------------------------------
  +----------- Serial ATA (SATA) and Parallel ATA (PATA) drivers -----------+
  ¦  Arrow keys navigate the menu.  <Enter> selects submenus --->.          ¦
  ¦  Highlighted letters are hotkeys.  Pressing <Y> includes, <N> excludes, ¦
  ¦  <M> modularizes features.  Press <Esc><Esc> to exit, <?> for Help, </> ¦
  ¦  for Search.  Legend: [*] built-in  [ ] excluded  <M> module  < >       ¦
  ¦ +---------------------------------------------------------------------+ ¦
  ¦ ¦    --- Serial ATA (SATA) and Parallel ATA (PATA) drivers            ¦ ¦
  ¦ ¦    <*>   AHCI SATA support                                          ¦ ¦
  ¦ ¦    [*]   ATA ACPI Support                                           ¦ ¦
  ¦ ¦    [ ]   SATA Port Multiplier support                               ¦ ¦
  ¦ ¦    < >   Silicon Image 3124/3132 SATA support                       ¦ ¦
  ¦ ¦    [*]   ATA SFF support                                            ¦ ¦
  ¦ ¦            *** Serial ATA drivers ***                               ¦ ¦
  ¦ ¦    < >     Initio 162x SATA support                                 ¦ ¦
  ¦ ¦    < >     Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support           ¦ ¦
  ¦ ¦    < >     Marvell SATA support (HIGHLY EXPERIMENTAL)               ¦ ¦
  ¦ ¦    < >     NVIDIA SATA support                                      ¦ ¦
  ¦ ¦    < >     Pacific Digital ADMA support                             ¦ ¦
  ¦ ¦    < >     Pacific Digital SATA QStor support                       ¦ ¦
  ¦ ¦    < >     Promise SATA SX4 support                                 ¦ ¦
  ¦ ¦    < >     Promise SATA TX2/TX4 support                             ¦ ¦
  ¦ ¦    < >     Silicon Image SATA support                               ¦ ¦
  ¦ ¦    < >     SiS 964/965/966/180 SATA support                         ¦ ¦
  ¦ ¦    < >     ServerWorks Frodo / Apple K2 SATA support                ¦ ¦
  ¦ ¦    < >     ULi Electronics SATA support                             ¦ ¦
  ¦ ¦    < >     VIA SATA support                                         ¦ ¦
  ¦ ¦    < >     VITESSE VSC-7174 / INTEL 31244 SATA support              ¦ ¦
  ¦ ¦            *** Parallel ATA drivers ***                             ¦ ¦
  ¦ ¦    < >     ACPI firmware driver for PATA                            ¦ ¦
  ¦ ¦    < >     ALi PATA support (Experimental)                          ¦ ¦
  ¦ ¦    < >     AMD/NVidia PATA support                                  ¦ ¦
  ¦ ¦    < >     ARTOP 6210/6260 PATA support                             ¦ ¦
  ¦ ¦    < >     ATI PATA support                                         ¦ ¦
  ¦ ¦    < >     CMD640 PCI PATA support (Very Experimental)              ¦ ¦
  ¦ ¦    < >     CMD64x PATA support                                      ¦ ¦
  ¦ ¦    < >     CMD / Silicon Image 680 PATA support                     ¦ ¦
  ¦ ¦    < >     Compaq Triflex PATA support                              ¦ ¦
  ¦ ¦    < >     CS5510/5520 PATA support                                 ¦ ¦
  ¦ ¦    < >     CS5530 PATA support (Experimental)                       ¦ ¦
  ¦ ¦    < >     Cypress CY82C693 PATA support (Very Experimental)        ¦ ¦
  ¦ ¦    < >     EFAR SLC90E66 support                                    ¦ ¦
  ¦ ¦    < >     Generic ATA support                                      ¦ ¦
  ¦ ¦    < >     HPT 366/368 PATA support                                 ¦ ¦
  ¦ ¦    < >     HPT 370/370A/371/372/374/302 PATA support (Experimental) ¦ ¦
  ¦ ¦    < >     HPT 372N/302N PATA support (Very Experimental)           ¦ ¦
  ¦ ¦    < >     HPT 343/363 PATA support                                 ¦ ¦
  ¦ ¦    < >     Intel PATA MPIIX support                                 ¦ ¦
  ¦ ¦    < >     Intel PATA old PIIX support                              ¦ ¦
  ¦ ¦    < >     Intel SCH PATA support                                   ¦ ¦
  ¦ ¦    < >     IT8211/2 PATA support                                    ¦ ¦
  ¦ ¦    < >     IT8213 PATA support (Experimental)                       ¦ ¦
  ¦ ¦    <*>     JMicron PATA support                                     ¦ ¦
  ¦ ¦    < >     Marvell PATA support via legacy mode                     ¦ ¦
  ¦ ¦    < >     Nat Semi NS87410 PATA support (Experimental)             ¦ ¦
  ¦ ¦    < >     Nat Semi NS87415 PATA support (Experimental)             ¦ ¦
  ¦ ¦    < >     NETCELL Revolution RAID support                          ¦ ¦
  ¦ ¦    < >     Ninja32/Delkin Cardbus ATA support (Experimental)        ¦ ¦
  ¦ ¦    < >     OPTI621/6215 PATA support (Very Experimental)            ¦ ¦
  ¦ ¦    < >     OPTI FireStar PATA support (Very Experimental)           ¦ ¦
  ¦ ¦    < >     Promise PATA 2027x support                               ¦ ¦
  ¦ ¦    < >     Older Promise PATA controller support (Experimental)     ¦ ¦
  ¦ ¦    < >     RADISYS 82600 PATA support (Very Experimental)           ¦ ¦
  ¦ ¦    < >     PC Tech RZ1000 PATA support                              ¦ ¦
  ¦ ¦    < >     SC1200 PATA support (Very Experimental)                  ¦ ¦
  ¦ ¦    < >     SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support           ¦ ¦
  ¦ ¦    < >     SiS PATA support (Experimental)                          ¦ ¦
  ¦ ¦    < >     VIA PATA support                                         ¦ ¦
  ¦ ¦    < >     Winbond SL82C105 PATA support                            ¦ ¦
  ¦ +---------------------------------------------------------------------+ ¦
  +-------------------------------------------------------------------------¦
  ¦                    <Select>    < Exit >    < Help >                     ¦
  +-------------------------------------------------------------------------+

From: Grant Coady <gcoady.lk@gmail.com>

Cleanup Serial ATA and Parallel ATA drivers Kconfig

Sort the menu items as suggested by Alan Cox, I left the platform
devices at the end, poetic license with 'Older Promise', and of
course where should Intel's ICH ... PATA/SATA go?

Made the 'If unsure...' look alike and added missing entry.

Should 'SATA Port Multiplier support' default to 'Y'?  Because it
at present, is I added If unsure, say 'Y' to it.  Doesn't seem
right though...  Compile tested on x86_64.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |  296 +++++++++++++++++++++++++++++++++-------------------------------
 1 files changed, 155 insertions(+), 141 deletions(-)

--- drivers/ata/Kconfig.orig	2008-07-14 07:51:29.000000000 +1000
+++ drivers/ata/Kconfig	2008-08-09 07:01:39.418858173 +1000
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
@@ -41,6 +49,17 @@
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+	  If unsure, say Y.
+
+config SATA_FSL
+	tristate "Freescale 3.0Gbps SATA support"
+	depends on FSL_SOC
+	help
+	  This option enables support for Freescale 3.0Gbps SATA controller.
+	  It can be found on MPC837x and MPC8315.
+
+	  If unsure, say N.
+
 config SATA_PMP
 	bool "SATA Port Multiplier support"
 	default y
@@ -48,13 +67,7 @@
 	  This option adds support for SATA Port Multipliers
 	  (the SATA version of an ethernet hub, or SAS expander).
 
-config SATA_AHCI
-	tristate "AHCI SATA support"
-	depends on PCI
-	help
-	  This option enables support for AHCI Serial ATA.
-
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
@@ -64,15 +77,6 @@
 
 	  If unsure, say N.
 
-config SATA_FSL
-	tristate "Freescale 3.0Gbps SATA support"
-	depends on FSL_SOC
-	help
-	  This option enables support for Freescale 3.0Gbps SATA controller.
-	  It can be found on MPC837x and MPC8315.
-
-	  If unsure, say N.
-
 config ATA_SFF
 	bool "ATA SFF support"
 	default y
@@ -93,14 +97,14 @@
 
 if ATA_SFF
 
-config SATA_SVW
-	tristate "ServerWorks Frodo / Apple K2 SATA support"
+comment	"Serial ATA drivers"
+	depends on ATA_SFF
+
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
 	depends on PCI
 	help
-	  This option enables support for Broadcom/Serverworks/Apple K2
-	  SATA support.
-
-	  If unsure, say N.
+	  This option enables support for Initio 162x Serial ATA.
 
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
@@ -145,14 +149,6 @@
 
 	  If unsure, say N.
 
-config SATA_PROMISE
-	tristate "Promise SATA TX2/TX4 support"
-	depends on PCI
-	help
-	  This option enables support for Promise Serial ATA TX2/TX4.
-
-	  If unsure, say N.
-
 config SATA_SX4
 	tristate "Promise SATA SX4 support"
 	depends on PCI && EXPERIMENTAL
@@ -161,6 +157,14 @@
 
 	  If unsure, say N.
 
+config SATA_PROMISE
+	tristate "Promise SATA TX2/TX4 support"
+	depends on PCI
+	help
+	  This option enables support for Promise Serial ATA TX2/TX4.
+
+	  If unsure, say N.
+
 config SATA_SIL
 	tristate "Silicon Image SATA support"
 	depends on PCI
@@ -178,6 +182,16 @@
 	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
 	  The PATA support for SiS 180 requires additionally to
 	  enable the PATA_SIS driver in the config.
+
+	  If unsure, say N.
+
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	depends on PCI
+	help
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
 	  If unsure, say N.
 
 config SATA_ULI
@@ -204,11 +218,8 @@
 
 	  If unsure, say N.
 
-config SATA_INIC162X
-	tristate "Initio 162x SATA support"
-	depends on PCI
-	help
-	  This option enables support for Initio 162x Serial ATA.
+comment	"Parallel ATA drivers"
+	depends on ATA_SFF
 
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
@@ -219,6 +230,15 @@
 	  firmware in the BIOS. This driver can sometimes handle
 	  otherwise unsupported hardware.
 
+config PATA_ICSIDE
+	tristate "Acorn ICS PATA support"
+	depends on ARM && ARCH_ACORN
+	help
+	  On Acorn systems, say Y here if you wish to use the ICS PATA
+	  interface card.  This is not required for ICS partition support.
+
+	  If unsure, say N.
+
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -263,6 +283,15 @@
 
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
@@ -282,6 +311,23 @@
 
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
@@ -336,6 +382,15 @@
 
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
@@ -389,6 +444,31 @@
 	  controllers. Enable with care as there are still some
 	  problems with DMA on this chipset.
 
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
+	depends on PCI
+	help
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
+
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
@@ -417,6 +497,16 @@
 
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
@@ -435,15 +525,6 @@
 
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
@@ -453,28 +534,21 @@
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx
-	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
-
-	  If unsure, say N.
-
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
 
@@ -496,24 +570,6 @@
 
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
-	help
-	  This option enables support for the National Semiconductor
-	  NS87415 PCI-IDE controller.
-
-	  If unsure, say N.
-
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -542,6 +598,14 @@
 
 	  If unsure, say N.
 
+config PATA_PDC2027X
+	tristate "Promise PATA 2027x support"
+	depends on PCI
+	help
+	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+
+	  If unsure, say N.
+
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -602,22 +666,6 @@
 
 	  If unsure, say N.
 
-config PATA_PDC2027X
-	tristate "Promise PATA 2027x support"
-	depends on PCI
-	help
-	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
-
-	  If unsure, say N.
-
-config PATA_SIL680
-	tristate "CMD / Silicon Image 680 PATA support"
-	depends on PCI
-	help
-	  This option enables support for CMD / Silicon Image 680 PATA.
-
-	  If unsure, say N.
-
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -626,6 +674,15 @@
 
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
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
@@ -651,6 +708,8 @@
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
 
+	  If unsure, say N.
+
 config HAVE_PATA_PLATFORM
 	bool
 	help
@@ -678,50 +737,5 @@
 
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
