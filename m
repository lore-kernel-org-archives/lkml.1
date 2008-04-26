Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYDZWWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYDZWWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYDZWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:21:53 -0400
Received: from mail.cyberdogtech.com ([64.22.125.39]:41487 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbYDZWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:21:52 -0400
Date: Sat, 26 Apr 2008 17:21:47 -0500
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] 2.6.25-git7 - Kconfig Cleanup
Message-Id: <20080426172147.a73657aa.kernel1@cyberdogtech.com>
In-Reply-To: <20080425232848.b4200d21.kernel1@cyberdogtech.com>
References: <20080425232848.b4200d21.kernel1@cyberdogtech.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One change below, per request.

On Fri, 25 Apr 2008 23:28:48 -0500
Matt LaPlante <kernel1@cyberdogtech.com> wrote:

> Fix misc small typos/grammar in Kconfigs for 2.6.25-git7.
> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> --
> 

diff -ru a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig	2008-04-25 21:26:24.000000000 -0500
+++ b/arch/blackfin/Kconfig	2008-04-25 22:22:45.000000000 -0500
@@ -772,7 +772,7 @@
 	  memory they do not own.  This comes at a performance penalty
 	  and is recommended only for debugging.
 
-comment "Asynchonous Memory Configuration"
+comment "Asynchronous Memory Configuration"
 
 menu "EBIU_AMGCTL Global Control"
 config C_AMCKEN
@@ -804,7 +804,7 @@
 	default n
 
 choice
-	prompt"Enable Asynchonous Memory Banks"
+	prompt"Enable Asynchronous Memory Banks"
 	default C_AMBEN_ALL
 
 config C_AMBEN
diff -ru a/arch/cris/arch-v32/Kconfig b/arch/cris/arch-v32/Kconfig
--- a/arch/cris/arch-v32/Kconfig	2008-04-26 17:12:34.000000000 -0500
+++ b/arch/cris/arch-v32/Kconfig	2008-04-26 17:12:46.000000000 -0500
@@ -28,7 +28,7 @@
 	help
 	  Select this if you want one Ethernet LED group. This LED group
 	  can be used for one or more Ethernet interfaces. However, it is
-	  recomended that each Ethernet interface use a dedicated LED group.
+	  recommended that each Ethernet interface use a dedicated LED group.
 
 config	ETRAX_NBR_LED_GRP_TWO
 	bool "Use two LED groups"
diff -ru a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig	2008-04-25 21:26:25.000000000 -0500
+++ b/arch/powerpc/Kconfig	2008-04-25 22:45:04.000000000 -0500
@@ -323,7 +323,7 @@
 	help
 	  Hypervisor-assisted dump is meant to be a kdump replacement
 	  offering robustness and speed not possible without system
-	  hypervisor assistence.
+	  hypervisor assistance.
 
 	  If unsure, say "N"
 
diff -ru a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
--- a/arch/powerpc/platforms/Kconfig	2008-04-25 21:26:27.000000000 -0500
+++ b/arch/powerpc/platforms/Kconfig	2008-04-25 21:54:50.000000000 -0500
@@ -317,7 +317,7 @@
 config OF_RTC
 	bool
 	help
-	  Uses information from the OF or flattened device tree to instatiate
+	  Uses information from the OF or flattened device tree to instantiate
 	  platform devices for direct mapped RTC chips like the DS1742 or DS1743.
 
 source "arch/powerpc/sysdev/bestcomm/Kconfig"
diff -ru a/arch/powerpc/sysdev/bestcomm/Kconfig b/arch/powerpc/sysdev/bestcomm/Kconfig
--- a/arch/powerpc/sysdev/bestcomm/Kconfig	2008-04-16 21:49:44.000000000 -0500
+++ b/arch/powerpc/sysdev/bestcomm/Kconfig	2008-04-25 22:07:48.000000000 -0500
@@ -9,8 +9,8 @@
 	select PPC_LIB_RHEAP
 	help
 	  BestComm is the name of the communication coprocessor found
-	  on the Freescale MPC5200 family of processor. It's usage is
-	  optionnal for some drivers (like ATA), but required for
+	  on the Freescale MPC5200 family of processor.  Its usage is
+	  optional for some drivers (like ATA), but required for
 	  others (like FEC).
 
 	  If you want to use drivers that require DMA operations,
diff -ru a/arch/ppc/platforms/4xx/Kconfig b/arch/ppc/platforms/4xx/Kconfig
--- a/arch/ppc/platforms/4xx/Kconfig	2008-04-16 21:49:44.000000000 -0500
+++ b/arch/ppc/platforms/4xx/Kconfig	2008-04-25 21:52:33.000000000 -0500
@@ -117,7 +117,7 @@
 
 
 # It's often necessary to know the specific 4xx processor type.
-# Fortunately, it is impled (so far) from the board type, so we
+# Fortunately, it is implied (so far) from the board type, so we
 # don't need to ask more redundant questions.
 config NP405H
 	bool
diff -ru a/arch/sh/Kconfig b/arch/sh/Kconfig
--- a/arch/sh/Kconfig	2008-04-25 21:26:27.000000000 -0500
+++ b/arch/sh/Kconfig	2008-04-25 22:52:11.000000000 -0500
@@ -752,10 +752,10 @@
 	depends on GUSA && CPU_SH3 || (CPU_SH4 && !CPU_SH4A)
 	help
 	  Enabling this option will allow the kernel to implement some
-	  atomic operations using a software implemention of load-locked/
+	  atomic operations using a software implementation of load-locked/
 	  store-conditional (LLSC). On machines which do not have hardware
 	  LLSC, this should be more efficient than the other alternative of
-	  disabling insterrupts around the atomic sequence.
+	  disabling interrupts around the atomic sequence.
 
 endmenu
 
diff -ru a/drivers/ata/Kconfig b/drivers/ata/Kconfig
--- a/drivers/ata/Kconfig	2008-04-25 21:26:27.000000000 -0500
+++ b/drivers/ata/Kconfig	2008-04-25 22:19:27.000000000 -0500
@@ -87,7 +87,7 @@
 
 	  For users with exclusively modern controllers like AHCI,
 	  Silicon Image 3124, or Marvell 6440, you may choose to
-	  disable this uneeded SFF support.
+	  disable this unneeded SFF support.
 
 	  If unsure, say Y.
 
diff -ru a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig	2008-04-16 21:49:44.000000000 -0500
+++ b/drivers/gpio/Kconfig	2008-04-25 21:38:33.000000000 -0500
@@ -17,9 +17,9 @@
 	depends on DEBUG_KERNEL
 	help
 	  Say Y here to add some extra checks and diagnostics to GPIO calls.
-	  The checks help ensure that GPIOs have been properly initialized
-	  before they are used and that sleeping calls aren not made from
-	  nonsleeping contexts.  They can make bitbanged serial protocols
+	  These checks help ensure that GPIOs have been properly initialized
+	  before they are used, and that sleeping calls are not made from
+	  non-sleeping contexts.  They can make bitbanged serial protocols
 	  slower.  The diagnostics help catch the type of setup errors
 	  that are most common when setting up new platforms or boards.
 
diff -ru a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig	2008-04-16 21:49:44.000000000 -0500
+++ b/drivers/hwmon/Kconfig	2008-04-25 22:15:07.000000000 -0500
@@ -295,7 +295,7 @@
 	  Computers sensor chips.
 
 	  This is a new merged driver for FSC sensor chips which is intended
-	  as a replacment for the fscpos, fscscy and fscher drivers and adds
+	  as a replacement for the fscpos, fscscy, and fscher drivers, and adds
 	  support for several other FCS sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
diff -ru a/drivers/input/Kconfig b/drivers/input/Kconfig
--- a/drivers/input/Kconfig	2008-04-16 21:49:44.000000000 -0500
+++ b/drivers/input/Kconfig	2008-04-25 21:45:54.000000000 -0500
@@ -143,7 +143,7 @@
 	---help---
 	  Say Y here if you want suspend key events to trigger a user
 	  requested suspend through APM. This is useful on embedded
-	  systems where such behviour is desired without userspace
+	  systems where such behaviour is desired without userspace
 	  interaction. If unsure, say N.
 
 	  To compile this driver as a module, choose M here: the
diff -ru a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
--- a/drivers/media/dvb/frontends/Kconfig	2008-04-25 21:26:29.000000000 -0500
+++ b/drivers/media/dvb/frontends/Kconfig	2008-04-25 22:34:37.000000000 -0500
@@ -373,7 +373,7 @@
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner DiB0070 from DiBcom.
-	  This device is only used inside a SiP called togther with a
+	  This device is only used inside a SiP called together with a
 	  demodulator for now.
 
 config DVB_TUNER_XC5000
@@ -382,7 +382,7 @@
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon tuner XC5000 from Xceive.
-	  This device is only used inside a SiP called togther with a
+	  This device is only used inside a SiP called together with a
 	  demodulator for now.
 
 config DVB_TUNER_ITD1000
diff -ru a/drivers/misc/Kconfig b/drivers/misc/Kconfig
--- a/drivers/misc/Kconfig	2008-04-25 21:26:30.000000000 -0500
+++ b/drivers/misc/Kconfig	2008-04-25 23:25:10.000000000 -0500
@@ -18,8 +18,8 @@
 	depends on AVR32 || ARCH_AT91
 	help
 	  This option enables device driver support for the PWM channels
-	  on certain Atmel prcoessors.  Pulse Width Modulation is used for
-	  purposes including software controlled power-efficent backlights
+	  on certain Atmel processors.  Pulse Width Modulation is used for
+	  purposes including software controlled power-efficient backlights
 	  on LCD displays, motor control, and waveform generation.
 
 config ATMEL_TCLIB
@@ -310,11 +310,11 @@
 	  If you are not sure, say Y here.
 
 config THINKPAD_ACPI_HOTKEY_POLL
-	bool "Suport NVRAM polling for hot keys"
+	bool "Support NVRAM polling for hot keys"
 	depends on THINKPAD_ACPI
 	default y
 	---help---
-	  Some thinkpad models benefit from NVRAM polling to detect a few of
+	  Some ThinkPad models benefit from NVRAM polling to detect a few of
 	  the hot key press events.  If you know your ThinkPad model does not
 	  need to do NVRAM polling to support any of the hot keys you use,
 	  unselecting this option will save about 1kB of memory.
@@ -333,7 +333,7 @@
 	tristate "Device driver for Atmel SSC peripheral"
 	depends on AVR32 || ARCH_AT91
 	---help---
-	  This option enables device driver support for Atmel Syncronized
+	  This option enables device driver support for Atmel Synchronized
 	  Serial Communication peripheral (SSC).
 
 	  The SSC peripheral supports a wide variety of serial frame based
diff -ru a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig	2008-04-16 21:49:44.000000000 -0500
+++ b/drivers/mmc/host/Kconfig	2008-04-25 21:35:27.000000000 -0500
@@ -123,7 +123,7 @@
 	select CRC7
 	select CRC_ITU_T
 	help
-	  Some systems accss MMC/SD cards using a SPI controller instead of
+	  Some systems access MMC/SD cards using a SPI controller instead of
 	  using a "native" MMC/SD controller.  This has a disadvantage of
 	  being relatively high overhead, but a compensating advantage of
 	  working on many systems without dedicated MMC/SD controllers.
diff -ru a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig	2008-04-25 21:26:32.000000000 -0500
+++ b/fs/Kconfig	2008-04-25 22:04:07.000000000 -0500
@@ -1850,7 +1850,7 @@
 	select CRYPTO_CBC
 	help
 	  Choose Y here to enable Secure RPC using the SPKM3 public key
-	  GSS-API mechansim (RFC 2025).
+	  GSS-API mechanism (RFC 2025).
 
 	  Secure RPC calls with SPKM3 require an auxiliary userspace
 	  daemon which may be found in the Linux nfs-utils package
diff -ru a/init/Kconfig b/init/Kconfig
--- a/init/Kconfig	2008-04-25 21:27:03.000000000 -0500
+++ b/init/Kconfig	2008-04-25 22:30:10.000000000 -0500
@@ -466,8 +466,8 @@
 	default n
 	depends on NAMESPACES && EXPERIMENTAL
 	help
-	  Suport process id namespaces.  This allows having multiple
-	  process with the same pid as long as they are in different
+	  Support process id namespaces.  This allows having multiple
+	  processes with the same pid as long as they are in different
 	  pid namespaces.  This is a building block of containers.
 
 	  Unless you want to work with an experimental feature
