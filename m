Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZAUU3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZAUU3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZAUU24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:28:56 -0500
Received: from mail.cyberdogtech.com ([64.22.125.39]:55480 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZAUU2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:28:54 -0500
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Matt LaPlante <kernel1@cyberdogtech.com>
Subject: [PATCH 1/2] Kconfig cleanup - Resubmits.
Date: Wed, 21 Jan 2009 14:20:14 -0600
Message-Id: <1232569214-11899-1-git-send-email-kernel1@cyberdogtech.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes were submitted and approved previously,
but never included in mainline.  

http://thread.gmane.org/gmane.linux.kernel/728409/focus=754708

Rebuilt against 2.6.29-rc2.

Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
---
 arch/arm/mach-omap1/Kconfig          |    2 +-
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
 drivers/gpio/Kconfig                 |    6 +++---
 drivers/input/Kconfig                |    2 +-
 drivers/leds/Kconfig                 |    6 +++---
 drivers/media/dvb/frontends/Kconfig  |    2 +-
 drivers/misc/Kconfig                 |    6 +++---
 drivers/serial/Kconfig               |    2 +-
 drivers/usb/serial/Kconfig           |    4 ++--
 fs/Kconfig                           |    2 +-
 init/Kconfig                         |    4 ++--
 net/Kconfig                          |    2 +-
 net/ipv6/Kconfig                     |   18 +++++++++---------
 net/mac80211/Kconfig                 |    2 +-
 net/netfilter/Kconfig                |    2 +-
 26 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 10a301e..4c81e70 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -98,7 +98,7 @@ config MACH_OMAP_PALMZ71
 	help
 	 Support for the Palm Zire71 PDA. To boot the kernel,
 	 you'll need a PalmOS compatible bootloader; check out
-	 http://hackndev.com/palm/z71 for more informations.
+	 http://hackndev.com/palm/z71 for more information.
 	 Say Y here if you have such a PDA, say N otherwise.
 
 config MACH_OMAP_PALMTT
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index a949c4f..2d30d37 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -747,7 +747,7 @@ config CACHELINE_ALIGNED_L1
 	default n if BF54x
 	depends on !BF531
 	help
-	  If enabled, cacheline_anligned data is linked
+	  If enabled, cacheline_aligned data is linked
 	  into L1 data memory. (less latency)
 
 config SYSCALL_TAB_L1
@@ -927,7 +927,7 @@ config MPU
 	  memory they do not own.  This comes at a performance penalty
 	  and is recommended only for debugging.
 
-comment "Asynchonous Memory Configuration"
+comment "Asynchronous Memory Configuration"
 
 menu "EBIU_AMGCTL Global Control"
 config C_AMCKEN
@@ -959,7 +959,7 @@ config C_B3PEN
 	default n
 
 choice
-	prompt"Enable Asynchonous Memory Banks"
+	prompt "Enable Asynchronous Memory Banks"
 	default C_AMBEN_ALL
 
 config C_AMBEN
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 3462245..7adac38 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -438,7 +438,7 @@ config ETRAX_SERIAL_PORT0_DMA1_IN
 	help
 	  Enables the DMA1 input channel for ser0 (ttyS0).
 	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiveing data.
+	  used when receiving data.
 	  Normally you want to use DMA, unless you use the DMA channel for
 	  something else.
 
@@ -565,7 +565,7 @@ config ETRAX_SERIAL_PORT2_DMA7_IN
 	help
 	  Enables the DMA7 input channel for ser2 (ttyS2).
 	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiveing data.
+	  used when receiving data.
 	  Normally you want to use DMA, unless you use the DMA channel for
 	  something else.
 
@@ -604,7 +604,7 @@ config ETRAX_SERIAL_PORT3_DMA3_IN
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
index 52c80c2..a007995 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -136,7 +136,7 @@ config MACH_JAZZ
 	help
 	 This a family of machines based on the MIPS R4030 chipset which was
 	 used by several vendors to build RISC/os and Windows NT workstations.
-	 Members include the Acer PICA, MIPS Magnum 4000, MIPS Millenium and
+	 Members include the Acer PICA, MIPS Magnum 4000, MIPS Millennium and
 	 Olivetti M700-10 workstations.
 
 config LASAT
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e39b73b..6c8bc0f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -342,7 +342,7 @@ config PHYP_DUMP
 	help
 	  Hypervisor-assisted dump is meant to be a kdump replacement
 	  offering robustness and speed not possible without system
-	  hypervisor assistence.
+	  hypervisor assistance.
 
 	  If unsure, say "N"
 
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 200b9cb..9a8bb53 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -298,7 +298,7 @@ config CPM
 config OF_RTC
 	bool
 	help
-	  Uses information from the OF or flattened device tree to instatiate
+	  Uses information from the OF or flattened device tree to instantiate
 	  platform devices for direct mapped RTC chips like the DS1742 or DS1743.
 
 source "arch/powerpc/sysdev/bestcomm/Kconfig"
diff --git a/arch/powerpc/sysdev/bestcomm/Kconfig b/arch/powerpc/sysdev/bestcomm/Kconfig
index 0b192a1..29e4270 100644
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
index f32a519..d22a762 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -595,10 +595,10 @@ config GUSA_RB
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
index 73f7fe8..b275305 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1095,7 +1095,7 @@ config NODES_SHIFT
 	depends on NEED_MULTIPLE_NODES
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
-	  system.  Increases memory reserved to accomodate various tables.
+	  system.  Increases memory reserved to accommodate various tables.
 
 config HAVE_ARCH_BOOTMEM_NODE
 	def_bool y
@@ -1273,7 +1273,7 @@ config MTRR_SANITIZER
 	  add writeback entries.
 
 	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
-	  The largest mtrr entry size for a continous block can be set with
+	  The largest mtrr entry size for a continuous block can be set with
 	  mtrr_chunk_size.
 
 	  If unsure, say Y.
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 503a908..83ec7b7 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -86,7 +86,7 @@ config ATA_SFF
 
 	  For users with exclusively modern controllers like AHCI,
 	  Silicon Image 3124, or Marvell 6440, you may choose to
-	  disable this uneeded SFF support.
+	  disable this unneeded SFF support.
 
 	  If unsure, say Y.
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3d25654..edb0253 100644
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
index 7427136..db87b6c 100644
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
@@ -144,7 +144,7 @@ config LEDS_CLEVO_MAIL
 	  	Positivo Mobile (Clevo M5x0V)
 
 	  If your model is not listed here you can try the "nodetect"
-	  module paramter.
+	  module parameter.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-clevo-mail.
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 0026956..baf808e 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -439,7 +439,7 @@ config DVB_TUNER_DIB0070
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner DiB0070 from DiBcom.
-	  This device is only used inside a SiP called togther with a
+	  This device is only used inside a SiP called together with a
 	  demodulator for now.
 
 comment "SEC control devices for DVB-S"
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 419c378..415d743 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -18,8 +18,8 @@ config ATMEL_PWM
 	depends on AVR32 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9
 	help
 	  This option enables device driver support for the PWM channels
-	  on certain Atmel prcoessors.  Pulse Width Modulation is used for
-	  purposes including software controlled power-efficent backlights
+	  on certain Atmel processors.  Pulse Width Modulation is used for
+	  purposes including software controlled power-efficient backlights
 	  on LCD displays, motor control, and waveform generation.
 
 config ATMEL_TCLIB
@@ -150,7 +150,7 @@ config ATMEL_SSC
 	tristate "Device driver for Atmel SSC peripheral"
 	depends on AVR32 || ARCH_AT91
 	---help---
-	  This option enables device driver support for Atmel Syncronized
+	  This option enables device driver support for Atmel Synchronized
 	  Serial Communication peripheral (SSC).
 
 	  The SSC peripheral supports a wide variety of serial frame based
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 3e525e3..7ac77ba 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1374,7 +1374,7 @@ config SERIAL_BFIN_SPORT
 	depends on BLACKFIN && EXPERIMENTAL
 	select SERIAL_CORE
 	help
-	  Enble support SPORT emulate UART on Blackfin series.
+	  Enable SPORT emulate UART on Blackfin series.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bfin_sport_uart.
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index b361f05..4b3a9cd 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -509,8 +509,8 @@ config USB_SERIAL_SIERRAWIRELESS
 	help
 	  Say M here if you want to use Sierra Wireless devices.
 
-	  Many deviecs have a feature known as TRU-Install, for those devices
-	  to work properly the USB Storage Sierra feature must be enabled.
+	  Many devices have a feature known as TRU-Install. For those devices
+	  to work properly, the USB Storage Sierra feature must be enabled.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sierra.
diff --git a/fs/Kconfig b/fs/Kconfig
index 51307b0..b920ad4 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1453,7 +1453,7 @@ config RPCSEC_GSS_SPKM3
 	select CRYPTO_CBC
 	help
 	  Choose Y here to enable Secure RPC using the SPKM3 public key
-	  GSS-API mechansim (RFC 2025).
+	  GSS-API mechanism (RFC 2025).
 
 	  Secure RPC calls with SPKM3 require an auxiliary userspace
 	  daemon which may be found in the Linux nfs-utils package
diff --git a/init/Kconfig b/init/Kconfig
index 2af8382..8249715 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -535,7 +535,7 @@ config PID_NS
 	depends on NAMESPACES && EXPERIMENTAL
 	help
 	  Support process id namespaces.  This allows having multiple
-	  process with the same pid as long as they are in different
+	  processes with the same pid as long as they are in different
 	  pid namespaces.  This is a building block of containers.
 
 	  Unless you want to work with an experimental feature
@@ -694,7 +694,7 @@ config COMPAT_BRK
 	  Randomizing heap placement makes heap exploits harder, but it
 	  also breaks ancient binaries (including anything libc5 based).
 	  This option changes the bootup default to heap randomization
-	  disabled, and can be overriden runtime by setting
+	  disabled, and can be overridden at runtime by setting
 	  /proc/sys/kernel/randomize_va_space to 2.
 
 	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
diff --git a/net/Kconfig b/net/Kconfig
index bf27760..612b447 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -150,7 +150,7 @@ config NETFILTER_ADVANCED
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
index 60c1616..f3d9ae3 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -33,7 +33,7 @@ choice
 	---help---
 	  This option selects the default rate control algorithm
 	  mac80211 will use. Note that this default can still be
-	  overriden through the ieee80211_default_rc_algo module
+	  overridden through the ieee80211_default_rc_algo module
 	  parameter if different algorithms are available.
 
 config MAC80211_RC_DEFAULT_PID
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c2bac9c..fe00572 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -52,7 +52,7 @@ config NF_CT_ACCT
 
 	  Please note that currently this option only sets a default state.
 	  You may change it at boot time with nf_conntrack.acct=0/1 kernel
-	  paramater or by loading the nf_conntrack module with acct=0/1.
+	  parameter or by loading the nf_conntrack module with acct=0/1.
 
 	  You may also disable/enable it on a running system with:
 	   sysctl net.netfilter.nf_conntrack_acct=0/1
-- 
1.5.6.3

