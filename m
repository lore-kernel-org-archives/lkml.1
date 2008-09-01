Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYIAD3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYIAD3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 23:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYIAD3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 23:29:30 -0400
Received: from mail.cyberdogtech.com ([64.22.125.39]:55846 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIAD32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 23:29:28 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Matt LaPlante <kernel1@cyberdogtech.com>
Subject: [PATCH] Kconfig cleanup including spelling and grammar touchups.
Date: Sun, 31 Aug 2008 22:28:22 -0500
Message-Id: <1220239702-15688-1-git-send-email-kernel1@cyberdogtech.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
---
 arch/arm/mach-omap1/Kconfig          |    4 ++--
 arch/arm/mach-pxa/Kconfig            |    2 +-
 arch/blackfin/Kconfig                |    6 +++---
 arch/cris/Kconfig                    |    6 +++---
 arch/cris/arch-v32/Kconfig           |    2 +-
 arch/cris/arch-v32/drivers/Kconfig   |    2 +-
 arch/cris/arch-v32/mach-fs/Kconfig   |    2 +-
 arch/mips/Kconfig                    |    2 +-
 arch/powerpc/Kconfig                 |    2 +-
 arch/powerpc/platforms/Kconfig       |    2 +-
 arch/powerpc/sysdev/bestcomm/Kconfig |    4 ++--
 arch/sh/Kconfig                      |    4 ++--
 arch/x86/Kconfig                     |    4 ++--
 drivers/ata/Kconfig                  |    2 +-
 drivers/base/Kconfig                 |    2 +-
 drivers/gpio/Kconfig                 |    6 +++---
 drivers/hwmon/Kconfig                |    2 +-
 drivers/i2c/chips/Kconfig            |    4 ++--
 drivers/input/Kconfig                |    2 +-
 drivers/leds/Kconfig                 |    6 +++---
 drivers/media/dvb/frontends/Kconfig  |    2 +-
 drivers/misc/Kconfig                 |    8 ++++----
 drivers/mmc/host/Kconfig             |    2 +-
 drivers/serial/Kconfig               |    2 +-
 drivers/usb/core/Kconfig             |    2 +-
 drivers/usb/serial/Kconfig           |    4 ++--
 fs/Kconfig                           |    2 +-
 init/Kconfig                         |    6 +++++-
 net/Kconfig                          |    2 +-
 net/ipv6/Kconfig                     |   18 +++++++++---------
 net/mac80211/Kconfig                 |    2 +-
 net/netfilter/Kconfig                |    2 +-
 32 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 79f0b1f..c259ced 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -93,9 +93,9 @@ config MACH_OMAP_PALMZ71
 	bool "Palm Zire71"
 	depends on ARCH_OMAP1 && ARCH_OMAP15XX
 	help
-	 Support for the Palm Zire71 PDA. To boot the kernel,
+	 Support for the Palm Zire71 PDA. To boot the kernel
 	 you'll need a PalmOS compatible bootloader; check out
-	 http://hackndev.com/palm/z71 for more informations.
+	 http://hackndev.com/palm/z71 for more information.
 	 Say Y here if you have such a PDA, say N otherwise.
 
 config MACH_OMAP_PALMTT
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index e8ee7ec..1faf87c 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -27,7 +27,7 @@ config ARCH_GUMSTIX
 	bool "Gumstix XScale boards"
 	help
 	  Say Y here if you intend to run this kernel on a
-	  Gumstix Full Function Minature Computer.
+	  Gumstix Full Function Miniature Computer.
 
 config MACH_GUMSTIX_F
 	bool "Basix, Connex, ws-200ax, ws-400ax systems"
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 4154ff1..4953f7b 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -603,7 +603,7 @@ config CACHELINE_ALIGNED_L1
 	default n if BF54x
 	depends on !BF531
 	help
-	  If enabled, cacheline_anligned data is linked
+	  If enabled, cacheline_aligned data is linked
 	  into L1 data memory. (less latency)
 
 config SYSCALL_TAB_L1
@@ -763,7 +763,7 @@ config MPU
 	  memory they do not own.  This comes at a performance penalty
 	  and is recommended only for debugging.
 
-comment "Asynchonous Memory Configuration"
+comment "Asynchronous Memory Configuration"
 
 menu "EBIU_AMGCTL Global Control"
 config C_AMCKEN
@@ -795,7 +795,7 @@ config C_B3PEN
 	default n
 
 choice
-	prompt"Enable Asynchonous Memory Banks"
+	prompt"Enable Asynchronous Memory Banks"
 	default C_AMBEN_ALL
 
 config C_AMBEN
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 9389d38..9713196 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -436,7 +436,7 @@ config ETRAX_SERIAL_PORT0_DMA1_IN
 	help
 	  Enables the DMA1 input channel for ser0 (ttyS0).
 	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiveing data.
+	  used when receiving data.
 	  Normally you want to use DMA, unless you use the DMA channel for
 	  something else.
 
@@ -563,7 +563,7 @@ config ETRAX_SERIAL_PORT2_DMA7_IN
 	help
 	  Enables the DMA7 input channel for ser2 (ttyS2).
 	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiveing data.
+	  used when receiving data.
 	  Normally you want to use DMA, unless you use the DMA channel for
 	  something else.
 
@@ -602,7 +602,7 @@ config ETRAX_SERIAL_PORT3_DMA3_IN
 	help
 	  Enables the DMA3 input channel for ser3 (ttyS3).
 	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiveing data.
+	  used when receiving data.
 	  Normally you want to use DMA, unless you use the DMA channel for
 	  something else.
 
diff --git a/arch/cris/arch-v32/Kconfig b/arch/cris/arch-v32/Kconfig
index 005ed2b..21bbd93 100644
--- a/arch/cris/arch-v32/Kconfig
+++ b/arch/cris/arch-v32/Kconfig
@@ -28,7 +28,7 @@ config	ETRAX_NBR_LED_GRP_ONE
 	help
 	  Select this if you want one Ethernet LED group. This LED group
 	  can be used for one or more Ethernet interfaces. However, it is
-	  recomended that each Ethernet interface use a dedicated LED group.
+	  recommended that each Ethernet interface use a dedicated LED group.
 
 config	ETRAX_NBR_LED_GRP_TWO
 	bool "Use two LED groups"
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 7a64fce..b9e328e 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -342,7 +342,7 @@ config ETRAX_SERIAL_PORT4_DMA9_IN
 	help
 	  Enables the DMA9 input channel for ser4 (ttyS4).
 	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiveing data.
+	  used when receiving data.
 	  Normally you want to use DMA, unless you use the DMA channel for
 	  something else.
 
diff --git a/arch/cris/arch-v32/mach-fs/Kconfig b/arch/cris/arch-v32/mach-fs/Kconfig
index f6d7447..774de82 100644
--- a/arch/cris/arch-v32/mach-fs/Kconfig
+++ b/arch/cris/arch-v32/mach-fs/Kconfig
@@ -59,7 +59,7 @@ config ETRAX_SDRAM_GRP1_CONFIG
 	depends on ETRAX_ARCH_V32
 	default "0"
 	help
-	  SDRAM configuration for group 1. The defult value is 0
+	  SDRAM configuration for group 1. The default value is 0
 	  because group 1 is not used in the default configuration,
 	  described in the help for SDRAM_GRP0_CONFIG.
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 4da736e..86688ae 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -135,7 +135,7 @@ config MACH_JAZZ
 	help
 	 This a family of machines based on the MIPS R4030 chipset which was
 	 used by several vendors to build RISC/os and Windows NT workstations.
-	 Members include the Acer PICA, MIPS Magnum 4000, MIPS Millenium and
+	 Members include the Acer PICA, MIPS Magnum 4000, MIPS Millennium and
 	 Olivetti M700-10 workstations.
 
 config LASAT
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 587da5e..02c705d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -335,7 +335,7 @@ config PHYP_DUMP
 	help
 	  Hypervisor-assisted dump is meant to be a kdump replacement
 	  offering robustness and speed not possible without system
-	  hypervisor assistence.
+	  hypervisor assistance.
 
 	  If unsure, say "N"
 
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 4c900ef..c5a1c0f 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -288,7 +288,7 @@ config CPM
 config OF_RTC
 	bool
 	help
-	  Uses information from the OF or flattened device tree to instatiate
+	  Uses information from the OF or flattened device tree to instantiate
 	  platform devices for direct mapped RTC chips like the DS1742 or DS1743.
 
 source "arch/powerpc/sysdev/bestcomm/Kconfig"
diff --git a/arch/powerpc/sysdev/bestcomm/Kconfig b/arch/powerpc/sysdev/bestcomm/Kconfig
index 57cc565..0254862 100644
--- a/arch/powerpc/sysdev/bestcomm/Kconfig
+++ b/arch/powerpc/sysdev/bestcomm/Kconfig
@@ -9,8 +9,8 @@ config PPC_BESTCOMM
 	select PPC_LIB_RHEAP
 	help
 	  BestComm is the name of the communication coprocessor found
-	  on the Freescale MPC5200 family of processor. It's usage is
-	  optionnal for some drivers (like ATA), but required for
+	  on the Freescale MPC5200 family of processor.  Its usage is
+	  optional for some drivers (like ATA), but required for
 	  others (like FEC).
 
 	  If you want to use drivers that require DMA operations,
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5131d50..e6d796a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -562,10 +562,10 @@ config GUSA_RB
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
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..d8266c7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1000,7 +1000,7 @@ config NODES_SHIFT
 	depends on NEED_MULTIPLE_NODES
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
-	  system.  Increases memory reserved to accomodate various tables.
+	  system.  Increases memory reserved to accommodate various tables.
 
 config HAVE_ARCH_BOOTMEM_NODE
 	def_bool y
@@ -1128,7 +1128,7 @@ config MTRR_SANITIZER
 	  add writeback entries.
 
 	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
-	  The largest mtrr entry size for a continous block can be set with
+	  The largest mtrr entry size for a continuous block can be set with
 	  mtrr_chunk_size.
 
 	  If unsure, say N.
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ae84949..062e469 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -87,7 +87,7 @@ config ATA_SFF
 
 	  For users with exclusively modern controllers like AHCI,
 	  Silicon Image 3124, or Marvell 6440, you may choose to
-	  disable this uneeded SFF support.
+	  disable this unneeded SFF support.
 
 	  If unsure, say Y.
 
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 6318f6b..b1f3738 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -54,7 +54,7 @@ config FIRMWARE_IN_KERNEL
 	  such firmware, and do not wish to use an initrd.
 
 	  This single option controls the inclusion of firmware for
-	  every driver which usees request_firmare() and ships its
+	  every driver which usees request_firmware() and ships its
 	  firmware in the kernel source tree, to avoid a proliferation
 	  of 'Include firmware for xxx device' options.
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index dbd42d6..4819545 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -42,9 +42,9 @@ config DEBUG_GPIO
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
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index d402e8d..7616f32 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -321,7 +321,7 @@ config SENSORS_FSCHMD
 	  Computers sensor chips.
 
 	  This is a new merged driver for FSC sensor chips which is intended
-	  as a replacment for the fscpos, fscscy and fscher drivers and adds
+	  as a replacement for the fscpos, fscscy, and fscher drivers, and adds
 	  support for several other FCS sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index a95cb94..bf92f3e 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -167,8 +167,8 @@ config MENELAUS
 	depends on I2C=y && ARCH_OMAP24XX
 	help
 	  If you say yes here you get support for the Texas Instruments
-	  TWL92330/Menelaus Power Management chip. This include voltage
-	  regulators, Dual slot memory card tranceivers, real-time clock
+	  TWL92330/Menelaus Power Management chip. This includes voltage
+	  regulators, dual slot memory card transceivers, real-time clock,
 	  and other features that are often used in portable devices like
 	  cell phones and PDAs.
 
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 5f9d860..cd50c00 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -143,7 +143,7 @@ config INPUT_APMPOWER
 	---help---
 	  Say Y here if you want suspend key events to trigger a user
 	  requested suspend through APM. This is useful on embedded
-	  systems where such behviour is desired without userspace
+	  systems where such behaviour is desired without userspace
 	  interaction. If unsure, say N.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9556262..b2eedfa 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -100,7 +100,7 @@ config LEDS_HP6XX
 	tristate "LED Support for the HP Jornada 6xx"
 	depends on LEDS_CLASS && SH_HP6XX
 	help
-	  This option enables led support for the handheld
+	  This option enables LED support for the handheld
 	  HP Jornada 620/660/680/690.
 
 config LEDS_PCA9532
@@ -108,7 +108,7 @@ config LEDS_PCA9532
 	depends on LEDS_CLASS && I2C && INPUT && EXPERIMENTAL
 	help
 	  This option enables support for NXP pca9532
-	  led controller. It is generally only usefull
+	  LED controller. It is generally only useful
 	  as a platform driver
 
 config LEDS_GPIO
@@ -150,7 +150,7 @@ config LEDS_CLEVO_MAIL
 	  	Positivo Mobile (Clevo M5x0V)
 
 	  If your model is not listed here you can try the "nodetect"
-	  module paramter.
+	  module parameter.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-clevo-mail.
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 7dbb4a2..9b1f774 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -358,7 +358,7 @@ config DVB_TUNER_DIB0070
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner DiB0070 from DiBcom.
-	  This device is only used inside a SiP called togther with a
+	  This device is only used inside a SiP called together with a
 	  demodulator for now.
 
 comment "SEC control devices for DVB-S"
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a726f3b..5fe2a35 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -18,8 +18,8 @@ config ATMEL_PWM
 	depends on AVR32 || ARCH_AT91
 	help
 	  This option enables device driver support for the PWM channels
-	  on certain Atmel prcoessors.  Pulse Width Modulation is used for
-	  purposes including software controlled power-efficent backlights
+	  on certain Atmel processors.  Pulse Width Modulation is used for
+	  purposes including software controlled power-efficient backlights
 	  on LCD displays, motor control, and waveform generation.
 
 config ATMEL_TCLIB
@@ -364,7 +364,7 @@ config THINKPAD_ACPI_HOTKEY_POLL
 	depends on THINKPAD_ACPI
 	default y
 	---help---
-	  Some thinkpad models benefit from NVRAM polling to detect a few of
+	  Some ThinkPad models benefit from NVRAM polling to detect a few of
 	  the hot key press events.  If you know your ThinkPad model does not
 	  need to do NVRAM polling to support any of the hot keys you use,
 	  unselecting this option will save about 1kB of memory.
@@ -383,7 +383,7 @@ config ATMEL_SSC
 	tristate "Device driver for Atmel SSC peripheral"
 	depends on AVR32 || ARCH_AT91
 	---help---
-	  This option enables device driver support for Atmel Syncronized
+	  This option enables device driver support for Atmel Synchronized
 	  Serial Communication peripheral (SSC).
 
 	  The SSC peripheral supports a wide variety of serial frame based
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ea8d7a3..7b8ad12 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -146,7 +146,7 @@ config MMC_SPI
 	select CRC7
 	select CRC_ITU_T
 	help
-	  Some systems accss MMC/SD cards using a SPI controller instead of
+	  Some systems access MMC/SD cards using a SPI controller instead of
 	  using a "native" MMC/SD controller.  This has a disadvantage of
 	  being relatively high overhead, but a compensating advantage of
 	  working on many systems without dedicated MMC/SD controllers.
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 77cb342..2aaeb71 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1383,7 +1383,7 @@ config SERIAL_BFIN_SPORT
 	depends on BLACKFIN && EXPERIMENTAL
 	select SERIAL_CORE
 	help
-	  Enble support SPORT emulate UART on Blackfin series.
+	  Enable SPORT emulate UART on Blackfin series.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bfin_sport_uart.
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index cc9f397..e1759d1 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -134,5 +134,5 @@ config USB_OTG_BLACKLIST_HUB
 	  If you say Y here, then Linux will refuse to enumerate
 	  external hubs.  OTG hosts are allowed to reduce hardware
 	  and software costs by not supporting external hubs.  So
-	  are "Emedded Hosts" that don't offer OTG support.
+	  are "Embedded Hosts" that don't offer OTG support.
 
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 70338f4..4f51c9e 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -501,8 +501,8 @@ config USB_SERIAL_SIERRAWIRELESS
 	help
 	  Say M here if you want to use Sierra Wireless devices.
 
-	  Many deviecs have a feature known as TRU-Install, for those devices
-	  to work properly the USB Storage Sierra feature must be enabled.
+	  Many devices have a feature known as TRU-Install. For those devices
+	  to work properly, the USB Storage Sierra feature must be enabled.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sierra.
diff --git a/fs/Kconfig b/fs/Kconfig
index abccb5d..97ef13d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1795,7 +1795,7 @@ config RPCSEC_GSS_SPKM3
 	select CRYPTO_CBC
 	help
 	  Choose Y here to enable Secure RPC using the SPKM3 public key
-	  GSS-API mechansim (RFC 2025).
+	  GSS-API mechanism (RFC 2025).
 
 	  Secure RPC calls with SPKM3 require an auxiliary userspace
 	  daemon which may be found in the Linux nfs-utils package
diff --git a/init/Kconfig b/init/Kconfig
index c11da38..0cd1edf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -487,7 +487,11 @@ config PID_NS
 	depends on NAMESPACES && EXPERIMENTAL
 	help
 	  Support process id namespaces.  This allows having multiple
+<<<<<<< HEAD:init/Kconfig
 	  process with the same pid as long as they are in different
+=======
+	  processes with the same pid as long as they are in different
+>>>>>>> 00c0d3c... Fix misc small typos/grammar in Kconfigs.:init/Kconfig
 	  pid namespaces.  This is a building block of containers.
 
 	  Unless you want to work with an experimental feature
@@ -639,7 +643,7 @@ config COMPAT_BRK
 	  Randomizing heap placement makes heap exploits harder, but it
 	  also breaks ancient binaries (including anything libc5 based).
 	  This option changes the bootup default to heap randomization
-	  disabled, and can be overriden runtime by setting
+	  disabled, and can be overridden at runtime by setting
 	  /proc/sys/kernel/randomize_va_space to 2.
 
 	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
diff --git a/net/Kconfig b/net/Kconfig
index 7612cc8..3700443 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -147,7 +147,7 @@ config NETFILTER_ADVANCED
 	default y
 	help
 	  If you say Y here you can select between all the netfilter modules.
-	  If you say N the more ununsual ones will not be shown and the
+	  If you say N the more unusual ones will not be shown and the
 	  basic ones needed by most people will default to 'M'.
 
 	  If unsure, say Y.
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index ec99215..ca8cb32 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -22,17 +22,17 @@ menuconfig IPV6
 if IPV6
 
 config IPV6_PRIVACY
-	bool "IPv6: Privacy Extensions support"
+	bool "IPv6: Privacy Extensions (RFC 3041) support"
 	---help---
 	  Privacy Extensions for Stateless Address Autoconfiguration in IPv6
-	  support.  With this option, additional periodically-alter 
-	  pseudo-random global-scope unicast address(es) will assigned to
+	  support.  With this option, additional periodically-altered
+	  pseudo-random global-scope unicast address(es) will be assigned to
 	  your interface(s).
 	
-	  We use our standard pseudo random algorithm to generate randomized
-	  interface identifier, instead of one described in RFC 3041.
+	  We use our standard pseudo-random algorithm to generate the
+          randomized interface identifier, instead of one described in RFC 3041.
 
-	  By default, kernel do not generate temporary addresses.
+	  By default the kernel does not generate temporary addresses.
 	  To use temporary addresses, do
 	
 	        echo 2 >/proc/sys/net/ipv6/conf/all/use_tempaddr 
@@ -43,9 +43,9 @@ config IPV6_ROUTER_PREF
 	bool "IPv6: Router Preference (RFC 4191) support"
 	---help---
 	  Router Preference is an optional extension to the Router
-	  Advertisement message to improve the ability of hosts
-	  to pick more appropriate router, especially when the hosts
-	  is placed in a multi-homed network.
+	  Advertisement message which improves the ability of hosts
+	  to pick an appropriate router, especially when the hosts
+	  are placed in a multi-homed network.
 
 	  If unsure, say N.
 
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 80d6933..0375b17 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -28,7 +28,7 @@ choice
 	---help---
 	  This option selects the default rate control algorithm
 	  mac80211 will use. Note that this default can still be
-	  overriden through the ieee80211_default_rc_algo module
+	  overridden through the ieee80211_default_rc_algo module
 	  parameter if different algorithms are available.
 
 config MAC80211_RC_DEFAULT_PID
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ee898e7..784f3d9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -51,7 +51,7 @@ config NF_CT_ACCT
 
 	  Please note that currently this option only sets a default state.
 	  You may change it at boot time with nf_conntrack.acct=0/1 kernel
-	  paramater or by loading the nf_conntrack module with acct=0/1.
+	  parameter or by loading the nf_conntrack module with acct=0/1.
 
 	  You may also disable/enable it on a running system with:
 	   sysctl net.netfilter.nf_conntrack_acct=0/1
-- 
1.5.4.3

