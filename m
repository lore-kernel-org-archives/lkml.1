Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYGSNq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYGSNq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 09:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYGSNqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 09:46:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:56210 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYGSNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 09:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=F5EH+Hxi6jcMhS8NQJPqKeQxQ06WCRjbsOLc+U3V6ujKIHWd5O4zKgCsbefFLv/iRW
         TDr6fdIxyyC7EZQ31gct0Av5fyAIkpUQ4rNIsJPKkmSWDgb7ffxQqiGyu7tncBVw56u7
         0Rrzs+5iyFBp/ud7/+MHLO1UcSIF6riHxcs28=
Message-ID: <386072610807190645h7809e700ub0e319e7d7d4b83d@mail.gmail.com>
Date: Sat, 19 Jul 2008 21:45:54 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT PULL] Blackfin arch and serial driver updates for 2.6.27 merge window
Cc: "Linux Kernel List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: ca938b4b93371788
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                             |  100 ++-
 arch/blackfin/Kconfig.debug                       |    7 -
 arch/blackfin/Makefile                            |    5 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |  187 ++++-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |  279 ++----
 arch/blackfin/configs/BF533-STAMP_defconfig       |  340 +++----
 arch/blackfin/configs/BF537-STAMP_defconfig       |  337 +++----
 arch/blackfin/configs/BF548-EZKIT_defconfig       |   63 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |  273 ++----
 arch/blackfin/configs/CM-BF527_defconfig          | 1185 +++++++++++++++++++++
 arch/blackfin/configs/CM-BF533_defconfig          |   12 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |   14 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |   16 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    8 +-
 arch/blackfin/configs/CM-BF561_defconfig          |   12 +-
 arch/blackfin/configs/PNAV-10_defconfig           |    2 +-
 arch/blackfin/kernel/Makefile                     |    1 -
 arch/blackfin/kernel/bfin_dma_5xx.c               |   26 +
 arch/blackfin/kernel/bfin_gpio.c                  |  118 ++-
 arch/blackfin/kernel/cplb-nompu/cplbhdlr.S        |    2 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c        |    6 +-
 arch/blackfin/kernel/dualcore_test.c              |   49 -
 arch/blackfin/kernel/entry.S                      |    5 +
 arch/blackfin/kernel/module.c                     |   74 +-
 arch/blackfin/kernel/ptrace.c                     |   28 +
 arch/blackfin/kernel/setup.c                      |   24 +-
 arch/blackfin/kernel/traps.c                      |  296 +++++-
 arch/blackfin/kernel/vmlinux.lds.S                |   40 +-
 arch/blackfin/mach-bf527/boards/Kconfig           |    5 +
 arch/blackfin/mach-bf527/boards/Makefile          |    1 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c        | 1011 ++++++++++++++++++
 arch/blackfin/mach-bf527/head.S                   |   12 +-
 arch/blackfin/mach-bf533/head.S                   |   12 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |   88 ++-
 arch/blackfin/mach-bf537/head.S                   |   12 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |   44 +
 arch/blackfin/mach-bf548/head.S                   |    6 +-
 arch/blackfin/mach-bf561/head.S                   |    6 -
 arch/blackfin/mach-common/arch_checks.c           |    6 -
 arch/blackfin/mach-common/dpmc_modes.S            |  607 ++++++++++-
 arch/blackfin/mach-common/ints-priority.c         |    4 +
 arch/blackfin/mach-common/pm.c                    |  225 ++++-
 arch/blackfin/mm/blackfin_sram.c                  |  543 +++++++---
 arch/blackfin/mm/blackfin_sram.h                  |    4 +-
 arch/blackfin/mm/init.c                           |   12 +-
 drivers/serial/bfin_5xx.c                         |   60 +-
 include/asm-blackfin/bfin-global.h                |    8 +-
 include/asm-blackfin/dma.h                        |    8 +
 include/asm-blackfin/dpmc.h                       |   82 +-
 include/asm-blackfin/elf.h                        |    2 +
 include/asm-blackfin/gpio.h                       |   19 +-
 include/asm-blackfin/mach-bf527/anomaly.h         |    2 +
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |    3 -
 include/asm-blackfin/mach-bf527/bfin_sir.h        |   21 +-
 include/asm-blackfin/mach-bf527/defBF527.h        |    1 +
 include/asm-blackfin/mach-bf527/mem_init.h        |   27 -
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |    2 -
 include/asm-blackfin/mach-bf533/bfin_sir.h        |   13 +-
 include/asm-blackfin/mach-bf533/mem_init.h        |   27 -
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |    3 -
 include/asm-blackfin/mach-bf537/bfin_sir.h        |   21 +-
 include/asm-blackfin/mach-bf537/defBF537.h        |    1 +
 include/asm-blackfin/mach-bf537/mem_init.h        |   27 -
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    3 -
 include/asm-blackfin/mach-bf548/bfin_sir.h        |   37 +-
 include/asm-blackfin/mach-bf548/gpio.h            |    8 +
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |    2 -
 include/asm-blackfin/mach-bf561/bfin_sir.h        |   13 +-
 include/asm-blackfin/mach-bf561/mem_init.h        |   27 -
 include/asm-blackfin/module.h                     |    5 +-
 include/asm-blackfin/processor.h                  |   21 +-
 71 files changed, 4998 insertions(+), 1552 deletions(-)
 create mode 100644 arch/blackfin/configs/CM-BF527_defconfig
 delete mode 100644 arch/blackfin/kernel/dualcore_test.c
 create mode 100644 arch/blackfin/mach-bf527/boards/cm_bf527.c

Bryan Wu (1):
      Blackfin arch: add TXDWA definition to enable new feature

Graf Yang (1):
      Blackfin arch: Add return value check in bfin_sir_probe(), remove SSYNC().

Jie Zhang (1):
      Blackfin arch: Allow ptrace to peek and poke application data in
L1 data SRAM.

Michael Hennerich (9):
      Blackfin arch: Fix Bug - GPIO interrupts not disabled; edge
sensitive interrupt hang system.
      Blackfin arch: Fix bug - Kernel does not boot if re-program clocks
      Blackfin arch: Remove redundant kernel option
      Blackfin arch: Fix BUG - JUMP error in kernel (relocation
truncated to fit: R_pcrel12_jump_s)
      Blackfin arch: Functional power management support
      Blackfin arch: Add ANOMALY_05000368 workaround
      Blackfin arch: fix bug - detect 0.1 silicon revision BF527-EZKIT
as 0.0 version
      Blackfin arch: Add ISP1760 board resources to BF548-EZKIT
      Blackfin arch: Apply Bluetechnix CM-BF527 board support patch

Mike Frysinger (9):
      Blackfin arch: use the generic platform nand driver to support
nand flash on bf53x board which do not have on-chip nand flash
controller
      Blackfin arch: Fix bug - do not overflow the buffer given to us
which tends to happen when CONFIG_L1_MAX_PIECE is increased past its
default
      Blackfin arch: use the symbolic IRQ define rather than the backend number
      Blackfin arch: set CROSS_COMPILE in our arch Makefile so it gets
used by default
      Blackfin arch: use local labels and ENDPROC() markings
      Blackfin arch: add missing IORESOURCE_MEM flags to UART3
      Blackfin Serial Driver: use __initdata for data, not __init
      Blackfin Serial Driver: trim trailing whitespace -- no functional changes
      Blackfin Serial Driver: move common variables out of serial
headers and into the serial driver

Robin Getz (2):
      Blackfin arch: Remove useless config option.
      Blackfin arch: Add unwinding for stack info, and a little more
detail on trace buffer

Sonic Zhang (4):
      Blackfin arch: update board defconfigs
      Blackfin arch:  change L1 malloc to base on slab cache and lists.
      Blackfin arch:  Extend sram malloc to handle L2 SRAM.
      Blackfin Serial Driver: Fix bug - should suspend/resume/remove
all uart ports.

Yi Li (1):
      Blackfin arch: Do not need this dualcore test module in kernel.

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b87634e..efa77f3 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -234,7 +234,7 @@ config MEM_MT48LC16M16A2TG_75
 	bool
 	depends on (BFIN533_EZKIT || BFIN561_EZKIT \
 		|| BFIN533_BLUETECHNIX_CM || BFIN537_BLUETECHNIX_CM \
-		|| H8606_HVSISTEMAS)
+		|| H8606_HVSISTEMAS || BFIN527_BLUETECHNIX_CM)
 	default y

 config MEM_MT48LC32M8A2_75
@@ -310,25 +310,6 @@ config BFIN_KERNEL_CLOCK
 	  are also not changed, and the Bootloader does 100% of the hardware
 	  configuration.

-config MEM_SIZE
-	int "SDRAM Memory Size in MBytes"
-	depends on BFIN_KERNEL_CLOCK
-	default 64
-
-config MEM_ADD_WIDTH
-	int "Memory Address Width"
-	depends on BFIN_KERNEL_CLOCK
-	depends on (!BF54x)
-	range 8 11
-	default  9 if BFIN533_EZKIT
-	default  9 if BFIN561_EZKIT
-	default  9 if H8606_HVSISTEMAS
-	default 10 if BFIN527_EZKIT
-	default 10 if BFIN537_STAMP
-	default 11 if BFIN533_STAMP
-	default 10 if PNAV10
-	default 10 if BFIN532_IP0X
-
 config PLL_BYPASS
 	bool "Bypass PLL"
 	depends on BFIN_KERNEL_CLOCK
@@ -349,8 +330,7 @@ config VCO_MULT
 	default "45" if BFIN533_STAMP
 	default "20" if (BFIN537_STAMP || BFIN527_EZKIT || BFIN548_EZKIT ||
BFIN548_BLUETECHNIX_CM)
 	default "22" if BFIN533_BLUETECHNIX_CM
-	default "20" if BFIN537_BLUETECHNIX_CM
-	default "20" if BFIN561_BLUETECHNIX_CM
+	default "20" if (BFIN537_BLUETECHNIX_CM || BFIN527_BLUETECHNIX_CM ||
BFIN561_BLUETECHNIX_CM)
 	default "20" if BFIN561_EZKIT
 	default "16" if H8606_HVSISTEMAS
 	help
@@ -390,7 +370,7 @@ config SCLK_DIV

 config MAX_MEM_SIZE
 	int "Max SDRAM Memory Size in MBytes"
-	depends on !BFIN_KERNEL_CLOCK && !MPU
+	depends on !MPU
 	default 512
 	help
 	  This is the max memory size that the kernel will create CPLB
@@ -748,14 +728,6 @@ config BFIN_WT

 endchoice

-config L1_MAX_PIECE
-	int "Set the max L1 SRAM pieces"
-	default 16
-	help
-	  Set the max memory pieces for the L1 SRAM allocation algorithm.
-	  Min value is 16. Max value is 1024.
-
-
 config MPU
 	bool "Enable the memory protection unit (EXPERIMENTAL)"
 	default n
@@ -899,7 +871,7 @@ config ARCH_SUSPEND_POSSIBLE
 	depends on !SMP

 choice
-	prompt "Default Power Saving Mode"
+	prompt "Standby Power Saving Mode"
 	depends on PM
 	default PM_BFIN_SLEEP_DEEPER
 config  PM_BFIN_SLEEP_DEEPER
@@ -918,6 +890,8 @@ config  PM_BFIN_SLEEP_DEEPER
 	  normal during Sleep Deeper, due to the reduced SCLK frequency.
 	  When in the sleep mode, system DMA access to L1 memory is not supported.

+	  If unsure, select "Sleep Deeper".
+
 config  PM_BFIN_SLEEP
 	bool "Sleep"
 	help
@@ -925,15 +899,17 @@ config  PM_BFIN_SLEEP
 	  dissipation by disabling the clock to the processor core (CCLK).
 	  The PLL and system clock (SCLK), however, continue to operate in
 	  this mode. Typically an external event or RTC activity will wake
-	  up the processor. When in the sleep mode,
-	  system DMA access to L1 memory is not supported.
+	  up the processor. When in the sleep mode, system DMA access to L1
+	  memory is not supported.
+
+	  If unsure, select "Sleep Deeper".
 endchoice

 config PM_WAKEUP_BY_GPIO
-	bool "Cause Wakeup Event by GPIO"
+	bool "Allow Wakeup from Standby by GPIO"

 config PM_WAKEUP_GPIO_NUMBER
-	int "Wakeup GPIO number"
+	int "GPIO number"
 	range 0 47
 	depends on PM_WAKEUP_BY_GPIO
 	default 2 if BFIN537_STAMP
@@ -954,6 +930,58 @@ config  PM_WAKEUP_GPIO_POLAR_EDGE_B
 	bool "Both EDGE"
 endchoice

+comment "Possible Suspend Mem / Hibernate Wake-Up Sources"
+	depends on PM
+
+config PM_BFIN_WAKE_RTC
+	bool "Allow Wake-Up from RESET and on-chip RTC"
+	depends on PM
+	default n
+	help
+	  Enable RTC Wake-Up (Voltage Regulator Power-Up)
+
+config PM_BFIN_WAKE_PH6
+	bool "Allow Wake-Up from on-chip PHY or PH6 GP"
+	depends on PM && (BF52x || BF534 || BF536 || BF537)
+	default n
+	help
+	  Enable PHY and PH6 GP Wake-Up (Voltage Regulator Power-Up)
+
+config PM_BFIN_WAKE_CAN
+	bool "Allow Wake-Up from on-chip CAN0/1"
+	depends on PM && (BF54x || BF534 || BF536 || BF537)
+	default n
+	help
+	  Enable CAN0/1 Wake-Up (Voltage Regulator Power-Up)
+
+config PM_BFIN_WAKE_GP
+	bool "Allow Wake-Up from GPIOs"
+	depends on PM && BF54x
+	default n
+	help
+	  Enable General-Purpose Wake-Up (Voltage Regulator Power-Up)
+
+config PM_BFIN_WAKE_USB
+	bool "Allow Wake-Up from on-chip USB"
+	depends on PM && (BF54x || BF52x)
+	default n
+	help
+	  Enable USB Wake-Up (Voltage Regulator Power-Up)
+
+config PM_BFIN_WAKE_KEYPAD
+	bool "Allow Wake-Up from on-chip Keypad"
+	depends on PM && BF54x
+	default n
+	help
+	  Enable Keypad Wake-Up (Voltage Regulator Power-Up)
+
+config PM_BFIN_WAKE_ROTARY
+	bool "Allow Wake-Up from on-chip Rotary"
+	depends on PM && BF54x
+	default n
+	help
+	  Enable Rotary Wake-Up (Voltage Regulator Power-Up)
+
 endmenu

 menu "CPU Frequency scaling"
diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
index c61bdeb..c468624 100644
--- a/arch/blackfin/Kconfig.debug
+++ b/arch/blackfin/Kconfig.debug
@@ -154,13 +154,6 @@ config EARLY_PRINTK
 	  all of this lives in the init section and is thrown away after the
 	  kernel boots completely.

-config DUAL_CORE_TEST_MODULE
-	tristate "Dual Core Test Module"
-	depends on (BF561)
-	default n
-	help
-	  Say Y here to build-in dual core test module for dual core test.
-
 config CPLB_INFO
 	bool "Display the CPLB information"
 	help
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 3cbe16c..9564731 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -6,8 +6,9 @@
 # for more details.
 #

-
-CROSS_COMPILE    ?= bfin-uclinux-
+ifeq ($(CROSS_COMPILE),)
+CROSS_COMPILE    := bfin-uclinux-
+endif
 LDFLAGS_vmlinux  := -X
 OBJCOPYFLAGS     := -O binary -R .note -R .comment -S
 GZFLAGS          := -9
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig
b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 5e6fb9d..66854a8 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -1,7 +1,6 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.24.7
-# Fri May 16 10:02:29 2008
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -290,7 +289,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-# CONFIG_BFIN_GPTIMERS is not set
+CONFIG_BFIN_GPTIMERS=y
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
@@ -430,7 +429,58 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
+CONFIG_IRDA=m
+
+#
+# IrDA protocols
+#
+CONFIG_IRLAN=m
+CONFIG_IRCOMM=m
+# CONFIG_IRDA_ULTRA is not set
+
+#
+# IrDA options
+#
+# CONFIG_IRDA_CACHE_LAST_LSAP is not set
+# CONFIG_IRDA_FAST_RR is not set
+# CONFIG_IRDA_DEBUG is not set
+
+#
+# Infrared-port device drivers
+#
+
+#
+# SIR device drivers
+#
+CONFIG_IRTTY_SIR=m
+CONFIG_BFIN_SIR=m
+CONFIG_BFIN_SIR0=y
+CONFIG_SIR_BFIN_DMA=y
+# CONFIG_SIR_BFIN_PIO is not set
+
+#
+# Dongle support
+#
+# CONFIG_DONGLE is not set
+# CONFIG_KINGSUN_DONGLE is not set
+# CONFIG_KSDAZZLE_DONGLE is not set
+# CONFIG_KS959_DONGLE is not set
+
+#
+# Old SIR device drivers
+#
+# CONFIG_IRPORT_SIR is not set
+
+#
+# Old Serial dongle support
+#
+
+#
+# FIR device drivers
+#
+# CONFIG_USB_IRDA is not set
+# CONFIG_SIGMATEL_FIR is not set
+# CONFIG_MCS_FIR is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set

@@ -689,8 +739,11 @@ CONFIG_BFIN_OTP=y
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
-# CONFIG_SIMPLE_GPIO is not set
-# CONFIG_VT is not set
+CONFIG_SIMPLE_GPIO=m
+CONFIG_VT=y
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set

 #
@@ -872,8 +925,36 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VGASTATE is not set
 # CONFIG_VIDEO_OUTPUT_CONTROL is not set
-# CONFIG_FB is not set
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_SYS_FOPS is not set
+CONFIG_FB_DEFERRED_IO=y
+# CONFIG_FB_SVGALIB is not set
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
+CONFIG_FB_BFIN_T350MCQB=y
+# CONFIG_FB_BFIN_7393 is not set
+# CONFIG_FB_S1D13XXX is not set
+# CONFIG_FB_VIRTUAL is not set
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_LCD_CLASS_DEVICE=m
+CONFIG_LCD_LTV350QV=m
+CONFIG_BACKLIGHT_CLASS_DEVICE=m
+# CONFIG_BACKLIGHT_CORGI is not set

 #
 # Display device support
@@ -881,9 +962,99 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_DISPLAY_SUPPORT is not set

 #
+# Console display driver support
+#
+CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+# CONFIG_FONTS is not set
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+CONFIG_LOGO=y
+# CONFIG_LOGO_LINUX_MONO is not set
+# CONFIG_LOGO_LINUX_VGA16 is not set
+# CONFIG_LOGO_LINUX_CLUT224 is not set
+# CONFIG_LOGO_BLACKFIN_VGA16 is not set
+CONFIG_LOGO_BLACKFIN_CLUT224=y
+
+#
 # Sound
 #
-# CONFIG_SOUND is not set
+CONFIG_SOUND=m
+
+#
+# Advanced Linux Sound Architecture
+#
+CONFIG_SND=m
+CONFIG_SND_TIMER=m
+CONFIG_SND_PCM=m
+# CONFIG_SND_SEQUENCER is not set
+# CONFIG_SND_MIXER_OSS is not set
+# CONFIG_SND_PCM_OSS is not set
+# CONFIG_SND_DYNAMIC_MINORS is not set
+CONFIG_SND_SUPPORT_OLD_API=y
+CONFIG_SND_VERBOSE_PROCFS=y
+# CONFIG_SND_VERBOSE_PRINTK is not set
+# CONFIG_SND_DEBUG is not set
+
+#
+# Generic devices
+#
+# CONFIG_SND_DUMMY is not set
+# CONFIG_SND_MTPAV is not set
+# CONFIG_SND_SERIAL_U16550 is not set
+# CONFIG_SND_MPU401 is not set
+
+#
+# SPI devices
+#
+
+#
+# ALSA Blackfin devices
+#
+# CONFIG_SND_BLACKFIN_AD1836 is not set
+# CONFIG_SND_BLACKFIN_AD1836_TDM is not set
+# CONFIG_SND_BLACKFIN_AD1836_I2S is not set
+# CONFIG_SND_BLACKFIN_AD1836_MULSUB is not set
+# CONFIG_SND_BLACKFIN_AD1836_5P1 is not set
+# CONFIG_SND_BFIN_AD73311 is not set
+# CONFIG_SND_BFIN_AD73322 is not set
+
+#
+# USB devices
+#
+# CONFIG_SND_USB_AUDIO is not set
+# CONFIG_SND_USB_CAIAQ is not set
+
+#
+# System on Chip audio support
+#
+CONFIG_SND_SOC_AC97_BUS=y
+CONFIG_SND_SOC=m
+CONFIG_SND_BF5XX_SOC=m
+CONFIG_SND_MMAP_SUPPORT=y
+CONFIG_SND_BF5XX_SOC_I2S=m
+CONFIG_SND_BF5XX_SOC_AC97=m
+# CONFIG_SND_BF5XX_SOC_WM8750 is not set
+# CONFIG_SND_BF5XX_SOC_WM8731 is not set
+CONFIG_SND_BF5XX_SOC_SSM2602=m
+CONFIG_SND_BF5XX_SOC_BF5xx=m
+CONFIG_SND_BF5XX_SPORT_NUM=0
+# CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
+
+#
+# SoC Audio support for SuperH
+#
+CONFIG_SND_SOC_SSM2602=m
+# CONFIG_SND_SOC_SSM2602_SPI is not set
+CONFIG_SND_SOC_AD1980=m
+
+#
+# Open Sound System
+#
+# CONFIG_SOUND_PRIME is not set
+CONFIG_AC97_BUS=m
 CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig
b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 8d817ba..6bc11db 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.16
+# Linux kernel version: 2.6.24.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -13,35 +13,34 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 CONFIG_BLK_DEV_INITRD=y
@@ -64,32 +63,24 @@ CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_NP2 is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set

 #
 # IO Schedulers
@@ -141,12 +132,12 @@ CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_ANY is not set
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF53x=y
-CONFIG_BFIN_SINGLE_CORE=y
 CONFIG_MEM_MT48LC16M16A2TG_75=y
 CONFIG_BFIN533_EZKIT=y
 # CONFIG_BFIN533_STAMP is not set
 # CONFIG_BFIN533_BLUETECHNIX_CM is not set
 # CONFIG_H8606_HVSISTEMAS is not set
+# CONFIG_BFIN532_IP0X is not set
 # CONFIG_GENERIC_BF533_BOARD is not set

 #
@@ -189,12 +180,14 @@ CONFIG_WDTIMER=13
 # Board customizations
 #
 # CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000

 #
 # Clock/PLL Setup
 #
 CONFIG_CLKIN_HZ=27000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=512
 CONFIG_MAX_VCO_HZ=750000000
 CONFIG_MIN_VCO_HZ=50000000
 CONFIG_MAX_SCLK_HZ=133333333
@@ -208,13 +201,17 @@ CONFIG_HZ_250=y
 # CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

 #
-# Memory Setup
+# Misc
 #
-CONFIG_MAX_MEM_SIZE=512
-CONFIG_MEM_ADD_WIDTH=9
-CONFIG_BOOT_LOAD=0x1000
 CONFIG_BFIN_SCRATCH_REG_RETN=y
 # CONFIG_BFIN_SCRATCH_REG_RETE is not set
 # CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
@@ -250,12 +247,14 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
-CONFIG_LARGE_ALLOCS=y
+CONFIG_VIRT_TO_BUS=y
 # CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
 # CONFIG_DMA_UNCACHED_NONE is not set
@@ -293,17 +292,13 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xAAC3
+CONFIG_BANK_3=0xAAC2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
 # CONFIG_PCI is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
 # CONFIG_PCCARD is not set

 #
@@ -321,7 +316,9 @@ CONFIG_BINFMT_ZFLAT=y
 CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
-# CONFIG_PM_SYSFS_DEPRECATED is not set
+CONFIG_PM_SLEEP=y
+CONFIG_SUSPEND_UP_POSSIBLE=y
+CONFIG_SUSPEND=y
 CONFIG_PM_BFIN_SLEEP_DEEPER=y
 # CONFIG_PM_BFIN_SLEEP is not set
 # CONFIG_PM_WAKEUP_BY_GPIO is not set
@@ -367,6 +364,7 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_XFRM_MODE_TRANSPORT=y
 CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
@@ -393,10 +391,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set

 #
@@ -428,6 +422,7 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 # SIR device drivers
 #
 CONFIG_IRTTY_SIR=m
+# CONFIG_BFIN_SIR is not set

 #
 # Dongle support
@@ -457,6 +452,7 @@ CONFIG_IRTTY_SIR=m
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set

 #
 # Device Drivers
@@ -465,14 +461,11 @@ CONFIG_IRTTY_SIR=m
 #
 # Generic Driver Options
 #
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
@@ -492,6 +485,7 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
 # CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set

 #
 # RAM/ROM/Flash chip drivers
@@ -548,20 +542,8 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 # UBI - Unsorted block images
 #
 # CONFIG_MTD_UBI is not set
-
-#
-# Parallel port support
-#
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
@@ -571,10 +553,8 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_IDE is not set

 #
@@ -582,32 +562,29 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 #
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_ATA is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
 # CONFIG_MD is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_VETH is not set
 # CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 CONFIG_SMC91X=y
 # CONFIG_SMSC911X is not set
 # CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -624,15 +601,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set

 #
@@ -647,7 +616,6 @@ CONFIG_INPUT=m
 #
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
 CONFIG_INPUT_EVDEV=m
 # CONFIG_INPUT_EVBUG is not set

@@ -672,13 +640,12 @@ CONFIG_INPUT_EVDEV=m
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
-# CONFIG_AD5304 is not set
+CONFIG_SIMPLE_GPIO=m
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set

@@ -706,28 +673,11 @@ CONFIG_UNIX98_PTYS=y
 # CAN, the car bus and industrial fieldbus
 #
 # CONFIG_CAN4LINUX is not set
-
-#
-# IPMI
-#
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-# CONFIG_SOFT_WATCHDOG is not set
-CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
-CONFIG_BLACKFIN_DPMC=y
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 # CONFIG_I2C is not set

@@ -748,22 +698,37 @@ CONFIG_SPI_BFIN=y
 #
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
-
-#
-# Dallas's 1-wire bus
-#
+# CONFIG_SPI_TLE62X0 is not set
 # CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
 CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_IT87 is not set
 # CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set

 #
 # Multifunction device drivers
@@ -780,72 +745,27 @@ CONFIG_DAB=y
 #
 # Graphics support
 #
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set

 #
 # Display device support
 #
 # CONFIG_DISPLAY_SUPPORT is not set
-# CONFIG_VGASTATE is not set
-# CONFIG_FB is not set

 #
 # Sound
 #
 # CONFIG_SOUND is not set
-
-#
-# HID Devices
-#
+CONFIG_HID_SUPPORT=y
 CONFIG_HID=m
 # CONFIG_HID_DEBUG is not set
-
-#
-# USB support
-#
-CONFIG_USB_ARCH_HAS_HCD=y
-# CONFIG_USB_ARCH_HAS_OHCI is not set
-# CONFIG_USB_ARCH_HAS_EHCI is not set
-# CONFIG_USB is not set
-
-#
-# Enable Host or Gadget support to see Inventra options
-#
-
-#
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
-#
-
-#
-# USB Gadget Support
-#
-# CONFIG_USB_GADGET is not set
+# CONFIG_HIDRAW is not set
+# CONFIG_USB_SUPPORT is not set
 # CONFIG_MMC is not set
-
-#
-# LED devices
-#
 # CONFIG_NEW_LEDS is not set
-
-#
-# LED drivers
-#
-
-#
-# LED Triggers
-#
-
-#
-# InfiniBand support
-#
-
-#
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
-#
-
-#
-# Real Time Clock
-#
 CONFIG_RTC_LIB=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_HCTOSYS=y
@@ -862,10 +782,6 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_TEST is not set

 #
-# I2C RTC drivers
-#
-
-#
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -875,8 +791,10 @@ CONFIG_RTC_INTF_DEV=y
 # Platform RTC drivers
 #
 # CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
 # CONFIG_RTC_DRV_V3020 is not set

 #
@@ -885,22 +803,9 @@ CONFIG_RTC_INTF_DEV=y
 CONFIG_RTC_DRV_BFIN=y

 #
-# DMA Engine support
-#
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
-#
-
-#
-# DMA Devices
+# Userspace I/O
 #
-
-#
-# PBX support
-#
-# CONFIG_PBX is not set
+# CONFIG_UIO is not set

 #
 # File systems
@@ -945,7 +850,6 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set

 #
@@ -971,10 +875,12 @@ CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
 # CONFIG_JFFS2_SUMMARY is not set
 # CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 # CONFIG_CRAMFS is not set
@@ -983,10 +889,7 @@ CONFIG_JFFS2_RTIME=y
 # CONFIG_QNX4FS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
+CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=m
 CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
@@ -1006,17 +909,12 @@ CONFIG_SMB_FS=m
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set

 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
 CONFIG_NLS=m
 CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_CODEPAGE_437 is not set
@@ -1057,21 +955,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
 # CONFIG_NLS_UTF8 is not set
-
-#
-# Distributed Lock Manager
-#
 # CONFIG_DLM is not set
-
-#
-# Profiling support
-#
+CONFIG_INSTRUMENTATION=y
 # CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set

 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -1079,6 +972,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
@@ -1098,11 +992,7 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=m
-
-#
-# Cryptographic options
-#
+# CONFIG_SECURITY_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set

 #
@@ -1113,6 +1003,7 @@ CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig
b/arch/blackfin/configs/BF533-STAMP_defconfig
index 20d598d..d77d991 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.16
+# Linux kernel version: 2.6.24.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -13,35 +13,34 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 CONFIG_BLK_DEV_INITRD=y
@@ -64,32 +63,24 @@ CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_NP2 is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set

 #
 # IO Schedulers
@@ -141,12 +132,12 @@ CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_ANY is not set
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF53x=y
-CONFIG_BFIN_SINGLE_CORE=y
 CONFIG_MEM_MT48LC64M4A2FB_7E=y
 # CONFIG_BFIN533_EZKIT is not set
 CONFIG_BFIN533_STAMP=y
 # CONFIG_BFIN533_BLUETECHNIX_CM is not set
 # CONFIG_H8606_HVSISTEMAS is not set
+# CONFIG_BFIN532_IP0X is not set
 # CONFIG_GENERIC_BF533_BOARD is not set

 #
@@ -189,12 +180,14 @@ CONFIG_WDTIMER=13
 # Board customizations
 #
 # CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000

 #
 # Clock/PLL Setup
 #
 CONFIG_CLKIN_HZ=11059200
 # CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=512
 CONFIG_MAX_VCO_HZ=750000000
 CONFIG_MIN_VCO_HZ=50000000
 CONFIG_MAX_SCLK_HZ=133333333
@@ -208,14 +201,17 @@ CONFIG_HZ_250=y
 # CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

 #
-# Memory Setup
+# Misc
 #
-CONFIG_MAX_MEM_SIZE=512
-CONFIG_MEM_ADD_WIDTH=11
-CONFIG_ENET_FLASH_PIN=0
-CONFIG_BOOT_LOAD=0x1000
 CONFIG_BFIN_SCRATCH_REG_RETN=y
 # CONFIG_BFIN_SCRATCH_REG_RETE is not set
 # CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
@@ -251,12 +247,14 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
-CONFIG_LARGE_ALLOCS=y
+CONFIG_VIRT_TO_BUS=y
 # CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
 # CONFIG_DMA_UNCACHED_NONE is not set
@@ -294,17 +292,13 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xAAC3
+CONFIG_BANK_3=0xAAC2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
 # CONFIG_PCI is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
 # CONFIG_PCCARD is not set

 #
@@ -322,7 +316,9 @@ CONFIG_BINFMT_ZFLAT=y
 CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
-# CONFIG_PM_SYSFS_DEPRECATED is not set
+CONFIG_PM_SLEEP=y
+CONFIG_SUSPEND_UP_POSSIBLE=y
+CONFIG_SUSPEND=y
 CONFIG_PM_BFIN_SLEEP_DEEPER=y
 # CONFIG_PM_BFIN_SLEEP is not set
 # CONFIG_PM_WAKEUP_BY_GPIO is not set
@@ -368,6 +364,7 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_XFRM_MODE_TRANSPORT=y
 CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
@@ -394,10 +391,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set

 #
@@ -429,6 +422,9 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 # SIR device drivers
 #
 CONFIG_IRTTY_SIR=m
+CONFIG_BFIN_SIR=m
+CONFIG_SIR_BFIN_DMA=y
+# CONFIG_SIR_BFIN_PIO is not set

 #
 # Dongle support
@@ -458,6 +454,7 @@ CONFIG_IRTTY_SIR=m
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set

 #
 # Device Drivers
@@ -466,14 +463,11 @@ CONFIG_IRTTY_SIR=m
 #
 # Generic Driver Options
 #
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
@@ -493,6 +487,7 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
 # CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set

 #
 # RAM/ROM/Flash chip drivers
@@ -524,11 +519,7 @@ CONFIG_MTD_ROM=m
 #
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 # CONFIG_MTD_PHYSMAP is not set
-CONFIG_MTD_BF5xx=m
-CONFIG_BFIN_FLASH_BANK_0=0x7BB0
-CONFIG_BFIN_FLASH_BANK_1=0x7BB0
-CONFIG_BFIN_FLASH_BANK_2=0x7BB0
-CONFIG_BFIN_FLASH_BANK_3=0x7BB0
+CONFIG_MTD_BFIN_ASYNC=m
 # CONFIG_MTD_UCLINUX is not set
 # CONFIG_MTD_PLATRAM is not set

@@ -555,20 +546,8 @@ CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 # UBI - Unsorted block images
 #
 # CONFIG_MTD_UBI is not set
-
-#
-# Parallel port support
-#
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
@@ -578,10 +557,8 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_IDE is not set

 #
@@ -589,32 +566,29 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 #
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_ATA is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
 # CONFIG_MD is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_VETH is not set
 # CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 CONFIG_SMC91X=y
 # CONFIG_SMSC911X is not set
 # CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -631,15 +605,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set

 #
@@ -654,7 +620,6 @@ CONFIG_INPUT=y
 #
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
 CONFIG_INPUT_EVDEV=m
 # CONFIG_INPUT_EVBUG is not set

@@ -667,14 +632,8 @@ CONFIG_INPUT_EVDEV=m
 # CONFIG_INPUT_TABLET is not set
 # CONFIG_INPUT_TOUCHSCREEN is not set
 CONFIG_INPUT_MISC=y
-# CONFIG_INPUT_ATI_REMOTE is not set
-# CONFIG_INPUT_ATI_REMOTE2 is not set
-# CONFIG_INPUT_KEYSPAN_REMOTE is not set
-# CONFIG_INPUT_POWERMATE is not set
-# CONFIG_INPUT_YEALINK is not set
 # CONFIG_INPUT_UINPUT is not set
 CONFIG_TWI_KEYPAD=m
-CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=39

 #
 # Hardware I/O ports
@@ -687,15 +646,13 @@ CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=39
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
 CONFIG_TWI_LCD=m
-CONFIG_TWI_LCD_SLAVE_ADDR=34
-# CONFIG_AD5304 is not set
+CONFIG_SIMPLE_GPIO=m
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set

@@ -723,28 +680,11 @@ CONFIG_UNIX98_PTYS=y
 # CAN, the car bus and industrial fieldbus
 #
 # CONFIG_CAN4LINUX is not set
-
-#
-# IPMI
-#
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-# CONFIG_SOFT_WATCHDOG is not set
-CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
-CONFIG_BLACKFIN_DPMC=y
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 CONFIG_I2C=m
 CONFIG_I2C_BOARDINFO=y
@@ -764,6 +704,7 @@ CONFIG_I2C_ALGOBIT=m
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
 # CONFIG_I2C_STUB is not set

 #
@@ -771,14 +712,15 @@ CONFIG_I2C_ALGOBIT=m
 #
 # CONFIG_SENSORS_DS1337 is not set
 # CONFIG_SENSORS_DS1374 is not set
+# CONFIG_DS1682 is not set
 # CONFIG_SENSORS_AD5252 is not set
 # CONFIG_SENSORS_EEPROM is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_SENSORS_PCF8575 is not set
-# CONFIG_SENSORS_PCA9543 is not set
 # CONFIG_SENSORS_PCA9539 is not set
 # CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
@@ -801,14 +743,11 @@ CONFIG_SPI_BFIN=y
 #
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
-
-#
-# Dallas's 1-wire bus
-#
+# CONFIG_SPI_TLE62X0 is not set
 # CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
 CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_AD7418 is not set
 # CONFIG_SENSORS_ADM1021 is not set
 # CONFIG_SENSORS_ADM1025 is not set
@@ -816,12 +755,12 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ADT7470 is not set
 # CONFIG_SENSORS_ATXP1 is not set
 # CONFIG_SENSORS_DS1621 is not set
 # CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_FSCHER is not set
-# CONFIG_SENSORS_FSCPOS is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_IT87 is not set
@@ -836,13 +775,16 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_LM87 is not set
 # CONFIG_SENSORS_LM90 is not set
 # CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
 # CONFIG_SENSORS_MAX1619 is not set
 # CONFIG_SENSORS_MAX6650 is not set
 # CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_DME1737 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47M192 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_THMC50 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_SENSORS_W83781D is not set
 # CONFIG_SENSORS_W83791D is not set
@@ -852,6 +794,20 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_W83627HF is not set
 # CONFIG_SENSORS_W83627EHF is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set

 #
 # Multifunction device drivers
@@ -863,24 +819,20 @@ CONFIG_HWMON=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
 #
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
-
-#
-# Display device support
-#
-# CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
 CONFIG_FB=m
 CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB_DDC is not set
 CONFIG_FB_CFB_FILLRECT=m
 CONFIG_FB_CFB_COPYAREA=m
 CONFIG_FB_CFB_IMAGEBLIT=m
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
 # CONFIG_FB_SYS_FILLRECT is not set
 # CONFIG_FB_SYS_COPYAREA is not set
 # CONFIG_FB_SYS_IMAGEBLIT is not set
@@ -895,7 +847,7 @@ CONFIG_FB_DEFERRED_IO=y
 #
 # Frame buffer hardware drivers
 #
-CONFIG_FB_BFIN_7171=m
+# CONFIG_FB_BFIN_T350MCQB is not set
 CONFIG_FB_BFIN_7393=m
 CONFIG_NTSC=y
 # CONFIG_PAL is not set
@@ -905,9 +857,14 @@ CONFIG_NTSC=y
 # CONFIG_PAL_YCBCR is not set
 CONFIG_ADV7393_1XMEM=y
 # CONFIG_ADV7393_2XMEM is not set
-# CONFIG_FB_BFIN_T350MCQB is not set
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_LOGO is not set

 #
@@ -941,6 +898,10 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_MPU401 is not set

 #
+# SPI devices
+#
+
+#
 # ALSA Blackfin devices
 #
 CONFIG_SND_BLACKFIN_AD1836=m
@@ -953,69 +914,43 @@ CONFIG_SND_BLACKFIN_SPI_PFBIT=4
 CONFIG_SND_BFIN_AD73311=m
 CONFIG_SND_BFIN_SPORT=0
 CONFIG_SND_BFIN_AD73311_SE=4
+CONFIG_SND_BFIN_AD73322=m
+CONFIG_SND_BFIN_AD73322_SPORT0_SE=10
+CONFIG_SND_BFIN_AD73322_SPORT1_SE=14
+CONFIG_SND_BFIN_AD73322_RESET=12

 #
 # System on Chip audio support
 #
-# CONFIG_SND_SOC is not set
+CONFIG_SND_SOC_AC97_BUS=y
+CONFIG_SND_SOC=m
+CONFIG_SND_BF5XX_SOC=m
+CONFIG_SND_MMAP_SUPPORT=y
+CONFIG_SND_BF5XX_SOC_AC97=m
+# CONFIG_SND_BF5XX_SOC_WM8750 is not set
+# CONFIG_SND_BF5XX_SOC_WM8731 is not set
+# CONFIG_SND_BF5XX_SOC_SSM2602 is not set
+CONFIG_SND_BF5XX_SOC_BF5xx=m
+CONFIG_SND_BF5XX_SPORT_NUM=0
+# CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set

 #
-# Open Sound System
+# SoC Audio support for SuperH
 #
-# CONFIG_SOUND_PRIME is not set
+CONFIG_SND_SOC_AD1980=m

 #
-# HID Devices
+# Open Sound System
 #
+# CONFIG_SOUND_PRIME is not set
+CONFIG_AC97_BUS=m
+CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
-
-#
-# USB support
-#
-CONFIG_USB_ARCH_HAS_HCD=y
-# CONFIG_USB_ARCH_HAS_OHCI is not set
-# CONFIG_USB_ARCH_HAS_EHCI is not set
-# CONFIG_USB is not set
-
-#
-# Enable Host or Gadget support to see Inventra options
-#
-
-#
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
-#
-
-#
-# USB Gadget Support
-#
-# CONFIG_USB_GADGET is not set
+# CONFIG_HIDRAW is not set
+# CONFIG_USB_SUPPORT is not set
 # CONFIG_MMC is not set
-
-#
-# LED devices
-#
 # CONFIG_NEW_LEDS is not set
-
-#
-# LED drivers
-#
-
-#
-# LED Triggers
-#
-
-#
-# InfiniBand support
-#
-
-#
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
-#
-
-#
-# Real Time Clock
-#
 CONFIG_RTC_LIB=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_HCTOSYS=y
@@ -1035,6 +970,7 @@ CONFIG_RTC_INTF_DEV=y
 # I2C RTC drivers
 #
 # CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
 # CONFIG_RTC_DRV_DS1672 is not set
 # CONFIG_RTC_DRV_MAX6900 is not set
 # CONFIG_RTC_DRV_RS5C372 is not set
@@ -1042,6 +978,7 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_X1205 is not set
 # CONFIG_RTC_DRV_PCF8563 is not set
 # CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set

 #
 # SPI RTC drivers
@@ -1053,8 +990,10 @@ CONFIG_RTC_INTF_DEV=y
 # Platform RTC drivers
 #
 # CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
 # CONFIG_RTC_DRV_V3020 is not set

 #
@@ -1063,22 +1002,9 @@ CONFIG_RTC_INTF_DEV=y
 CONFIG_RTC_DRV_BFIN=y

 #
-# DMA Engine support
+# Userspace I/O
 #
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
-#
-
-#
-# DMA Devices
-#
-
-#
-# PBX support
-#
-# CONFIG_PBX is not set
+# CONFIG_UIO is not set

 #
 # File systems
@@ -1123,7 +1049,6 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set

 #
@@ -1149,10 +1074,12 @@ CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
 # CONFIG_JFFS2_SUMMARY is not set
 # CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 # CONFIG_CRAMFS is not set
@@ -1161,10 +1088,7 @@ CONFIG_JFFS2_RTIME=y
 # CONFIG_QNX4FS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
+CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=m
 CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
@@ -1184,17 +1108,12 @@ CONFIG_SMB_FS=m
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set

 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
 CONFIG_NLS=m
 CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_CODEPAGE_437 is not set
@@ -1235,21 +1154,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
 # CONFIG_NLS_UTF8 is not set
-
-#
-# Distributed Lock Manager
-#
 # CONFIG_DLM is not set
-
-#
-# Profiling support
-#
+CONFIG_INSTRUMENTATION=y
 # CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set

 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -1257,6 +1171,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
@@ -1276,11 +1191,7 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=m
-
-#
-# Cryptographic options
-#
+# CONFIG_SECURITY_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set

 #
@@ -1291,6 +1202,7 @@ CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig
b/arch/blackfin/configs/BF537-STAMP_defconfig
index b5189c8..5fd7c4b 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.16
+# Linux kernel version: 2.6.24.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -13,35 +13,34 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 CONFIG_BLK_DEV_INITRD=y
@@ -64,32 +63,24 @@ CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_NP2 is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set

 #
 # IO Schedulers
@@ -141,7 +132,6 @@ CONFIG_BF_REV_0_2=y
 # CONFIG_BF_REV_ANY is not set
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF53x=y
-CONFIG_BFIN_SINGLE_CORE=y
 CONFIG_MEM_MT48LC32M8A2_75=y
 CONFIG_IRQ_PLL_WAKEUP=7
 CONFIG_IRQ_RTC=8
@@ -197,12 +187,14 @@ CONFIG_IRQ_PROG_INTA=12
 # Board customizations
 #
 # CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000

 #
 # Clock/PLL Setup
 #
 CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=512
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
 CONFIG_MAX_SCLK_HZ=133333333
@@ -216,13 +208,17 @@ CONFIG_HZ_250=y
 # CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

 #
-# Memory Setup
+# Misc
 #
-CONFIG_MAX_MEM_SIZE=512
-CONFIG_MEM_ADD_WIDTH=10
-CONFIG_BOOT_LOAD=0x1000
 CONFIG_BFIN_SCRATCH_REG_RETN=y
 # CONFIG_BFIN_SCRATCH_REG_RETE is not set
 # CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
@@ -258,12 +254,14 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
-CONFIG_LARGE_ALLOCS=y
+CONFIG_VIRT_TO_BUS=y
 # CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
 # CONFIG_DMA_UNCACHED_NONE is not set
@@ -301,17 +299,13 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0x99B3
+CONFIG_BANK_3=0x99B2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
 # CONFIG_PCI is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
 # CONFIG_PCCARD is not set

 #
@@ -329,7 +323,9 @@ CONFIG_BINFMT_ZFLAT=y
 CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
-# CONFIG_PM_SYSFS_DEPRECATED is not set
+CONFIG_PM_SLEEP=y
+CONFIG_SUSPEND_UP_POSSIBLE=y
+CONFIG_SUSPEND=y
 CONFIG_PM_BFIN_SLEEP_DEEPER=y
 # CONFIG_PM_BFIN_SLEEP is not set
 # CONFIG_PM_WAKEUP_BY_GPIO is not set
@@ -375,6 +371,7 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_XFRM_MODE_TRANSPORT=y
 CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
@@ -401,10 +398,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set

 #
@@ -436,6 +429,10 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 # SIR device drivers
 #
 CONFIG_IRTTY_SIR=m
+CONFIG_BFIN_SIR=m
+CONFIG_BFIN_SIR1=y
+CONFIG_SIR_BFIN_DMA=y
+# CONFIG_SIR_BFIN_PIO is not set

 #
 # Dongle support
@@ -465,6 +462,7 @@ CONFIG_IRTTY_SIR=m
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set

 #
 # Device Drivers
@@ -473,14 +471,11 @@ CONFIG_IRTTY_SIR=m
 #
 # Generic Driver Options
 #
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
@@ -500,6 +495,7 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
 # CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set

 #
 # RAM/ROM/Flash chip drivers
@@ -572,20 +568,8 @@ CONFIG_MTD_NAND_IDS=m
 # UBI - Unsorted block images
 #
 # CONFIG_MTD_UBI is not set
-
-#
-# Parallel port support
-#
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
@@ -595,10 +579,8 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_IDE is not set

 #
@@ -606,22 +588,18 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 #
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_ATA is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
 # CONFIG_MD is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_VETH is not set
 CONFIG_PHYLIB=y

 #
@@ -635,21 +613,24 @@ CONFIG_PHYLIB=y
 # CONFIG_VITESSE_PHY is not set
 CONFIG_SMSC_PHY=y
 # CONFIG_BROADCOM_PHY is not set
+# CONFIG_ICPLUS_PHY is not set
 # CONFIG_FIXED_PHY is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
+# CONFIG_MDIO_BITBANG is not set
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
-# CONFIG_SMC91X is not set
 CONFIG_BFIN_MAC=y
 CONFIG_BFIN_MAC_USE_L1=y
 CONFIG_BFIN_TX_DESC_NUM=10
 CONFIG_BFIN_RX_DESC_NUM=20
 # CONFIG_BFIN_MAC_RMII is not set
+# CONFIG_SMC91X is not set
 # CONFIG_SMSC911X is not set
 # CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -666,15 +647,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set

 #
@@ -689,7 +662,6 @@ CONFIG_INPUT=y
 #
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
 CONFIG_INPUT_EVDEV=m
 # CONFIG_INPUT_EVBUG is not set

@@ -702,14 +674,8 @@ CONFIG_INPUT_EVDEV=m
 # CONFIG_INPUT_TABLET is not set
 # CONFIG_INPUT_TOUCHSCREEN is not set
 CONFIG_INPUT_MISC=y
-# CONFIG_INPUT_ATI_REMOTE is not set
-# CONFIG_INPUT_ATI_REMOTE2 is not set
-# CONFIG_INPUT_KEYSPAN_REMOTE is not set
-# CONFIG_INPUT_POWERMATE is not set
-# CONFIG_INPUT_YEALINK is not set
 # CONFIG_INPUT_UINPUT is not set
 CONFIG_TWI_KEYPAD=m
-CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=72

 #
 # Hardware I/O ports
@@ -722,15 +688,13 @@ CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=72
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
 CONFIG_TWI_LCD=m
-CONFIG_TWI_LCD_SLAVE_ADDR=34
-# CONFIG_AD5304 is not set
+CONFIG_SIMPLE_GPIO=m
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set

@@ -766,28 +730,11 @@ CONFIG_CAN4LINUX=y
 # CONFIG_CAN_MCF5282 is not set
 # CONFIG_CAN_UNCTWINCAN is not set
 CONFIG_CAN_BLACKFIN=m
-
-#
-# IPMI
-#
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-# CONFIG_SOFT_WATCHDOG is not set
-CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
-CONFIG_BLACKFIN_DPMC=y
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 CONFIG_I2C=m
 CONFIG_I2C_BOARDINFO=y
@@ -809,6 +756,7 @@ CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
 # CONFIG_I2C_STUB is not set

 #
@@ -816,14 +764,15 @@ CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
 #
 # CONFIG_SENSORS_DS1337 is not set
 # CONFIG_SENSORS_DS1374 is not set
+# CONFIG_DS1682 is not set
 CONFIG_SENSORS_AD5252=m
 # CONFIG_SENSORS_EEPROM is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_SENSORS_PCF8575 is not set
-# CONFIG_SENSORS_PCA9543 is not set
 # CONFIG_SENSORS_PCA9539 is not set
 # CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
@@ -846,14 +795,11 @@ CONFIG_SPI_BFIN=y
 #
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
-
-#
-# Dallas's 1-wire bus
-#
+# CONFIG_SPI_TLE62X0 is not set
 # CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
 CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_AD7418 is not set
 # CONFIG_SENSORS_ADM1021 is not set
 # CONFIG_SENSORS_ADM1025 is not set
@@ -861,12 +807,12 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ADT7470 is not set
 # CONFIG_SENSORS_ATXP1 is not set
 # CONFIG_SENSORS_DS1621 is not set
 # CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_FSCHER is not set
-# CONFIG_SENSORS_FSCPOS is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_IT87 is not set
@@ -881,13 +827,16 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_LM87 is not set
 # CONFIG_SENSORS_LM90 is not set
 # CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
 # CONFIG_SENSORS_MAX1619 is not set
 # CONFIG_SENSORS_MAX6650 is not set
 # CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_DME1737 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47M192 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_THMC50 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_SENSORS_W83781D is not set
 # CONFIG_SENSORS_W83791D is not set
@@ -897,6 +846,20 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_W83627HF is not set
 # CONFIG_SENSORS_W83627EHF is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set

 #
 # Multifunction device drivers
@@ -913,21 +876,15 @@ CONFIG_DAB=y
 #
 # Graphics support
 #
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
-CONFIG_BACKLIGHT_CLASS_DEVICE=m
-CONFIG_LCD_CLASS_DEVICE=m
-
-#
-# Display device support
-#
-# CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
 CONFIG_FB=m
 CONFIG_FIRMWARE_EDID=y
 # CONFIG_FB_DDC is not set
 CONFIG_FB_CFB_FILLRECT=m
 CONFIG_FB_CFB_COPYAREA=m
 CONFIG_FB_CFB_IMAGEBLIT=m
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
 # CONFIG_FB_SYS_FILLRECT is not set
 # CONFIG_FB_SYS_COPYAREA is not set
 # CONFIG_FB_SYS_IMAGEBLIT is not set
@@ -942,7 +899,8 @@ CONFIG_FB_DEFERRED_IO=y
 #
 # Frame buffer hardware drivers
 #
-CONFIG_FB_BFIN_7171=m
+# CONFIG_FB_HITACHI_TX09 is not set
+# CONFIG_FB_BFIN_T350MCQB is not set
 CONFIG_FB_BFIN_7393=m
 CONFIG_NTSC=y
 # CONFIG_PAL is not set
@@ -956,10 +914,18 @@ CONFIG_FB_BF537_LQ035=m
 CONFIG_LQ035_SLAVE_ADDR=0x58
 # CONFIG_FB_BFIN_LANDSCAPE is not set
 # CONFIG_FB_BFIN_BGR is not set
-# CONFIG_FB_BFIN_T350MCQB is not set
-# CONFIG_FB_HITACHI_TX09 is not set
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_LCD_CLASS_DEVICE=m
+# CONFIG_LCD_LTV350QV is not set
+CONFIG_BACKLIGHT_CLASS_DEVICE=m
+CONFIG_BACKLIGHT_CORGI=m
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_LOGO is not set

 #
@@ -993,6 +959,10 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_MPU401 is not set

 #
+# SPI devices
+#
+
+#
 # ALSA Blackfin devices
 #
 CONFIG_SND_BLACKFIN_AD1836=m
@@ -1005,6 +975,10 @@ CONFIG_SND_BLACKFIN_SPI_PFBIT=4
 CONFIG_SND_BFIN_AD73311=m
 CONFIG_SND_BFIN_SPORT=0
 CONFIG_SND_BFIN_AD73311_SE=4
+CONFIG_SND_BFIN_AD73322=m
+CONFIG_SND_BFIN_AD73322_SPORT0_SE=10
+CONFIG_SND_BFIN_AD73322_SPORT1_SE=14
+CONFIG_SND_BFIN_AD73322_RESET=12

 #
 # System on Chip audio support
@@ -1016,9 +990,14 @@ CONFIG_SND_MMAP_SUPPORT=y
 CONFIG_SND_BF5XX_SOC_AC97=m
 # CONFIG_SND_BF5XX_SOC_WM8750 is not set
 # CONFIG_SND_BF5XX_SOC_WM8731 is not set
+# CONFIG_SND_BF5XX_SOC_SSM2602 is not set
 CONFIG_SND_BF5XX_SOC_BF5xx=m
 CONFIG_SND_BF5XX_SPORT_NUM=0
 # CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
+
+#
+# SoC Audio support for SuperH
+#
 CONFIG_SND_SOC_AD1980=m

 #
@@ -1026,59 +1005,18 @@ CONFIG_SND_SOC_AD1980=m
 #
 # CONFIG_SOUND_PRIME is not set
 CONFIG_AC97_BUS=m
-
-#
-# HID Devices
-#
+CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
-
-#
-# USB support
-#
-CONFIG_USB_ARCH_HAS_HCD=y
-# CONFIG_USB_ARCH_HAS_OHCI is not set
-# CONFIG_USB_ARCH_HAS_EHCI is not set
-# CONFIG_USB is not set
-
-#
-# Enable Host or Gadget support to see Inventra options
-#
-
-#
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
-#
-
-#
-# USB Gadget Support
-#
-# CONFIG_USB_GADGET is not set
+# CONFIG_HIDRAW is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_NO_DUMMY_DELAY is not set
+# CONFIG_DUMMY_DELAY_BANK0 is not set
+# CONFIG_DUMMY_DELAY_BANK1 is not set
+# CONFIG_DUMMY_DELAY_BANK2 is not set
+# CONFIG_DUMMY_DELAY_BANK3 is not set
 # CONFIG_MMC is not set
-
-#
-# LED devices
-#
 # CONFIG_NEW_LEDS is not set
-
-#
-# LED drivers
-#
-
-#
-# LED Triggers
-#
-
-#
-# InfiniBand support
-#
-
-#
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
-#
-
-#
-# Real Time Clock
-#
 CONFIG_RTC_LIB=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_HCTOSYS=y
@@ -1098,6 +1036,7 @@ CONFIG_RTC_INTF_DEV=y
 # I2C RTC drivers
 #
 # CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
 # CONFIG_RTC_DRV_DS1672 is not set
 # CONFIG_RTC_DRV_MAX6900 is not set
 # CONFIG_RTC_DRV_RS5C372 is not set
@@ -1105,6 +1044,7 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_X1205 is not set
 # CONFIG_RTC_DRV_PCF8563 is not set
 # CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set

 #
 # SPI RTC drivers
@@ -1116,8 +1056,10 @@ CONFIG_RTC_INTF_DEV=y
 # Platform RTC drivers
 #
 # CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
 # CONFIG_RTC_DRV_V3020 is not set

 #
@@ -1126,22 +1068,9 @@ CONFIG_RTC_INTF_DEV=y
 CONFIG_RTC_DRV_BFIN=y

 #
-# DMA Engine support
+# Userspace I/O
 #
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
-#
-
-#
-# DMA Devices
-#
-
-#
-# PBX support
-#
-# CONFIG_PBX is not set
+# CONFIG_UIO is not set

 #
 # File systems
@@ -1186,7 +1115,6 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set

 #
@@ -1212,10 +1140,12 @@ CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
 # CONFIG_JFFS2_SUMMARY is not set
 # CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 # CONFIG_CRAMFS is not set
@@ -1224,10 +1154,7 @@ CONFIG_JFFS2_RTIME=y
 # CONFIG_QNX4FS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
+CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=m
 CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
@@ -1247,17 +1174,12 @@ CONFIG_SMB_FS=m
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set

 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
 CONFIG_NLS=m
 CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_CODEPAGE_437 is not set
@@ -1298,21 +1220,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
 # CONFIG_NLS_UTF8 is not set
-
-#
-# Distributed Lock Manager
-#
 # CONFIG_DLM is not set
-
-#
-# Profiling support
-#
+CONFIG_INSTRUMENTATION=y
 # CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set

 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -1320,6 +1237,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
@@ -1339,11 +1257,7 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=m
-
-#
-# Cryptographic options
-#
+# CONFIG_SECURITY_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set

 #
@@ -1354,6 +1268,7 @@ CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig
b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 1ff2ff4..137c832 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -365,7 +365,7 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x5554
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0x99B3
+CONFIG_BANK_3=0x99B2
 CONFIG_EBIU_MBSCTLVAL=0x0
 CONFIG_EBIU_MODEVAL=0x1
 CONFIG_EBIU_FCTLVAL=0x6
@@ -468,7 +468,60 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
+CONFIG_IRDA=m
+
+#
+# IrDA protocols
+#
+CONFIG_IRLAN=m
+CONFIG_IRCOMM=m
+# CONFIG_IRDA_ULTRA is not set
+
+#
+# IrDA options
+#
+# CONFIG_IRDA_CACHE_LAST_LSAP is not set
+# CONFIG_IRDA_FAST_RR is not set
+# CONFIG_IRDA_DEBUG is not set
+
+#
+# Infrared-port device drivers
+#
+
+#
+# SIR device drivers
+#
+CONFIG_IRTTY_SIR=m
+CONFIG_BFIN_SIR=m
+# CONFIG_BFIN_SIR0 is not set
+# CONFIG_BFIN_SIR2 is not set
+CONFIG_BFIN_SIR3=y
+CONFIG_SIR_BFIN_DMA=y
+# CONFIG_SIR_BFIN_PIO is not set
+
+#
+# Dongle support
+#
+# CONFIG_DONGLE is not set
+# CONFIG_KINGSUN_DONGLE is not set
+# CONFIG_KSDAZZLE_DONGLE is not set
+# CONFIG_KS959_DONGLE is not set
+
+#
+# Old SIR device drivers
+#
+# CONFIG_IRPORT_SIR is not set
+
+#
+# Old Serial dongle support
+#
+
+#
+# FIR device drivers
+#
+# CONFIG_USB_IRDA is not set
+# CONFIG_SIGMATEL_FIR is not set
+# CONFIG_MCS_FIR is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set

@@ -575,6 +628,7 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_IDS=y
 CONFIG_MTD_NAND_BF5XX=y
 CONFIG_MTD_NAND_BF5XX_HWECC=y
+# CONFIG_MTD_NAND_BF5XX_BOOTROM_ECC is not set
 # CONFIG_MTD_NAND_DISKONCHIP is not set
 # CONFIG_MTD_NAND_NANDSIM is not set
 # CONFIG_MTD_NAND_PLATFORM is not set
@@ -766,7 +820,7 @@ CONFIG_BFIN_OTP=y
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
-# CONFIG_SIMPLE_GPIO is not set
+CONFIG_SIMPLE_GPIO=m
 CONFIG_VT=y
 CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
@@ -1071,6 +1125,7 @@ CONFIG_SND_BF5XX_SOC_AC97=y
 CONFIG_SND_BF5XX_SOC_BF548_EZKIT=y
 # CONFIG_SND_BF5XX_SOC_WM8750 is not set
 # CONFIG_SND_BF5XX_SOC_WM8731 is not set
+# CONFIG_SND_BF5XX_SOC_SSM2602 is not set
 CONFIG_SND_BF5XX_SPORT_NUM=0
 CONFIG_SND_BF5XX_HAVE_COLD_RESET=y
 CONFIG_SND_BF5XX_RESET_GPIO_NUM=19
@@ -1133,7 +1188,7 @@ CONFIG_USB_MUSB_HOST=y
 # CONFIG_USB_MUSB_OTG is not set
 CONFIG_USB_MUSB_HDRC_HCD=y
 # CONFIG_MUSB_PIO_ONLY is not set
-# CONFIG_USB_INVENTRA_DMA is not set
+CONFIG_USB_INVENTRA_DMA=y
 # CONFIG_USB_TI_CPPI_DMA is not set
 CONFIG_USB_MUSB_LOGLEVEL=0

diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig
b/arch/blackfin/configs/BF561-EZKIT_defconfig
index b4a20c8..976a4d7 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.16
+# Linux kernel version: 2.6.24.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -13,35 +13,34 @@ CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_GPIO=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 CONFIG_BLK_DEV_INITRD=y
@@ -64,32 +63,24 @@ CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_NP2 is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set

 #
 # IO Schedulers
@@ -140,7 +131,6 @@ CONFIG_BF_REV_0_3=y
 # CONFIG_BF_REV_0_5 is not set
 # CONFIG_BF_REV_ANY is not set
 # CONFIG_BF_REV_NONE is not set
-CONFIG_BFIN_DUAL_CORE=y
 CONFIG_MEM_MT48LC16M16A2TG_75=y
 CONFIG_IRQ_PLL_WAKEUP=7
 CONFIG_IRQ_SPORT0_ERROR=7
@@ -233,12 +223,14 @@ CONFIG_IRQ_WDTIMER=13
 # Board customizations
 #
 # CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000

 #
 # Clock/PLL Setup
 #
 CONFIG_CLKIN_HZ=30000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=512
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
 CONFIG_MAX_SCLK_HZ=133333333
@@ -252,13 +244,17 @@ CONFIG_HZ_250=y
 # CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

 #
-# Memory Setup
+# Misc
 #
-CONFIG_MAX_MEM_SIZE=512
-CONFIG_MEM_ADD_WIDTH=9
-CONFIG_BOOT_LOAD=0x1000
 CONFIG_BFIN_SCRATCH_REG_RETN=y
 # CONFIG_BFIN_SCRATCH_REG_RETE is not set
 # CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
@@ -294,12 +290,14 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
-CONFIG_LARGE_ALLOCS=y
+CONFIG_VIRT_TO_BUS=y
 # CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
 # CONFIG_DMA_UNCACHED_NONE is not set
@@ -341,17 +339,13 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xAAC3
+CONFIG_BANK_3=0xAAC2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
 # CONFIG_PCI is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
 # CONFIG_PCCARD is not set

 #
@@ -367,9 +361,15 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 # CONFIG_PM is not set
+CONFIG_SUSPEND_UP_POSSIBLE=y
 # CONFIG_PM_WAKEUP_BY_GPIO is not set

 #
+# CPU Frequency scaling
+#
+# CONFIG_CPU_FREQ is not set
+
+#
 # Networking
 #
 CONFIG_NET=y
@@ -405,6 +405,7 @@ CONFIG_SYN_COOKIES=y
 CONFIG_INET_XFRM_MODE_TRANSPORT=y
 CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
@@ -431,10 +432,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set

 #
@@ -466,6 +463,7 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 # SIR device drivers
 #
 CONFIG_IRTTY_SIR=m
+# CONFIG_BFIN_SIR is not set

 #
 # Dongle support
@@ -495,6 +493,7 @@ CONFIG_IRTTY_SIR=m
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set

 #
 # Device Drivers
@@ -503,14 +502,11 @@ CONFIG_IRTTY_SIR=m
 #
 # Generic Driver Options
 #
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
@@ -530,6 +526,7 @@ CONFIG_MTD_BLOCK=y
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
 # CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set

 #
 # RAM/ROM/Flash chip drivers
@@ -590,20 +587,8 @@ CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 # UBI - Unsorted block images
 #
 # CONFIG_MTD_UBI is not set
-
-#
-# Parallel port support
-#
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
@@ -613,10 +598,8 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_IDE is not set

 #
@@ -624,32 +607,29 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 #
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_ATA is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
 # CONFIG_MD is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
+# CONFIG_VETH is not set
 # CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 CONFIG_SMC91X=y
 # CONFIG_SMSC911X is not set
 # CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -666,15 +646,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set

 #
@@ -689,7 +661,6 @@ CONFIG_INPUT=m
 #
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
 CONFIG_INPUT_EVDEV=m
 # CONFIG_INPUT_EVBUG is not set

@@ -714,13 +685,12 @@ CONFIG_INPUT_EVDEV=m
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
-# CONFIG_AD5304 is not set
+CONFIG_SIMPLE_GPIO=m
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set

@@ -748,27 +718,11 @@ CONFIG_UNIX98_PTYS=y
 # CAN, the car bus and industrial fieldbus
 #
 # CONFIG_CAN4LINUX is not set
-
-#
-# IPMI
-#
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-# CONFIG_SOFT_WATCHDOG is not set
-CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 # CONFIG_I2C is not set

@@ -789,22 +743,37 @@ CONFIG_SPI_BFIN=y
 #
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
-
-#
-# Dallas's 1-wire bus
-#
+# CONFIG_SPI_TLE62X0 is not set
 # CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
 CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_IT87 is not set
 # CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set

 #
 # Multifunction device drivers
@@ -821,91 +790,33 @@ CONFIG_DAB=y
 #
 # Graphics support
 #
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set

 #
 # Display device support
 #
 # CONFIG_DISPLAY_SUPPORT is not set
-# CONFIG_VGASTATE is not set
-# CONFIG_FB is not set

 #
 # Sound
 #
 # CONFIG_SOUND is not set
-
-#
-# HID Devices
-#
+CONFIG_HID_SUPPORT=y
 CONFIG_HID=m
 # CONFIG_HID_DEBUG is not set
-
-#
-# USB support
-#
-CONFIG_USB_ARCH_HAS_HCD=y
-# CONFIG_USB_ARCH_HAS_OHCI is not set
-# CONFIG_USB_ARCH_HAS_EHCI is not set
-# CONFIG_USB is not set
-
-#
-# Enable Host or Gadget support to see Inventra options
-#
-
-#
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
-#
-
-#
-# USB Gadget Support
-#
-# CONFIG_USB_GADGET is not set
+# CONFIG_HIDRAW is not set
+# CONFIG_USB_SUPPORT is not set
 # CONFIG_MMC is not set
-
-#
-# LED devices
-#
 # CONFIG_NEW_LEDS is not set
-
-#
-# LED drivers
-#
-
-#
-# LED Triggers
-#
-
-#
-# InfiniBand support
-#
-
-#
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
-#
-
-#
-# Real Time Clock
-#
 # CONFIG_RTC_CLASS is not set

 #
-# DMA Engine support
-#
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
-#
-
-#
-# DMA Devices
+# Userspace I/O
 #
-
-#
-# PBX support
-#
-# CONFIG_PBX is not set
+# CONFIG_UIO is not set

 #
 # File systems
@@ -950,7 +861,6 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set

 #
@@ -976,10 +886,12 @@ CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
 # CONFIG_JFFS2_SUMMARY is not set
 # CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 # CONFIG_CRAMFS is not set
@@ -988,10 +900,7 @@ CONFIG_JFFS2_RTIME=y
 # CONFIG_QNX4FS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
+CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=m
 CONFIG_NFS_V3=y
 # CONFIG_NFS_V3_ACL is not set
@@ -1011,17 +920,12 @@ CONFIG_SMB_FS=m
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set

 #
 # Partition Types
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
 CONFIG_NLS=m
 CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_CODEPAGE_437 is not set
@@ -1062,21 +966,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_KOI8_R is not set
 # CONFIG_NLS_KOI8_U is not set
 # CONFIG_NLS_UTF8 is not set
-
-#
-# Distributed Lock Manager
-#
 # CONFIG_DLM is not set
-
-#
-# Profiling support
-#
+CONFIG_INSTRUMENTATION=y
 # CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set

 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -1084,6 +983,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
@@ -1104,11 +1004,7 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=m
-
-#
-# Cryptographic options
-#
+# CONFIG_SECURITY_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set

 #
@@ -1119,6 +1015,7 @@ CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
diff --git a/arch/blackfin/configs/CM-BF527_defconfig
b/arch/blackfin/configs/CM-BF527_defconfig
new file mode 100644
index 0000000..0799aa9
--- /dev/null
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -0,0 +1,1185 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.24.7
+# Fri Jul 18 18:00:41 2008
+#
+# CONFIG_MMU is not set
+# CONFIG_FPU is not set
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
+CONFIG_SEMAPHORE_SLEEPERS=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_GENERIC_GPIO=y
+CONFIG_FORCE_MAX_ZONEORDER=14
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+# CONFIG_AUDIT is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_TINY_SHMEM=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+# CONFIG_PREEMPT_NONE is not set
+CONFIG_PREEMPT_VOLUNTARY=y
+# CONFIG_PREEMPT is not set
+
+#
+# Blackfin Processor Options
+#
+
+#
+# Processor and Board Settings
+#
+# CONFIG_BF522 is not set
+# CONFIG_BF523 is not set
+# CONFIG_BF524 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF526 is not set
+CONFIG_BF527=y
+# CONFIG_BF531 is not set
+# CONFIG_BF532 is not set
+# CONFIG_BF533 is not set
+# CONFIG_BF534 is not set
+# CONFIG_BF536 is not set
+# CONFIG_BF537 is not set
+# CONFIG_BF542 is not set
+# CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
+# CONFIG_BF548 is not set
+# CONFIG_BF549 is not set
+# CONFIG_BF561 is not set
+# CONFIG_BF_REV_0_0 is not set
+CONFIG_BF_REV_0_1=y
+# CONFIG_BF_REV_0_2 is not set
+# CONFIG_BF_REV_0_3 is not set
+# CONFIG_BF_REV_0_4 is not set
+# CONFIG_BF_REV_0_5 is not set
+# CONFIG_BF_REV_ANY is not set
+# CONFIG_BF_REV_NONE is not set
+CONFIG_BF52x=y
+CONFIG_MEM_MT48LC16M16A2TG_75=y
+# CONFIG_BFIN527_EZKIT is not set
+CONFIG_BFIN527_BLUETECHNIX_CM=y
+
+#
+# BF527 Specific Configuration
+#
+
+#
+# Alternative Multiplexing Scheme
+#
+# CONFIG_BF527_SPORT0_PORTF is not set
+CONFIG_BF527_SPORT0_PORTG=y
+CONFIG_BF527_SPORT0_TSCLK_PG10=y
+# CONFIG_BF527_SPORT0_TSCLK_PG14 is not set
+CONFIG_BF527_UART1_PORTF=y
+# CONFIG_BF527_UART1_PORTG is not set
+# CONFIG_BF527_NAND_D_PORTF is not set
+CONFIG_BF527_NAND_D_PORTH=y
+
+#
+# Interrupt Priority Assignment
+#
+
+#
+# Priority
+#
+CONFIG_IRQ_PLL_WAKEUP=7
+CONFIG_IRQ_DMA0_ERROR=7
+CONFIG_IRQ_DMAR0_BLK=7
+CONFIG_IRQ_DMAR1_BLK=7
+CONFIG_IRQ_DMAR0_OVR=7
+CONFIG_IRQ_DMAR1_OVR=7
+CONFIG_IRQ_PPI_ERROR=7
+CONFIG_IRQ_MAC_ERROR=7
+CONFIG_IRQ_SPORT0_ERROR=7
+CONFIG_IRQ_SPORT1_ERROR=7
+CONFIG_IRQ_UART0_ERROR=7
+CONFIG_IRQ_UART1_ERROR=7
+CONFIG_IRQ_RTC=8
+CONFIG_IRQ_PPI=8
+CONFIG_IRQ_SPORT0_RX=9
+CONFIG_IRQ_SPORT0_TX=9
+CONFIG_IRQ_SPORT1_RX=9
+CONFIG_IRQ_SPORT1_TX=9
+CONFIG_IRQ_TWI=10
+CONFIG_IRQ_SPI=10
+CONFIG_IRQ_UART0_RX=10
+CONFIG_IRQ_UART0_TX=10
+CONFIG_IRQ_UART1_RX=10
+CONFIG_IRQ_UART1_TX=10
+CONFIG_IRQ_OPTSEC=11
+CONFIG_IRQ_CNT=11
+CONFIG_IRQ_MAC_RX=11
+CONFIG_IRQ_PORTH_INTA=11
+CONFIG_IRQ_MAC_TX=11
+CONFIG_IRQ_PORTH_INTB=11
+CONFIG_IRQ_TMR0=12
+CONFIG_IRQ_TMR1=12
+CONFIG_IRQ_TMR2=12
+CONFIG_IRQ_TMR3=12
+CONFIG_IRQ_TMR4=12
+CONFIG_IRQ_TMR5=12
+CONFIG_IRQ_TMR6=12
+CONFIG_IRQ_TMR7=12
+CONFIG_IRQ_PORTG_INTA=12
+CONFIG_IRQ_PORTG_INTB=12
+CONFIG_IRQ_MEM_DMA0=13
+CONFIG_IRQ_MEM_DMA1=13
+CONFIG_IRQ_WATCH=13
+CONFIG_IRQ_PORTF_INTA=13
+CONFIG_IRQ_PORTF_INTB=13
+CONFIG_IRQ_SPI_ERROR=7
+CONFIG_IRQ_NFC_ERROR=7
+CONFIG_IRQ_HDMA_ERROR=7
+CONFIG_IRQ_HDMA=7
+CONFIG_IRQ_USB_EINT=10
+CONFIG_IRQ_USB_INT0=11
+CONFIG_IRQ_USB_INT1=11
+CONFIG_IRQ_USB_INT2=11
+CONFIG_IRQ_USB_DMA=11
+
+#
+# Board customizations
+#
+# CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000
+
+#
+# Clock/PLL Setup
+#
+CONFIG_CLKIN_HZ=25000000
+# CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=512
+CONFIG_MAX_VCO_HZ=600000000
+CONFIG_MIN_VCO_HZ=50000000
+CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MIN_SCLK_HZ=27000000
+
+#
+# Kernel Timer/Scheduler
+#
+# CONFIG_HZ_100 is not set
+CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+# CONFIG_TICK_ONESHOT is not set
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+
+#
+# Misc
+#
+CONFIG_BFIN_SCRATCH_REG_RETN=y
+# CONFIG_BFIN_SCRATCH_REG_RETE is not set
+# CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
+
+#
+# Blackfin Kernel Optimizations
+#
+
+#
+# Memory Optimizations
+#
+CONFIG_I_ENTRY_L1=y
+CONFIG_EXCPT_IRQ_SYSC_L1=y
+CONFIG_DO_IRQ_L1=y
+CONFIG_CORE_TIMER_IRQ_L1=y
+CONFIG_IDLE_L1=y
+# CONFIG_SCHEDULE_L1 is not set
+CONFIG_ARITHMETIC_OPS_L1=y
+CONFIG_ACCESS_OK_L1=y
+# CONFIG_MEMSET_L1 is not set
+# CONFIG_MEMCPY_L1 is not set
+# CONFIG_SYS_BFIN_SPINLOCK_L1 is not set
+# CONFIG_IP_CHECKSUM_L1 is not set
+CONFIG_CACHELINE_ALIGNED_L1=y
+# CONFIG_SYSCALL_TAB_L1 is not set
+# CONFIG_CPLB_SWITCH_TAB_L1 is not set
+CONFIG_RAMKERNEL=y
+# CONFIG_ROMKERNEL is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_VIRT_TO_BUS=y
+CONFIG_BFIN_GPTIMERS=y
+CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
+# CONFIG_DMA_UNCACHED_2M is not set
+CONFIG_DMA_UNCACHED_1M=y
+# CONFIG_DMA_UNCACHED_NONE is not set
+
+#
+# Cache Support
+#
+CONFIG_BFIN_ICACHE=y
+CONFIG_BFIN_DCACHE=y
+# CONFIG_BFIN_DCACHE_BANKA is not set
+# CONFIG_BFIN_ICACHE_LOCK is not set
+# CONFIG_BFIN_WB is not set
+CONFIG_BFIN_WT=y
+# CONFIG_MPU is not set
+
+#
+# Asynchonous Memory Configuration
+#
+
+#
+# EBIU_AMGCTL Global Control
+#
+CONFIG_C_AMCKEN=y
+CONFIG_C_CDPRIO=y
+# CONFIG_C_AMBEN is not set
+# CONFIG_C_AMBEN_B0 is not set
+# CONFIG_C_AMBEN_B0_B1 is not set
+# CONFIG_C_AMBEN_B0_B1_B2 is not set
+CONFIG_C_AMBEN_ALL=y
+
+#
+# EBIU_AMBCTL Control
+#
+CONFIG_BANK_0=0x7BB0
+CONFIG_BANK_1=0x5554
+CONFIG_BANK_2=0x7BB0
+CONFIG_BANK_3=0xFFC0
+
+#
+# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
+#
+# CONFIG_PCI is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+# CONFIG_PCCARD is not set
+
+#
+# Executable file formats
+#
+CONFIG_BINFMT_ELF_FDPIC=y
+CONFIG_BINFMT_FLAT=y
+CONFIG_BINFMT_ZFLAT=y
+# CONFIG_BINFMT_SHARED_FLAT is not set
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Power management options
+#
+# CONFIG_PM is not set
+CONFIG_SUSPEND_UP_POSSIBLE=y
+# CONFIG_PM_BFIN_SLEEP_DEEPER is not set
+# CONFIG_PM_BFIN_SLEEP is not set
+# CONFIG_PM_WAKEUP_BY_GPIO is not set
+
+#
+# CPU Frequency scaling
+#
+# CONFIG_CPU_FREQ is not set
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+# CONFIG_IP_PNP_DHCP is not set
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETLABEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
+# CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_FW_LOADER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_REDBOOT_PARTS is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=y
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+# CONFIG_MTD_CFI is not set
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_GEN_PROBE=m
+# CONFIG_MTD_CFI_ADV_OPTIONS is not set
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+# CONFIG_MTD_CFI_AMDSTD is not set
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_RAM=y
+CONFIG_MTD_ROM=m
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_UCLINUX is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_DATAFLASH is not set
+# CONFIG_MTD_M25P80 is not set
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+# CONFIG_PARPORT is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+# CONFIG_BLK_DEV_UB is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_MISC_DEVICES is not set
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+# CONFIG_MD is not set
+CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+CONFIG_PHYLIB=y
+
+#
+# MII PHY device drivers
+#
+# CONFIG_MARVELL_PHY is not set
+# CONFIG_DAVICOM_PHY is not set
+# CONFIG_QSEMI_PHY is not set
+# CONFIG_LXT_PHY is not set
+# CONFIG_CICADA_PHY is not set
+# CONFIG_VITESSE_PHY is not set
+# CONFIG_SMSC_PHY is not set
+# CONFIG_BROADCOM_PHY is not set
+# CONFIG_ICPLUS_PHY is not set
+# CONFIG_FIXED_PHY is not set
+# CONFIG_MDIO_BITBANG is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+CONFIG_BFIN_MAC=y
+CONFIG_BFIN_MAC_USE_L1=y
+CONFIG_BFIN_TX_DESC_NUM=10
+CONFIG_BFIN_RX_DESC_NUM=20
+CONFIG_BFIN_MAC_RMII=y
+# CONFIG_SMC91X is not set
+# CONFIG_SMSC911X is not set
+# CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+
+#
+# USB Network Adapters
+#
+# CONFIG_USB_CATC is not set
+# CONFIG_USB_KAWETH is not set
+# CONFIG_USB_PEGASUS is not set
+# CONFIG_USB_RTL8150 is not set
+# CONFIG_USB_USBNET is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_ISDN is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+# CONFIG_INPUT is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_AD9960 is not set
+# CONFIG_SPI_ADC_BF533 is not set
+# CONFIG_BF5xx_PPIFCD is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
+# CONFIG_BF5xx_PPI is not set
+CONFIG_BFIN_OTP=y
+# CONFIG_BFIN_OTP_WRITE_ENABLE is not set
+# CONFIG_BFIN_SPORT is not set
+# CONFIG_BFIN_TIMER_LATENCY is not set
+# CONFIG_TWI_LCD is not set
+CONFIG_SIMPLE_GPIO=m
+# CONFIG_VT is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_BFIN=y
+CONFIG_SERIAL_BFIN_CONSOLE=y
+CONFIG_SERIAL_BFIN_DMA=y
+# CONFIG_SERIAL_BFIN_PIO is not set
+CONFIG_SERIAL_BFIN_UART0=y
+# CONFIG_BFIN_UART0_CTSRTS is not set
+CONFIG_SERIAL_BFIN_UART1=y
+# CONFIG_BFIN_UART1_CTSRTS is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_BFIN_SPORT is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_LEGACY_PTYS is not set
+
+#
+# CAN, the car bus and industrial fieldbus
+#
+# CONFIG_CAN4LINUX is not set
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_HW_RANDOM=y
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+CONFIG_I2C=y
+CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_CHARDEV=m
+
+#
+# I2C Algorithms
+#
+# CONFIG_I2C_ALGOBIT is not set
+# CONFIG_I2C_ALGOPCF is not set
+# CONFIG_I2C_ALGOPCA is not set
+
+#
+# I2C Hardware Bus support
+#
+CONFIG_I2C_BLACKFIN_TWI=m
+CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
+# CONFIG_I2C_GPIO is not set
+# CONFIG_I2C_OCORES is not set
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
+# CONFIG_I2C_STUB is not set
+# CONFIG_I2C_TINY_USB is not set
+
+#
+# Miscellaneous I2C Chip support
+#
+# CONFIG_SENSORS_DS1337 is not set
+# CONFIG_SENSORS_DS1374 is not set
+# CONFIG_DS1682 is not set
+# CONFIG_SENSORS_AD5252 is not set
+# CONFIG_SENSORS_EEPROM is not set
+# CONFIG_SENSORS_PCF8574 is not set
+# CONFIG_SENSORS_PCF8575 is not set
+# CONFIG_SENSORS_PCA9539 is not set
+# CONFIG_SENSORS_PCF8591 is not set
+# CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+
+#
+# SPI support
+#
+CONFIG_SPI=y
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+CONFIG_SPI_BFIN=y
+# CONFIG_SPI_BITBANG is not set
+
+#
+# SPI Protocol Masters
+#
+# CONFIG_SPI_AT25 is not set
+# CONFIG_SPI_SPIDEV is not set
+# CONFIG_SPI_TLE62X0 is not set
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_AD7418 is not set
+# CONFIG_SENSORS_ADM1021 is not set
+# CONFIG_SENSORS_ADM1025 is not set
+# CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
+# CONFIG_SENSORS_ADM1031 is not set
+# CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7470 is not set
+# CONFIG_SENSORS_ATXP1 is not set
+# CONFIG_SENSORS_DS1621 is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
+# CONFIG_SENSORS_GL518SM is not set
+# CONFIG_SENSORS_GL520SM is not set
+# CONFIG_SENSORS_IT87 is not set
+# CONFIG_SENSORS_LM63 is not set
+# CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_LM75 is not set
+# CONFIG_SENSORS_LM77 is not set
+# CONFIG_SENSORS_LM78 is not set
+# CONFIG_SENSORS_LM80 is not set
+# CONFIG_SENSORS_LM83 is not set
+# CONFIG_SENSORS_LM85 is not set
+# CONFIG_SENSORS_LM87 is not set
+# CONFIG_SENSORS_LM90 is not set
+# CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
+# CONFIG_SENSORS_MAX1619 is not set
+# CONFIG_SENSORS_MAX6650 is not set
+# CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_DME1737 is not set
+# CONFIG_SENSORS_SMSC47M1 is not set
+# CONFIG_SENSORS_SMSC47M192 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_THMC50 is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_SENSORS_W83781D is not set
+# CONFIG_SENSORS_W83791D is not set
+# CONFIG_SENSORS_W83792D is not set
+# CONFIG_SENSORS_W83793 is not set
+# CONFIG_SENSORS_W83L785TS is not set
+# CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# USB-based Watchdog Cards
+#
+# CONFIG_USBPCWATCHDOG is not set
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
+# Multimedia devices
+#
+# CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+# CONFIG_DAB is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Sound
+#
+# CONFIG_SOUND is not set
+CONFIG_USB_SUPPORT=y
+CONFIG_USB_ARCH_HAS_HCD=y
+# CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+CONFIG_USB=y
+# CONFIG_USB_DEBUG is not set
+
+#
+# Miscellaneous USB options
+#
+# CONFIG_USB_DEVICEFS is not set
+CONFIG_USB_DEVICE_CLASS=y
+# CONFIG_USB_DYNAMIC_MINORS is not set
+# CONFIG_USB_OTG is not set
+# CONFIG_USB_OTG_WHITELIST is not set
+CONFIG_USB_OTG_BLACKLIST_HUB=y
+
+#
+# USB Host Controller Drivers
+#
+# CONFIG_USB_ISP116X_HCD is not set
+# CONFIG_USB_ISP1362_HCD is not set
+# CONFIG_USB_ISP1760_HCD is not set
+# CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
+CONFIG_USB_MUSB_HDRC=y
+CONFIG_USB_MUSB_SOC=y
+
+#
+# Blackfin high speed USB support
+#
+CONFIG_USB_MUSB_HOST=y
+# CONFIG_USB_MUSB_PERIPHERAL is not set
+# CONFIG_USB_MUSB_OTG is not set
+CONFIG_USB_MUSB_HDRC_HCD=y
+CONFIG_MUSB_PIO_ONLY=y
+CONFIG_USB_MUSB_LOGLEVEL=0
+
+#
+# USB Device Class drivers
+#
+# CONFIG_USB_ACM is not set
+# CONFIG_USB_PRINTER is not set
+
+#
+# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+#
+
+#
+# may also be needed; see USB_STORAGE Help for more information
+#
+# CONFIG_USB_LIBUSUAL is not set
+
+#
+# USB Imaging devices
+#
+# CONFIG_USB_MDC800 is not set
+CONFIG_USB_MON=y
+
+#
+# USB port drivers
+#
+
+#
+# USB Serial Converter support
+#
+# CONFIG_USB_SERIAL is not set
+
+#
+# USB Miscellaneous drivers
+#
+# CONFIG_USB_EMI62 is not set
+# CONFIG_USB_EMI26 is not set
+# CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_AUERSWALD is not set
+# CONFIG_USB_RIO500 is not set
+# CONFIG_USB_LEGOTOWER is not set
+# CONFIG_USB_LCD is not set
+# CONFIG_USB_BERRY_CHARGE is not set
+# CONFIG_USB_LED is not set
+# CONFIG_USB_CYPRESS_CY7C63 is not set
+# CONFIG_USB_CYTHERM is not set
+# CONFIG_USB_PHIDGET is not set
+# CONFIG_USB_IDMOUSE is not set
+# CONFIG_USB_FTDI_ELAN is not set
+# CONFIG_USB_APPLEDISPLAY is not set
+# CONFIG_USB_SISUSBVGA is not set
+# CONFIG_USB_LD is not set
+# CONFIG_USB_TRANCEVIBRATOR is not set
+# CONFIG_USB_IOWARRIOR is not set
+
+#
+# USB DSL modem support
+#
+
+#
+# USB Gadget Support
+#
+# CONFIG_USB_GADGET is not set
+# CONFIG_MMC is not set
+# CONFIG_NEW_LEDS is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+# CONFIG_RTC_DEBUG is not set
+
+#
+# RTC interfaces
+#
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+# CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
+# CONFIG_RTC_DRV_DS1672 is not set
+# CONFIG_RTC_DRV_MAX6900 is not set
+# CONFIG_RTC_DRV_RS5C372 is not set
+# CONFIG_RTC_DRV_ISL1208 is not set
+# CONFIG_RTC_DRV_X1205 is not set
+# CONFIG_RTC_DRV_PCF8563 is not set
+# CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set
+
+#
+# SPI RTC drivers
+#
+# CONFIG_RTC_DRV_RS5C348 is not set
+# CONFIG_RTC_DRV_MAX6902 is not set
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_BFIN=y
+
+#
+# Userspace I/O
+#
+# CONFIG_UIO is not set
+
+#
+# File systems
+#
+# CONFIG_EXT2_FS is not set
+# CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+# CONFIG_DNOTIFY is not set
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+# CONFIG_TMPFS is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+# CONFIG_YAFFS_FS is not set
+# CONFIG_JFFS2_FS is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=m
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=m
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=m
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+CONFIG_SMB_FS=m
+# CONFIG_SMB_NLS_DEFAULT is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+CONFIG_NLS=m
+CONFIG_NLS_DEFAULT="iso8859-1"
+# CONFIG_NLS_CODEPAGE_437 is not set
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+# CONFIG_NLS_CODEPAGE_850 is not set
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+# CONFIG_NLS_ASCII is not set
+# CONFIG_NLS_ISO8859_1 is not set
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+# CONFIG_NLS_ISO8859_15 is not set
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+# CONFIG_NLS_UTF8 is not set
+# CONFIG_DLM is not set
+# CONFIG_INSTRUMENTATION is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
+CONFIG_DEBUG_MMRS=y
+CONFIG_DEBUG_HUNT_FOR_ZERO=y
+CONFIG_DEBUG_BFIN_HWTRACE_ON=y
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_ONE is not set
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_TWO is not set
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION=0
+# CONFIG_DEBUG_BFIN_HWTRACE_EXPAND is not set
+# CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
+CONFIG_EARLY_PRINTK=y
+# CONFIG_CPLB_INFO is not set
+CONFIG_ACCESS_CHECK=y
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+CONFIG_SECURITY=y
+# CONFIG_SECURITY_NETWORK is not set
+# CONFIG_SECURITY_CAPABILITIES is not set
+# CONFIG_SECURITY_ROOTPLUG is not set
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+CONFIG_CRC_CCITT=m
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/blackfin/configs/CM-BF533_defconfig
b/arch/blackfin/configs/CM-BF533_defconfig
index 560890f..972d15f 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -39,7 +39,8 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_TASKSTATS is not set
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
@@ -291,7 +292,7 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xFFC3
+CONFIG_BANK_3=0xFFC2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
@@ -617,8 +618,7 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
 CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_LEGACY_PTYS is not set

 #
 # CAN, the car bus and industrial fieldbus
@@ -866,11 +866,11 @@ CONFIG_MSDOS_PARTITION=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
+CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_DEBUG_MMRS is not set
+CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
 CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig
b/arch/blackfin/configs/CM-BF537E_defconfig
index 9f66d2d..199de5e 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -39,7 +39,8 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_TASKSTATS is not set
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
@@ -299,7 +300,7 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xFFC3
+CONFIG_BANK_3=0xFFC2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
@@ -645,8 +646,7 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
 CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_LEGACY_PTYS is not set

 #
 # CAN, the car bus and industrial fieldbus
@@ -894,12 +894,12 @@ CONFIG_MSDOS_PARTITION=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
+CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_DEBUG_MMRS is not set
-# CONFIG_DEBUG_HUNT_FOR_ZERO is not set
+CONFIG_DEBUG_MMRS=y
+CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
 CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
 # CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_ONE is not set
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig
b/arch/blackfin/configs/CM-BF537U_defconfig
index 2694d06..f49e8b3 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -39,7 +39,8 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_TASKSTATS is not set
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
@@ -298,8 +299,8 @@ CONFIG_C_AMBEN_ALL=y
 #
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
-CONFIG_BANK_2=0xFFC3
-CONFIG_BANK_3=0xFFC3
+CONFIG_BANK_2=0xFFC2
+CONFIG_BANK_3=0xFFC2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
@@ -628,8 +629,7 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
 CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_LEGACY_PTYS is not set

 #
 # CAN, the car bus and industrial fieldbus
@@ -894,12 +894,12 @@ CONFIG_MSDOS_PARTITION=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
+CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_DEBUG_MMRS is not set
-# CONFIG_DEBUG_HUNT_FOR_ZERO is not set
+CONFIG_DEBUG_MMRS=y
+CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
 CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
 # CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_ONE is not set
diff --git a/arch/blackfin/configs/CM-BF548_defconfig
b/arch/blackfin/configs/CM-BF548_defconfig
index 9020725..59d75c9 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -363,7 +363,7 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x5554
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0x99B3
+CONFIG_BANK_3=0x99B2
 CONFIG_EBIU_MBSCTLVAL=0x0
 CONFIG_EBIU_MODEVAL=0x1
 CONFIG_EBIU_FCTLVAL=0x6
@@ -744,8 +744,8 @@ CONFIG_BFIN_OTP=y
 #
 CONFIG_SERIAL_BFIN=y
 CONFIG_SERIAL_BFIN_CONSOLE=y
-# CONFIG_SERIAL_BFIN_DMA is not set
-CONFIG_SERIAL_BFIN_PIO=y
+CONFIG_SERIAL_BFIN_DMA=y
+# CONFIG_SERIAL_BFIN_PIO is not set
 # CONFIG_SERIAL_BFIN_UART0 is not set
 CONFIG_SERIAL_BFIN_UART1=y
 # CONFIG_BFIN_UART1_CTSRTS is not set
@@ -1332,7 +1332,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_SAMPLES is not set
-# CONFIG_DEBUG_MMRS is not set
+CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
 CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
diff --git a/arch/blackfin/configs/CM-BF561_defconfig
b/arch/blackfin/configs/CM-BF561_defconfig
index daf0090..a6e2126 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -35,7 +35,8 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_USER_NS is not set
 # CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 CONFIG_FAIR_GROUP_SCHED=y
@@ -341,7 +342,7 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xFFC3
+CONFIG_BANK_3=0xFFC2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
@@ -631,8 +632,7 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
 CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_LEGACY_PTYS is not set

 #
 # CAN, the car bus and industrial fieldbus
@@ -830,12 +830,12 @@ CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
+CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_SAMPLES is not set
-# CONFIG_DEBUG_MMRS is not set
+CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
 CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
diff --git a/arch/blackfin/configs/PNAV-10_defconfig
b/arch/blackfin/configs/PNAV-10_defconfig
index 87622ad..39fd7a1 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -294,7 +294,7 @@ CONFIG_C_AMBEN_ALL=y
 CONFIG_BANK_0=0x7BB0
 CONFIG_BANK_1=0x33B0
 CONFIG_BANK_2=0x33B0
-CONFIG_BANK_3=0x99B3
+CONFIG_BANK_3=0x99B2

 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index 6140cd6..606adc7 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -18,6 +18,5 @@ endif
 obj-$(CONFIG_BFIN_GPTIMERS)          += gptimers.o
 obj-$(CONFIG_MODULES)                += module.o
 obj-$(CONFIG_BFIN_DMA_5XX)           += bfin_dma_5xx.o
-obj-$(CONFIG_DUAL_CORE_TEST_MODULE)  += dualcore_test.o
 obj-$(CONFIG_KGDB)                   += kgdb.o
 obj-$(CONFIG_EARLY_PRINTK)           += early_printk.o
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c
b/arch/blackfin/kernel/bfin_dma_5xx.c
index d54f190..ad0e758 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -472,6 +472,32 @@ unsigned long get_dma_curr_addr(unsigned int channel)
 }
 EXPORT_SYMBOL(get_dma_curr_addr);

+#ifdef CONFIG_PM
+int blackfin_dma_suspend(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_BLACKFIN_DMA_CHANNEL; i++) {
+		if (dma_ch[i].chan_status == DMA_CHANNEL_ENABLED) {
+			printk(KERN_ERR "DMA Channel %d failed to suspend\n", i);
+			return -EBUSY;
+		}
+
+		dma_ch[i].saved_peripheral_map = dma_ch[i].regs->peripheral_map;
+	}
+
+	return 0;
+}
+
+void blackfin_dma_resume(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_BLACKFIN_DMA_CHANNEL; i++)
+		dma_ch[i].regs->peripheral_map = dma_ch[i].saved_peripheral_map;
+}
+#endif
+
 static void *__dma_memcpy(void *dest, const void *src, size_t size)
 {
 	int direction;	/* 1 - address decrease, 0 - address increase */
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index b6d89d1..ecbd141 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -186,7 +186,10 @@ static struct str_ident {
 	char name[RESOURCE_LABEL_SIZE];
 } str_ident[MAX_RESOURCES];

-#if defined(CONFIG_PM) && !defined(CONFIG_BF54x)
+#if defined(CONFIG_PM)
+#if defined(CONFIG_BF54x)
+static struct gpio_port_s gpio_bank_saved[gpio_bank(MAX_BLACKFIN_GPIOS)];
+#else
 static unsigned short wakeup_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
 static unsigned char wakeup_flags_map[MAX_BLACKFIN_GPIOS];
 static struct gpio_port_s gpio_bank_saved[gpio_bank(MAX_BLACKFIN_GPIOS)];
@@ -206,7 +209,7 @@ static unsigned int
sic_iwr_irqs[gpio_bank(MAX_BLACKFIN_GPIOS)] = {IRQ_PORTF_INT
 #ifdef BF561_FAMILY
 static unsigned int sic_iwr_irqs[gpio_bank(MAX_BLACKFIN_GPIOS)] =
{IRQ_PROG0_INTB, IRQ_PROG1_INTB, IRQ_PROG2_INTB};
 #endif
-
+#endif
 #endif /* CONFIG_PM */

 #if defined(BF548_FAMILY)
@@ -667,7 +670,7 @@ static int bfin_gpio_wakeup_type(unsigned gpio,
unsigned char type)
 	return 0;
 }

-u32 bfin_pm_setup(void)
+u32 bfin_pm_standby_setup(void)
 {
 	u16 bank, mask, i, gpio;

@@ -679,7 +682,7 @@ u32 bfin_pm_setup(void)
 		gpio_bankb[bank]->maskb = 0;

 		if (mask) {
-#ifdef BF537_FAMILY
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
 			gpio_bank_saved[bank].fer   = *port_fer[bank];
 #endif
 			gpio_bank_saved[bank].inen  = gpio_bankb[bank]->inen;
@@ -715,7 +718,7 @@ u32 bfin_pm_setup(void)
 	return 0;
 }

-void bfin_pm_restore(void)
+void bfin_pm_standby_restore(void)
 {
 	u16 bank, mask, i;

@@ -724,7 +727,7 @@ void bfin_pm_restore(void)
 		bank = gpio_bank(i);

 		if (mask) {
-#ifdef BF537_FAMILY
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
 			*port_fer[bank]   	= gpio_bank_saved[bank].fer;
 #endif
 			gpio_bankb[bank]->inen  = gpio_bank_saved[bank].inen;
@@ -743,8 +746,111 @@ void bfin_pm_restore(void)
 	AWA_DUMMY_READ(maskb);
 }

+void bfin_gpio_pm_hibernate_suspend(void)
+{
+	int i, bank;
+
+	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE) {
+		bank = gpio_bank(i);
+
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
+			gpio_bank_saved[bank].fer   = *port_fer[bank];
+#ifdef BF527_FAMILY
+			gpio_bank_saved[bank].mux   = *port_mux[bank];
+#else
+			if (bank == 0)
+				gpio_bank_saved[bank].mux   = bfin_read_PORT_MUX();
+#endif
+#endif
+			gpio_bank_saved[bank].data  = gpio_bankb[bank]->data;
+			gpio_bank_saved[bank].inen  = gpio_bankb[bank]->inen;
+			gpio_bank_saved[bank].polar = gpio_bankb[bank]->polar;
+			gpio_bank_saved[bank].dir   = gpio_bankb[bank]->dir;
+			gpio_bank_saved[bank].edge  = gpio_bankb[bank]->edge;
+			gpio_bank_saved[bank].both  = gpio_bankb[bank]->both;
+			gpio_bank_saved[bank].maska  = gpio_bankb[bank]->maska;
+	}
+
+	AWA_DUMMY_READ(maska);
+}
+
+void bfin_gpio_pm_hibernate_restore(void)
+{
+	int i, bank;
+
+	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE) {
+			bank = gpio_bank(i);
+
+#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
+#ifdef BF527_FAMILY
+			*port_mux[bank] = gpio_bank_saved[bank].mux;
+#else
+			if (bank == 0)
+				bfin_write_PORT_MUX(gpio_bank_saved[bank].mux);
+#endif
+			*port_fer[bank]   	= gpio_bank_saved[bank].fer;
+#endif
+			gpio_bankb[bank]->inen  = gpio_bank_saved[bank].inen;
+			gpio_bankb[bank]->dir   = gpio_bank_saved[bank].dir;
+			gpio_bankb[bank]->polar = gpio_bank_saved[bank].polar;
+			gpio_bankb[bank]->edge  = gpio_bank_saved[bank].edge;
+			gpio_bankb[bank]->both  = gpio_bank_saved[bank].both;
+
+			gpio_bankb[bank]->data_set = gpio_bank_saved[bank].data
+							| gpio_bank_saved[bank].dir;
+
+			gpio_bankb[bank]->maska = gpio_bank_saved[bank].maska;
+	}
+	AWA_DUMMY_READ(maska);
+}
+
+
 #endif
 #else /* BF548_FAMILY */
+#ifdef CONFIG_PM
+
+u32 bfin_pm_standby_setup(void)
+{
+	return 0;
+}
+
+void bfin_pm_standby_restore(void)
+{
+
+}
+
+void bfin_gpio_pm_hibernate_suspend(void)
+{
+	int i, bank;
+
+	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE) {
+		bank = gpio_bank(i);
+
+			gpio_bank_saved[bank].fer  = gpio_array[bank]->port_fer;
+			gpio_bank_saved[bank].mux  = gpio_array[bank]->port_mux;
+			gpio_bank_saved[bank].data  = gpio_array[bank]->port_data;
+			gpio_bank_saved[bank].data  = gpio_array[bank]->port_data;
+			gpio_bank_saved[bank].inen  = gpio_array[bank]->port_inen;
+			gpio_bank_saved[bank].dir   = gpio_array[bank]->port_dir_set;
+	}
+}
+
+void bfin_gpio_pm_hibernate_restore(void)
+{
+	int i, bank;
+
+	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE) {
+			bank = gpio_bank(i);
+
+			gpio_array[bank]->port_mux  = gpio_bank_saved[bank].mux;
+			gpio_array[bank]->port_fer  = gpio_bank_saved[bank].fer;
+			gpio_array[bank]->port_inen  = gpio_bank_saved[bank].inen;
+			gpio_array[bank]->port_dir_set   = gpio_bank_saved[bank].dir;
+			gpio_array[bank]->port_set = gpio_bank_saved[bank].data
+							| gpio_bank_saved[bank].dir;
+	}
+}
+#endif

 unsigned short get_gpio_dir(unsigned gpio)
 {
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbhdlr.S
b/arch/blackfin/kernel/cplb-nompu/cplbhdlr.S
index 2788532..ecbabc0 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbhdlr.S
+++ b/arch/blackfin/kernel/cplb-nompu/cplbhdlr.S
@@ -125,6 +125,6 @@ ENTRY(__cplb_hdr)
 	SP += -12;
 	call _panic_cplb_error;
 	SP += 12;
-	JUMP _handle_bad_cplb;
+	JUMP.L _handle_bad_cplb;

 ENDPROC(__cplb_hdr)
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 6be0c50..224e7cc 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -26,11 +26,7 @@
 #include <asm/cplb.h>
 #include <asm/cplbinit.h>

-#ifdef CONFIG_MAX_MEM_SIZE
-# define CPLB_MEM CONFIG_MAX_MEM_SIZE
-#else
-# define CPLB_MEM CONFIG_MEM_SIZE
-#endif
+#define CPLB_MEM CONFIG_MAX_MEM_SIZE

 /*
 * Number of required data CPLB switchtable entries
diff --git a/arch/blackfin/kernel/dualcore_test.c
b/arch/blackfin/kernel/dualcore_test.c
deleted file mode 100644
index 0fcba74..0000000
--- a/arch/blackfin/kernel/dualcore_test.c
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- * File:         arch/blackfin/kernel/dualcore_test.c
- * Based on:
- * Author:
- *
- * Created:
- * Description:  Small test code for CoreB on a BF561
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-
-static int *testarg = (int *)0xfeb00000;
-
-static int test_init(void)
-{
-	*testarg = 1;
-	printk(KERN_INFO "Dual core test module inserted: set testarg =
[%d]\n @ [%p]\n",
-	       *testarg, testarg);
-	return 0;
-}
-
-static void test_exit(void)
-{
-	printk(KERN_INFO "Dual core test module removed: testarg = [%d]\n", *testarg);
-}
-
-module_init(test_init);
-module_exit(test_exit);
diff --git a/arch/blackfin/kernel/entry.S b/arch/blackfin/kernel/entry.S
index 65f4e67..31bd9bf 100644
--- a/arch/blackfin/kernel/entry.S
+++ b/arch/blackfin/kernel/entry.S
@@ -64,6 +64,11 @@ ENDPROC(_ret_from_fork)

 ENTRY(_sys_fork)
 	r0 = -EINVAL;
+#if (ANOMALY_05000371)
+	nop;
+	nop;
+	nop;
+#endif
 	rts;
 ENDPROC(_sys_fork)

diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index 14a4284..e1bebc8 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -173,7 +173,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 	for (s = sechdrs; s < sechdrs_end; ++s) {
 		if ((strcmp(".l1.text", secstrings + s->sh_name) == 0) ||
 		    ((strcmp(".text", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & FLG_CODE_IN_L1) && (s->sh_size > 0))) {
+		     (hdr->e_flags & EF_BFIN_CODE_IN_L1) && (s->sh_size > 0))) {
 			dest = l1_inst_sram_alloc(s->sh_size);
 			mod->arch.text_l1 = dest;
 			if (dest == NULL) {
@@ -188,7 +188,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 		}
 		if ((strcmp(".l1.data", secstrings + s->sh_name) == 0) ||
 		    ((strcmp(".data", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
+		     (hdr->e_flags & EF_BFIN_DATA_IN_L1) && (s->sh_size > 0))) {
 			dest = l1_data_sram_alloc(s->sh_size);
 			mod->arch.data_a_l1 = dest;
 			if (dest == NULL) {
@@ -203,7 +203,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 		}
 		if (strcmp(".l1.bss", secstrings + s->sh_name) == 0 ||
 		    ((strcmp(".bss", secstrings + s->sh_name) == 0) &&
-		     (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
+		     (hdr->e_flags & EF_BFIN_DATA_IN_L1) && (s->sh_size > 0))) {
 			dest = l1_data_sram_alloc(s->sh_size);
 			mod->arch.bss_a_l1 = dest;
 			if (dest == NULL) {
@@ -242,6 +242,51 @@ module_frob_arch_sections(Elf_Ehdr * hdr,
Elf_Shdr * sechdrs,
 			s->sh_flags &= ~SHF_ALLOC;
 			s->sh_addr = (unsigned long)dest;
 		}
+		if ((strcmp(".l2.text", secstrings + s->sh_name) == 0) ||
+		    ((strcmp(".text", secstrings + s->sh_name) == 0) &&
+		     (hdr->e_flags & EF_BFIN_CODE_IN_L2) && (s->sh_size > 0))) {
+			dest = l2_sram_alloc(s->sh_size);
+			mod->arch.text_l2 = dest;
+			if (dest == NULL) {
+				printk(KERN_ERR
+				       "module %s: L2 SRAM allocation failed\n",
+				       mod->name);
+				return -1;
+			}
+			memcpy(dest, (void *)s->sh_addr, s->sh_size);
+			s->sh_flags &= ~SHF_ALLOC;
+			s->sh_addr = (unsigned long)dest;
+		}
+		if ((strcmp(".l2.data", secstrings + s->sh_name) == 0) ||
+		    ((strcmp(".data", secstrings + s->sh_name) == 0) &&
+		     (hdr->e_flags & EF_BFIN_DATA_IN_L2) && (s->sh_size > 0))) {
+			dest = l2_sram_alloc(s->sh_size);
+			mod->arch.data_l2 = dest;
+			if (dest == NULL) {
+				printk(KERN_ERR
+					"module %s: L2 SRAM allocation failed\n",
+					mod->name);
+				return -1;
+			}
+			memcpy(dest, (void *)s->sh_addr, s->sh_size);
+			s->sh_flags &= ~SHF_ALLOC;
+			s->sh_addr = (unsigned long)dest;
+		}
+		if (strcmp(".l2.bss", secstrings + s->sh_name) == 0 ||
+		    ((strcmp(".bss", secstrings + s->sh_name) == 0) &&
+		     (hdr->e_flags & EF_BFIN_DATA_IN_L2) && (s->sh_size > 0))) {
+			dest = l2_sram_alloc(s->sh_size);
+			mod->arch.bss_l2 = dest;
+			if (dest == NULL) {
+				printk(KERN_ERR
+					"module %s: L2 SRAM allocation failed\n",
+					mod->name);
+				return -1;
+			}
+			memset(dest, 0, s->sh_size);
+			s->sh_flags &= ~SHF_ALLOC;
+			s->sh_addr = (unsigned long)dest;
+		}
 	}
 	return 0;
 }
@@ -411,9 +456,10 @@ module_finalize(const Elf_Ehdr * hdr,
 			continue;

 		if ((sechdrs[i].sh_type == SHT_RELA) &&
-		    ((strcmp(".rela.l1.text", secstrings + sechdrs[i].sh_name) == 0) ||
+		    ((strcmp(".rela.l2.text", secstrings + sechdrs[i].sh_name) == 0) ||
+		    (strcmp(".rela.l1.text", secstrings + sechdrs[i].sh_name) == 0) ||
 		    ((strcmp(".rela.text", secstrings + sechdrs[i].sh_name) == 0) &&
-			 (hdr->e_flags & FLG_CODE_IN_L1)))) {
+			(hdr->e_flags & (EF_BFIN_CODE_IN_L1|EF_BFIN_CODE_IN_L2))))) {
 			apply_relocate_add((Elf_Shdr *) sechdrs, strtab,
 					   symindex, i, mod);
 		}
@@ -423,14 +469,12 @@ module_finalize(const Elf_Ehdr * hdr,

 void module_arch_cleanup(struct module *mod)
 {
-	if (mod->arch.text_l1)
-		l1_inst_sram_free((void *)mod->arch.text_l1);
-	if (mod->arch.data_a_l1)
-		l1_data_sram_free((void *)mod->arch.data_a_l1);
-	if (mod->arch.bss_a_l1)
-		l1_data_sram_free((void *)mod->arch.bss_a_l1);
-	if (mod->arch.data_b_l1)
-		l1_data_B_sram_free((void *)mod->arch.data_b_l1);
-	if (mod->arch.bss_b_l1)
-		l1_data_B_sram_free((void *)mod->arch.bss_b_l1);
+	l1_inst_sram_free(mod->arch.text_l1);
+	l1_data_A_sram_free(mod->arch.data_a_l1);
+	l1_data_A_sram_free(mod->arch.bss_a_l1);
+	l1_data_B_sram_free(mod->arch.data_b_l1);
+	l1_data_B_sram_free(mod->arch.bss_b_l1);
+	l2_sram_free(mod->arch.text_l2);
+	l2_sram_free(mod->arch.data_l2);
+	l2_sram_free(mod->arch.bss_l2);
 }
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index f51ab08..bf1a51d 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -220,6 +220,20 @@ long arch_ptrace(struct task_struct *child, long
request, long addr, long data)
 				copied = sizeof(tmp);
 			} else
 #endif
+#if L1_DATA_A_LENGTH != 0
+			if (addr + add >= L1_DATA_A_START
+			    && addr + add + sizeof(tmp) <= L1_DATA_A_START + L1_DATA_A_LENGTH) {
+				memcpy(&tmp, (const void *)(addr + add), sizeof(tmp));
+				copied = sizeof(tmp);
+			} else
+#endif
+#if L1_DATA_B_LENGTH != 0
+			if (addr + add >= L1_DATA_B_START
+			    && addr + add + sizeof(tmp) <= L1_DATA_B_START + L1_DATA_B_LENGTH) {
+				memcpy(&tmp, (const void *)(addr + add), sizeof(tmp));
+				copied = sizeof(tmp);
+			} else
+#endif
 			if (addr + add >= FIXED_CODE_START
 			    && addr + add + sizeof(tmp) <= FIXED_CODE_END) {
 				memcpy(&tmp, (const void *)(addr + add), sizeof(tmp));
@@ -290,6 +304,20 @@ long arch_ptrace(struct task_struct *child, long
request, long addr, long data)
 				copied = sizeof(data);
 			} else
 #endif
+#if L1_DATA_A_LENGTH != 0
+			if (addr + add >= L1_DATA_A_START
+			    && addr + add + sizeof(data) <= L1_DATA_A_START + L1_DATA_A_LENGTH) {
+				memcpy((void *)(addr + add), &data, sizeof(data));
+				copied = sizeof(data);
+			} else
+#endif
+#if L1_DATA_B_LENGTH != 0
+			if (addr + add >= L1_DATA_B_START
+			    && addr + add + sizeof(data) <= L1_DATA_B_START + L1_DATA_B_LENGTH) {
+				memcpy((void *)(addr + add), &data, sizeof(data));
+				copied = sizeof(data);
+			} else
+#endif
 			if (addr + add >= FIXED_CODE_START
 			    && addr + add + sizeof(data) <= FIXED_CODE_END) {
 				memcpy((void *)(addr + add), &data, sizeof(data));
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 8efea00..8671d1d 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -104,6 +104,7 @@ void __init bf53x_relocate_l1_mem(void)
 	unsigned long l1_code_length;
 	unsigned long l1_data_a_length;
 	unsigned long l1_data_b_length;
+	unsigned long l2_length;

 	l1_code_length = _etext_l1 - _stext_l1;
 	if (l1_code_length > L1_CODE_LENGTH)
@@ -129,6 +130,15 @@ void __init bf53x_relocate_l1_mem(void)
 	/* Copy _sdata_b_l1 to _ebss_b_l1 to L1 data bank B SRAM */
 	dma_memcpy(_sdata_b_l1, _l1_lma_start + l1_code_length +
 			l1_data_a_length, l1_data_b_length);
+
+#ifdef L2_LENGTH
+	l2_length = _ebss_l2 - _stext_l2;
+	if (l2_length > L2_LENGTH)
+		panic("L2 SRAM Overflow\n");
+
+	/* Copy _stext_l2 to _edata_l2 to L2 SRAM */
+	dma_memcpy(_stext_l2, _l2_lma_start, l2_length);
+#endif
 }

 /* add_memory_region to memmap */
@@ -664,11 +674,8 @@ static __init void setup_bootmem_allocator(void)
 })
 static inline int __init get_mem_size(void)
 {
-#ifdef CONFIG_MEM_SIZE
-	return CONFIG_MEM_SIZE;
-#else
-# if defined(EBIU_SDBCTL)
-#  if defined(BF561_FAMILY)
+#if defined(EBIU_SDBCTL)
+# if defined(BF561_FAMILY)
 	int ret = 0;
 	u32 sdbctl = bfin_read_EBIU_SDBCTL();
 	ret += EBSZ_TO_MEG(sdbctl >>  0);
@@ -676,10 +683,10 @@ static inline int __init get_mem_size(void)
 	ret += EBSZ_TO_MEG(sdbctl >> 16);
 	ret += EBSZ_TO_MEG(sdbctl >> 24);
 	return ret;
-#  else
+# else
 	return EBSZ_TO_MEG(bfin_read_EBIU_SDBCTL());
-#  endif
-# elif defined(EBIU_DDRCTL1)
+# endif
+#elif defined(EBIU_DDRCTL1)
 	u32 ddrctl = bfin_read_EBIU_DDRCTL1();
 	int ret = 0;
 	switch (ddrctl & 0xc0000) {
@@ -694,7 +701,6 @@ static inline int __init get_mem_size(void)
 		case DEVWD_16: break;
 	}
 	return ret;
-# endif
 #endif
 	BUG();
 }
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index f061f51..876bf24 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -69,8 +69,6 @@ void __init trap_init(void)

 unsigned long saved_icplb_fault_addr, saved_dcplb_fault_addr;

-int kstack_depth_to_print = 48;
-
 static void decode_address(char *buf, unsigned long address)
 {
 	struct vm_list_struct *vml;
@@ -163,6 +161,9 @@ static void decode_address(char *buf, unsigned long address)
 				if (!in_atomic)
 					mmput(mm);

+				if (!strlen(buf))
+					sprintf(buf, "<0x%p> [ %s ] dynamic memory", (void *)address, name);
+
 				goto done;
 			}

@@ -173,7 +174,7 @@ static void decode_address(char *buf, unsigned long address)
 	}

 	/* we were unable to find this address anywhere */
-	sprintf(buf, "<0x%p> /* unknown address */", (void *)address);
+	sprintf(buf, "<0x%p> /* kernel dynamic memory */", (void *)address);

 done:
 	write_unlock_irqrestore(&tasklist_lock, flags);
@@ -494,7 +495,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	BUG_ON(sig == 0);

 	if (sig != SIGTRAP) {
-		unsigned long stack;
+		unsigned long *stack;
 		dump_bfin_process(fp);
 		dump_bfin_mem(fp);
 		show_regs(fp);
@@ -508,14 +509,23 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		else
 #endif
 			dump_bfin_trace_buffer();
-		show_stack(current, &stack);
+
 		if (oops_in_progress) {
+			/* Dump the current kernel stack */
+			printk(KERN_NOTICE "\n" KERN_NOTICE "Kernel Stack\n");
+			show_stack(current, NULL);
+
 			print_modules();
 #ifndef CONFIG_ACCESS_CHECK
 			printk(KERN_EMERG "Please turn on "
 			       "CONFIG_ACCESS_CHECK\n");
 #endif
 			panic("Kernel exception");
+		} else {
+			/* Dump the user space stack */
+			stack = (unsigned long *)rdusp();
+			printk(KERN_NOTICE "Userspace Stack\n");
+			show_stack(NULL, stack);
 		}
 	}

@@ -532,11 +542,71 @@ asmlinkage void trap_c(struct pt_regs *fp)

 #define EXPAND_LEN ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN) * 256 - 1)

+/*
+ * Similar to get_user, do some address checking, then dereference
+ * Return 0 on sucess, 1 on bad address
+ */
+bool get_instruction(unsigned short *val, unsigned short *address)
+{
+
+	unsigned long addr;
+
+	addr = (unsigned long)address;
+
+	/* Check for odd addresses */
+	if (addr & 0x1)
+		return 1;
+
+	/* Check that things do not wrap around */
+	if (address > (address + 2))
+		return 1;
+
+	/*
+	 * Since we are in exception context, we need to do a little address checking
+	 * We need to make sure we are only accessing valid memory, and
+	 * we don't read something in the async space that can hang forever
+	 */
+	if ((addr >= FIXED_CODE_START && (addr + 2) <= physical_mem_end) ||
+#ifdef L2_START
+	    (addr >= L2_START && (addr + 2) <= (L2_START + L2_LENGTH)) ||
+#endif
+	    (addr >= BOOT_ROM_START && (addr + 2) <= (BOOT_ROM_START +
BOOT_ROM_LENGTH)) ||
+#if L1_DATA_A_LENGTH != 0
+	    (addr >= L1_DATA_A_START && (addr + 2) <= (L1_DATA_A_START +
L1_DATA_A_LENGTH)) ||
+#endif
+#if L1_DATA_B_LENGTH != 0
+	    (addr >= L1_DATA_B_START && (addr + 2) <= (L1_DATA_B_START +
L1_DATA_B_LENGTH)) ||
+#endif
+	    (addr >= L1_SCRATCH_START && (addr + 2) <= (L1_SCRATCH_START +
L1_SCRATCH_LENGTH)) ||
+	    (!(bfin_read_EBIU_AMBCTL0() & B0RDYEN) &&
+	       addr >= ASYNC_BANK0_BASE && (addr + 2) <= (ASYNC_BANK0_BASE +
ASYNC_BANK0_SIZE)) ||
+	    (!(bfin_read_EBIU_AMBCTL0() & B1RDYEN) &&
+	       addr >= ASYNC_BANK1_BASE && (addr + 2) <= (ASYNC_BANK1_BASE +
ASYNC_BANK1_SIZE)) ||
+	    (!(bfin_read_EBIU_AMBCTL1() & B2RDYEN) &&
+	       addr >= ASYNC_BANK2_BASE && (addr + 2) <= (ASYNC_BANK2_BASE +
ASYNC_BANK1_SIZE)) ||
+	    (!(bfin_read_EBIU_AMBCTL1() & B3RDYEN) &&
+	      addr >= ASYNC_BANK3_BASE && (addr + 2) <= (ASYNC_BANK3_BASE +
ASYNC_BANK1_SIZE))) {
+		*val = *address;
+		return 0;
+	}
+
+#if L1_CODE_LENGTH != 0
+	if (addr >= L1_CODE_START && (addr + 2) <= (L1_CODE_START + L1_CODE_LENGTH)) {
+		dma_memcpy(val, address, 2);
+		return 0;
+	}
+#endif
+
+
+		return 1;
+}
+
 void dump_bfin_trace_buffer(void)
 {
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
 	int tflags, i = 0;
 	char buf[150];
+	unsigned short val = 0, *addr;
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
 	int j, index;
 #endif
@@ -549,8 +619,42 @@ void dump_bfin_trace_buffer(void)
 		for (; bfin_read_TBUFSTAT() & TBUFCNT; i++) {
 			decode_address(buf, (unsigned long)bfin_read_TBUF());
 			printk(KERN_NOTICE "%4i Target : %s\n", i, buf);
-			decode_address(buf, (unsigned long)bfin_read_TBUF());
-			printk(KERN_NOTICE "     Source : %s\n", buf);
+			addr = (unsigned short *)bfin_read_TBUF();
+			decode_address(buf, (unsigned long)addr);
+			printk(KERN_NOTICE "     Source : %s ", buf);
+			if (!get_instruction(&val, addr)) {
+				if (val == 0x0010)
+					printk("RTS");
+				else if (val == 0x0011)
+					printk("RTI");
+				else if (val == 0x0012)
+					printk("RTX");
+				else if (val >= 0x0050 && val <= 0x0057)
+					printk("JUMP (P%i)", val & 7);
+				else if (val >= 0x0060 && val <= 0x0067)
+					printk("CALL (P%i)", val & 7);
+				else if (val >= 0x0070 && val <= 0x0077)
+					printk("CALL (PC+P%i)", val & 7);
+				else if (val >= 0x0080 && val <= 0x0087)
+					printk("JUMP (PC+P%i)", val & 7);
+				else if ((val >= 0x1000 && val <= 0x13FF) ||
+				    (val >= 0x1800 && val <= 0x1BFF))
+					printk("IF !CC JUMP");
+				else if ((val >= 0x1400 && val <= 0x17ff) ||
+				    (val >= 0x1c00 && val <= 0x1fff))
+					printk("IF CC JUMP");
+				else if (val >= 0x2000 && val <= 0x2fff)
+					printk("JUMP.S");
+				else if (val >= 0xe080 && val <= 0xe0ff)
+					printk("LSETUP");
+				else if (val >= 0xe200 && val <= 0xe2ff)
+					printk("JUMP.L");
+				else if (val >= 0xe300 && val <= 0xe3ff)
+					printk("CALL pcrel");
+				else
+					printk("0x%04x", val);
+			}
+			printk("\n");
 		}
 	}

@@ -582,59 +686,151 @@ void dump_bfin_trace_buffer(void)
 }
 EXPORT_SYMBOL(dump_bfin_trace_buffer);

-static void show_trace(struct task_struct *tsk, unsigned long *sp)
+/*
+ * Checks to see if the address pointed to is either a
+ * 16-bit CALL instruction, or a 32-bit CALL instruction
+ */
+bool is_bfin_call(unsigned short *addr)
 {
-	unsigned long addr;
+	unsigned short opcode = 0, *ins_addr;
+	ins_addr = (unsigned short *)addr;

-	printk(KERN_NOTICE "\n" KERN_NOTICE "Call Trace:\n");
-
-	while (!kstack_end(sp)) {
-		addr = *sp++;
-		/*
-		 * If the address is either in the text segment of the
-		 * kernel, or in the region which contains vmalloc'ed
-		 * memory, it *may* be the address of a calling
-		 * routine; if so, print it so that someone tracing
-		 * down the cause of the crash will be able to figure
-		 * out the call path that was taken.
-		 */
-		if (kernel_text_address(addr))
-			print_ip_sym(addr);
-	}
+	if (get_instruction(&opcode, ins_addr))
+		return 0;

-	printk(KERN_NOTICE "\n");
-}
+	if ((opcode >= 0x0060 && opcode <= 0x0067) ||
+	    (opcode >= 0x0070 && opcode <= 0x0077))
+		return 1;
+
+	ins_addr--;
+	if (get_instruction(&opcode, ins_addr))
+		return 0;
+
+	if (opcode >= 0xE300 && opcode <= 0xE3FF)
+		return 1;

+	return 0;
+
+}
 void show_stack(struct task_struct *task, unsigned long *stack)
 {
-	unsigned long *endstack, addr;
-	int i;
+	unsigned int *addr, *endstack, *fp = 0, *frame;
+	unsigned short *ins_addr;
+	char buf[150];
+	unsigned int i, j, ret_addr, frame_no = 0;

-	/* Cannot call dump_bfin_trace_buffer() here as show_stack() is
-	 * called externally in some places in the kernel.
+	/*
+	 * If we have been passed a specific stack, use that one otherwise
+	 *    if we have been passed a task structure, use that, otherwise
+	 *    use the stack of where the variable "stack" exists
 	 */

-	if (!stack) {
-		if (task)
+	if (stack == NULL) {
+		if (task) {
+			/* We know this is a kernel stack, so this is the start/end */
 			stack = (unsigned long *)task->thread.ksp;
-		else
+			endstack = (unsigned int *)(((unsigned int)(stack) & ~(THREAD_SIZE
- 1)) + THREAD_SIZE);
+		} else {
+			/* print out the existing stack info */
 			stack = (unsigned long *)&stack;
+			endstack = (unsigned int *)PAGE_ALIGN((unsigned int)stack);
+		}
+	} else
+		endstack = (unsigned int *)PAGE_ALIGN((unsigned int)stack);
+
+	decode_address(buf, (unsigned int)stack);
+	printk(KERN_NOTICE "Stack info:\n" KERN_NOTICE " SP: [0x%p] %s\n",
stack, buf);
+	addr = (unsigned int *)((unsigned int)stack & ~0x3F);
+
+	/* First thing is to look for a frame pointer */
+	for (addr = (unsigned int *)((unsigned int)stack & ~0xF), i = 0;
+		addr < endstack; addr++, i++) {
+		if (*addr & 0x1)
+			continue;
+		ins_addr = (unsigned short *)*addr;
+		ins_addr--;
+		if (is_bfin_call(ins_addr))
+			fp = addr - 1;
+
+		if (fp) {
+			/* Let's check to see if it is a frame pointer */
+			while (fp >= (addr - 1) && fp < endstack && fp)
+				fp = (unsigned int *)*fp;
+			if (fp == 0 || fp == endstack) {
+				fp = addr - 1;
+				break;
+			}
+			fp = 0;
+		}
 	}
+	if (fp) {
+		frame = fp;
+		printk(" FP: (0x%p)\n", fp);
+	} else
+		frame = 0;

-	addr = (unsigned long)stack;
-	endstack = (unsigned long *)PAGE_ALIGN(addr);
+	/*
+	 * Now that we think we know where things are, we
+	 * walk the stack again, this time printing things out
+	 * incase there is no frame pointer, we still look for
+	 * valid return addresses
+	 */

-	printk(KERN_NOTICE "Stack from %08lx:", (unsigned long)stack);
-	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (stack + 1 > endstack)
-			break;
-		if (i % 8 == 0)
-			printk("\n" KERN_NOTICE "       ");
-		printk(" %08lx", *stack++);
+	/* First time print out data, next time, print out symbols */
+	for (j = 0; j <= 1; j++) {
+		if (j)
+			printk(KERN_NOTICE "Return addresses in stack:\n");
+		else
+			printk(KERN_NOTICE " Memory from 0x%08lx to %p", ((long unsigned
int)stack & ~0xF), endstack);
+
+		fp = frame;
+		frame_no = 0;
+
+		for (addr = (unsigned int *)((unsigned int)stack & ~0xF), i = 0;
+		     addr <= endstack; addr++, i++) {
+
+			ret_addr = 0;
+			if (!j && i % 8 == 0)
+				printk("\n" KERN_NOTICE);
+
+			/* if it is an odd address, or zero, just skip it */
+			if (*addr & 0x1 || !*addr)
+				goto print;
+
+			ins_addr = (unsigned short *)*addr;
+
+			/* Go back one instruction, and see if it is a CALL */
+			ins_addr--;
+			ret_addr = is_bfin_call(ins_addr);
+ print:
+			if (!j && stack == (unsigned long *)addr)
+				printk("[%08x]", *addr);
+			else if (ret_addr)
+				if (j) {
+					decode_address(buf, (unsigned int)*addr);
+					if (frame == addr) {
+						printk(KERN_NOTICE "   frame %2i : %s\n", frame_no, buf);
+						continue;
+					}
+					printk(KERN_NOTICE "    address : %s\n", buf);
+				} else
+					printk("<%08x>", *addr);
+			else if (fp == addr) {
+				if (j)
+					frame = addr+1;
+				else
+					printk("(%08x)", *addr);
+
+				fp = (unsigned int *)*addr;
+				frame_no++;
+
+			} else if (!j)
+				printk(" %08x ", *addr);
+		}
+		if (!j)
+			printk("\n");
 	}
-	printk("\n");

-	show_trace(task, stack);
 }

 void dump_stack(void)
@@ -715,19 +911,9 @@ void dump_bfin_mem(struct pt_regs *fp)
 		if (!((unsigned long)addr & 0xF))
 			printk("\n" KERN_NOTICE "0x%p: ", addr);

-		if (get_user(val, addr)) {
-			if (addr >= (unsigned short *)L1_CODE_START &&
-			    addr < (unsigned short *)(L1_CODE_START + L1_CODE_LENGTH)) {
-				dma_memcpy(&val, addr, sizeof(val));
-				sprintf(buf, "%04x", val);
-			} else if (addr >= (unsigned short *)FIXED_CODE_START &&
-				addr <= (unsigned short *)memory_start) {
-				val = bfin_read16(addr);
-				sprintf(buf, "%04x", val);
-			} else {
+		if (get_instruction(&val, addr)) {
 				val = 0;
 				sprintf(buf, "????");
-			}
 		} else
 			sprintf(buf, "%04x", val);

diff --git a/arch/blackfin/kernel/vmlinux.lds.S
b/arch/blackfin/kernel/vmlinux.lds.S
index 3ecc64c..0896e38 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -101,6 +101,11 @@ SECTIONS
 #if !L1_DATA_B_LENGTH
 		*(.l1.data.B)
 #endif
+#ifndef L2_LENGTH
+		. = ALIGN(32);
+		*(.data_l2.cacheline_aligned)
+		*(.l2.data)
+#endif

 		DATA_DATA
 		*(.data.*)
@@ -182,14 +187,13 @@ SECTIONS
 		*(.l1.data)
 		__edata_l1 = .;

-		. = ALIGN(4);
-		__sbss_l1 = .;
-		*(.l1.bss)
-
 		. = ALIGN(32);
 		*(.data_l1.cacheline_aligned)

 		. = ALIGN(4);
+		__sbss_l1 = .;
+		*(.l1.bss)
+		. = ALIGN(4);
 		__ebss_l1 = .;
 	}

@@ -203,11 +207,37 @@ SECTIONS
 		. = ALIGN(4);
 		__sbss_b_l1 = .;
 		*(.l1.bss.B)
-
 		. = ALIGN(4);
 		__ebss_b_l1 = .;
 	}

+#ifdef L2_LENGTH
+	__l2_lma_start = .;
+
+	.text_data_l2 L2_START : AT(LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1))
+	{
+		. = ALIGN(4);
+		__stext_l2 = .;
+		*(.l1.text)
+		. = ALIGN(4);
+		__etext_l2 = .;
+
+		. = ALIGN(4);
+		__sdata_l2 = .;
+		*(.l1.data)
+		__edata_l2 = .;
+
+		. = ALIGN(32);
+		*(.data_l2.cacheline_aligned)
+
+		. = ALIGN(4);
+		__sbss_l2 = .;
+		*(.l1.bss)
+		. = ALIGN(4);
+		__ebss_l2 = .;
+	}
+#endif
+
 	/* Force trailing alignment of our init section so that when we
 	 * free our init memory, we don't leave behind a partial page.
 	 */
diff --git a/arch/blackfin/mach-bf527/boards/Kconfig
b/arch/blackfin/mach-bf527/boards/Kconfig
index 6a570ad..8bf9e58 100644
--- a/arch/blackfin/mach-bf527/boards/Kconfig
+++ b/arch/blackfin/mach-bf527/boards/Kconfig
@@ -9,4 +9,9 @@ config BFIN527_EZKIT
 	help
 	  BF527-EZKIT-LITE board support.

+config BFIN527_BLUETECHNIX_CM
+	bool "Bluetechnix CM-BF527"
+	help
+	  CM-BF527 support for EVAL- and DEV-Board.
+
 endchoice
diff --git a/arch/blackfin/mach-bf527/boards/Makefile
b/arch/blackfin/mach-bf527/boards/Makefile
index 7277d35..7ba7d25 100644
--- a/arch/blackfin/mach-bf527/boards/Makefile
+++ b/arch/blackfin/mach-bf527/boards/Makefile
@@ -3,3 +3,4 @@
 #

 obj-$(CONFIG_BFIN527_EZKIT)            += ezkit.o
+obj-$(CONFIG_BFIN527_BLUETECHNIX_CM)   += cm_bf527.o
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c
b/arch/blackfin/mach-bf527/boards/cm_bf527.c
new file mode 100644
index 0000000..0b26ae2
--- /dev/null
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -0,0 +1,1011 @@
+/*
+ * File:         arch/blackfin/mach-bf527/boards/cm-bf527.c
+ * Based on:     arch/blackfin/mach-bf537/boards/stamp.c
+ * Author:       Aidan Williams <aidan@nicta.com.au>
+ *
+ * Created:
+ * Description:
+ *
+ * Modified:
+ *               Copyright 2005 National ICT Australia (NICTA)
+ *               Copyright 2004-2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+#include <linux/etherdevice.h>
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+#include <linux/usb/isp1362.h>
+#endif
+#include <linux/pata_platform.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/usb/sl811.h>
+#if defined(CONFIG_USB_MUSB_HDRC) || defined(CONFIG_USB_MUSB_HDRC_MODULE)
+#include <linux/usb/musb.h>
+#endif
+#include <asm/cplb.h>
+#include <asm/dma.h>
+#include <asm/bfin5xx_spi.h>
+#include <asm/reboot.h>
+#include <asm/nand.h>
+#include <asm/portmux.h>
+#include <asm/dpmc.h>
+#include <linux/spi/ad7877.h>
+
+/*
+ * Name the Board for the /proc/cpuinfo
+ */
+const char bfin_board_name[] = "Bluetechnix CM-BF527";
+
+/*
+ *  Driver needs to know address, irq and flag pin.
+ */
+
+#define ISP1761_BASE       0x203C0000
+#define ISP1761_IRQ        IRQ_PF7
+
+#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
+static struct resource bfin_isp1761_resources[] = {
+	[0] = {
+		.name	= "isp1761-regs",
+		.start  = ISP1761_BASE + 0x00000000,
+		.end    = ISP1761_BASE + 0x000fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = ISP1761_IRQ,
+		.end    = ISP1761_IRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_isp1761_device = {
+	.name           = "isp1761",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(bfin_isp1761_resources),
+	.resource       = bfin_isp1761_resources,
+};
+
+static struct platform_device *bfin_isp1761_devices[] = {
+	&bfin_isp1761_device,
+};
+
+int __init bfin_isp1761_init(void)
+{
+	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
+
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
+	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
+
+	return platform_add_devices(bfin_isp1761_devices, num_devices);
+}
+
+void __exit bfin_isp1761_exit(void)
+{
+	platform_device_unregister(&bfin_isp1761_device);
+}
+
+arch_initcall(bfin_isp1761_init);
+#endif
+
+#if defined(CONFIG_USB_MUSB_HDRC) || defined(CONFIG_USB_MUSB_HDRC_MODULE)
+static struct resource musb_resources[] = {
+	[0] = {
+		.start	= 0xffc03800,
+		.end	= 0xffc03cff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {	/* general IRQ */
+		.start	= IRQ_USB_INT0,
+		.end	= IRQ_USB_INT0,
+		.flags	= IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+	[2] = {	/* DMA IRQ */
+		.start	= IRQ_USB_DMA,
+		.end	= IRQ_USB_DMA,
+		.flags	= IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct musb_hdrc_platform_data musb_plat = {
+#if defined(CONFIG_USB_MUSB_OTG)
+	.mode		= MUSB_OTG,
+#elif defined(CONFIG_USB_MUSB_HDRC_HCD)
+	.mode		= MUSB_HOST,
+#elif defined(CONFIG_USB_GADGET_MUSB_HDRC)
+	.mode		= MUSB_PERIPHERAL,
+#endif
+	.multipoint	= 0,
+};
+
+static u64 musb_dmamask = ~(u32)0;
+
+static struct platform_device musb_device = {
+	.name		= "musb_hdrc",
+	.id		= 0,
+	.dev = {
+		.dma_mask		= &musb_dmamask,
+		.coherent_dma_mask	= 0xffffffff,
+		.platform_data		= &musb_plat,
+	},
+	.num_resources	= ARRAY_SIZE(musb_resources),
+	.resource	= musb_resources,
+};
+#endif
+
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+static struct mtd_partition ezkit_partitions[] = {
+	{
+		.name       = "Bootloader",
+		.size       = 0x40000,
+		.offset     = 0,
+	}, {
+		.name       = "Kernel",
+		.size       = 0x1C0000,
+		.offset     = MTDPART_OFS_APPEND,
+	}, {
+		.name       = "RootFS",
+		.size       = MTDPART_SIZ_FULL,
+		.offset     = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct physmap_flash_data ezkit_flash_data = {
+	.width      = 2,
+	.parts      = ezkit_partitions,
+	.nr_parts   = ARRAY_SIZE(ezkit_partitions),
+};
+
+static struct resource ezkit_flash_resource = {
+	.start = 0x20000000,
+	.end   = 0x201fffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device ezkit_flash_device = {
+	.name          = "physmap-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &ezkit_flash_data,
+	},
+	.num_resources = 1,
+	.resource      = &ezkit_flash_resource,
+};
+#endif
+
+#if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
+static struct mtd_partition partition_info[] = {
+	{
+		.name = "Linux Kernel",
+		.offset = 0,
+		.size = 4 * SIZE_1M,
+	},
+	{
+		.name = "File System",
+		.offset = MTDPART_OFS_APPEND,
+		.size = MTDPART_SIZ_FULL,
+	},
+};
+
+static struct bf5xx_nand_platform bf5xx_nand_platform = {
+	.page_size = NFC_PG_SIZE_256,
+	.data_width = NFC_NWIDTH_8,
+	.partitions = partition_info,
+	.nr_partitions = ARRAY_SIZE(partition_info),
+	.rd_dly = 3,
+	.wr_dly = 3,
+};
+
+static struct resource bf5xx_nand_resources[] = {
+	{
+		.start = NFC_CTL,
+		.end = NFC_DATA_RD + 2,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = CH_NFC,
+		.end = CH_NFC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf5xx_nand_device = {
+	.name = "bf5xx-nand",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf5xx_nand_resources),
+	.resource = bf5xx_nand_resources,
+	.dev = {
+		.platform_data = &bf5xx_nand_platform,
+	},
+};
+#endif
+
+#if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
+static struct resource bfin_pcmcia_cf_resources[] = {
+	{
+		.start = 0x20310000, /* IO PORT */
+		.end = 0x20312000,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x20311000, /* Attribute Memory */
+		.end = 0x20311FFF,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF4,
+		.end = IRQ_PF4,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	}, {
+		.start = 6, /* Card Detect PF6 */
+		.end = 6,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_pcmcia_cf_device = {
+	.name = "bfin_cf_pcmcia",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_pcmcia_cf_resources),
+	.resource = bfin_pcmcia_cf_resources,
+};
+#endif
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+static struct platform_device rtc_device = {
+	.name = "rtc-bfin",
+	.id   = -1,
+};
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+static struct resource smc91x_resources[] = {
+	{
+		.name = "smc91x-regs",
+		.start = 0x20300300,
+		.end = 0x20300300 + 16,
+		.flags = IORESOURCE_MEM,
+	}, {
+
+		.start = IRQ_PF7,
+		.end = IRQ_PF7,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+static struct platform_device smc91x_device = {
+	.name = "smc91x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smc91x_resources),
+	.resource = smc91x_resources,
+};
+#endif
+
+#if defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
+static struct resource dm9000_resources[] = {
+	[0] = {
+		.start	= 0x203FB800,
+		.end	= 0x203FB800 + 8,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_PF9,
+		.end	= IRQ_PF9,
+		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE),
+	},
+};
+
+static struct platform_device dm9000_device = {
+	.name		= "dm9000",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(dm9000_resources),
+	.resource	= dm9000_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
+static struct resource sl811_hcd_resources[] = {
+	{
+		.start = 0x20340000,
+		.end = 0x20340000,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x20340004,
+		.end = 0x20340004,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = CONFIG_USB_SL811_BFIN_IRQ,
+		.end = CONFIG_USB_SL811_BFIN_IRQ,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+#if defined(CONFIG_USB_SL811_BFIN_USE_VBUS)
+void sl811_port_power(struct device *dev, int is_on)
+{
+	gpio_request(CONFIG_USB_SL811_BFIN_GPIO_VBUS, "usb:SL811_VBUS");
+	gpio_direction_output(CONFIG_USB_SL811_BFIN_GPIO_VBUS, is_on);
+}
+#endif
+
+static struct sl811_platform_data sl811_priv = {
+	.potpg = 10,
+	.power = 250,       /* == 500mA */
+#if defined(CONFIG_USB_SL811_BFIN_USE_VBUS)
+	.port_power = &sl811_port_power,
+#endif
+};
+
+static struct platform_device sl811_hcd_device = {
+	.name = "sl811-hcd",
+	.id = 0,
+	.dev = {
+		.platform_data = &sl811_priv,
+	},
+	.num_resources = ARRAY_SIZE(sl811_hcd_resources),
+	.resource = sl811_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+static struct resource isp1362_hcd_resources[] = {
+	{
+		.start = 0x20360000,
+		.end = 0x20360000,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x20360004,
+		.end = 0x20360004,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = CONFIG_USB_ISP1362_BFIN_GPIO_IRQ,
+		.end = CONFIG_USB_ISP1362_BFIN_GPIO_IRQ,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct isp1362_platform_data isp1362_priv = {
+	.sel15Kres = 1,
+	.clknotstop = 0,
+	.oc_enable = 0,
+	.int_act_high = 0,
+	.int_edge_triggered = 0,
+	.remote_wakeup_connected = 0,
+	.no_power_switching = 1,
+	.power_switching_mode = 0,
+};
+
+static struct platform_device isp1362_hcd_device = {
+	.name = "isp1362-hcd",
+	.id = 0,
+	.dev = {
+		.platform_data = &isp1362_priv,
+	},
+	.num_resources = ARRAY_SIZE(isp1362_hcd_resources),
+	.resource = isp1362_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
+static struct platform_device bfin_mac_device = {
+	.name = "bfin_mac",
+};
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+static struct resource net2272_bfin_resources[] = {
+	{
+		.start = 0x20300000,
+		.end = 0x20300000 + 0x100,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF7,
+		.end = IRQ_PF7,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device net2272_bfin_device = {
+	.name = "net2272",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(net2272_bfin_resources),
+	.resource = net2272_bfin_resources,
+};
+#endif
+
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader",
+		.size = 0x00040000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "linux kernel",
+		.size = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p16",
+};
+
+/* SPI flash chip (m25p64) */
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) \
+	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+/* SPI ADC chip */
+static struct bfin5xx_spi_chip spi_adc_chip_info = {
+	.enable_dma = 1,         /* use dma transfer with this chip*/
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) \
+	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
+static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+static struct bfin5xx_spi_chip spi_mmc_chip_info = {
+	.enable_dma = 1,
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_PBX)
+static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
+	.ctl_reg	= 0x4, /* send zero */
+	.enable_dma	= 0,
+	.bits_per_word	= 8,
+	.cs_change_per_word = 1,
+};
+#endif
+
+#if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+
+static const struct ad7877_platform_data bfin_ad7877_ts_info = {
+	.model			= 7877,
+	.vref_delay_usecs	= 50,	/* internal, no capacitor */
+	.x_plate_ohms		= 419,
+	.y_plate_ohms		= 486,
+	.pressure_max		= 1000,
+	.pressure_min		= 0,
+	.stopacq_polarity 	= 1,
+	.first_conversion_delay = 3,
+	.acquisition_time 	= 1,
+	.averaging 		= 1,
+	.pen_down_acc_interval 	= 1,
+};
+#endif
+
+#if defined(CONFIG_SND_SOC_WM8731) || defined(CONFIG_SND_SOC_WM8731_MODULE) \
+	 && defined(CONFIG_SND_SOC_WM8731_SPI)
+static struct bfin5xx_spi_chip spi_wm8731_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
+static struct bfin5xx_spi_chip spidev_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 8,
+};
+#endif
+
+static struct spi_board_info bfin_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) \
+	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
+	{
+		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* Framework chip select. */
+		.platform_data = NULL, /* No spi_driver specific config */
+		.controller_data = &spi_adc_chip_info,
+	},
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) \
+	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+	{
+		.modalias = "ad1836-spi",
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
+		.controller_data = &ad1836_spi_chip_info,
+	},
+#endif
+#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
+	{
+		.modalias = "ad9960-spi",
+		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 1,
+		.controller_data = &ad9960_spi_chip_info,
+	},
+#endif
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+	{
+		.modalias = "spi_mmc_dummy",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 0,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "spi_mmc",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+#if defined(CONFIG_PBX)
+	{
+		.modalias = "fxs-spi",
+		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 8 - CONFIG_J11_JUMPER,
+		.controller_data = &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "fxo-spi",
+		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 8 - CONFIG_J19_JUMPER,
+		.controller_data = &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+#if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+	{
+		.modalias		= "ad7877",
+		.platform_data		= &bfin_ad7877_ts_info,
+		.irq			= IRQ_PF8,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num	= 0,
+		.chip_select  = 2,
+		.controller_data = &spi_ad7877_chip_info,
+	},
+#endif
+#if defined(CONFIG_SND_SOC_WM8731) || defined(CONFIG_SND_SOC_WM8731_MODULE) \
+	 && defined(CONFIG_SND_SOC_WM8731_SPI)
+	{
+		.modalias	= "wm8731",
+		.max_speed_hz	= 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num	= 0,
+		.chip_select    = 5,
+		.controller_data = &spi_wm8731_chip_info,
+		.mode = SPI_MODE_0,
+	},
+#endif
+#if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
+	{
+		.modalias = "spidev",
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 1,
+		.controller_data = &spidev_chip_info,
+	},
+#endif
+};
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* SPI controller data */
+static struct bfin5xx_spi_master bfin_spi0_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
+};
+
+/* SPI (0) */
+static struct resource bfin_spi0_resource[] = {
+	[0] = {
+		.start = SPI0_REGBASE,
+		.end   = SPI0_REGBASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+		},
+	[1] = {
+		.start = CH_SPI,
+		.end   = CH_SPI,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_spi0_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bfin_spi0_info, /* Passed to driver */
+	},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+static struct platform_device bfin_fb_adv7393_device = {
+	.name = "bfin-adv7393",
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+static struct resource bfin_uart_resources[] = {
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	{
+		.start = 0xFFC02000,
+		.end = 0xFFC020FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+};
+
+static struct platform_device bfin_uart_device = {
+	.name = "bfin-uart",
+	.id = 1,
+	.num_resources = ARRAY_SIZE(bfin_uart_resources),
+	.resource = bfin_uart_resources,
+};
+#endif
+
+#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
+static struct resource bfin_sir_resources[] = {
+#ifdef CONFIG_BFIN_SIR0
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+#ifdef CONFIG_BFIN_SIR1
+	{
+		.start = 0xFFC02000,
+		.end = 0xFFC020FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+};
+
+static struct platform_device bfin_sir_device = {
+	.name = "bfin_sir",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_sir_resources),
+	.resource = bfin_sir_resources,
+};
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+static struct resource bfin_twi0_resource[] = {
+	[0] = {
+		.start = TWI0_REGBASE,
+		.end   = TWI0_REGBASE,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_TWI,
+		.end   = IRQ_TWI,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device i2c_bfin_twi_device = {
+	.name = "i2c-bfin-twi",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_twi0_resource),
+	.resource = bfin_twi0_resource,
+};
+#endif
+
+#ifdef CONFIG_I2C_BOARDINFO
+static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
+#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+	{
+		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
+		.type = "pcf8574_lcd",
+	},
+#endif
+#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+	{
+		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
+		.type = "pcf8574_keypad",
+		.irq = IRQ_PF8,
+	},
+#endif
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+static struct platform_device bfin_sport0_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 0,
+};
+
+static struct platform_device bfin_sport1_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 1,
+};
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+#define PATA_INT	55
+
+static struct pata_platform_info bfin_pata_platform_data = {
+	.ioport_shift = 1,
+	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+};
+
+static struct resource bfin_pata_resources[] = {
+	{
+		.start = 0x20314020,
+		.end = 0x2031403F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = 0x2031401C,
+		.end = 0x2031401F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = PATA_INT,
+		.end = PATA_INT,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_pata_device = {
+	.name = "pata_platform",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_pata_resources),
+	.resource = bfin_pata_resources,
+	.dev = {
+		.platform_data = &bfin_pata_platform_data,
+	}
+};
+#endif
+
+#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
+static struct gpio_keys_button bfin_gpio_keys_table[] = {
+	{BTN_0, GPIO_PF14, 1, "gpio-keys: BTN0"},
+};
+
+static struct gpio_keys_platform_data bfin_gpio_keys_data = {
+	.buttons        = bfin_gpio_keys_table,
+	.nbuttons       = ARRAY_SIZE(bfin_gpio_keys_table),
+};
+
+static struct platform_device bfin_device_gpiokeys = {
+	.name      = "gpio-keys",
+	.dev = {
+		.platform_data = &bfin_gpio_keys_data,
+	},
+};
+#endif
+
+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_100, 400000000),
+	VRPAIR(VLEV_105, 426000000),
+	VRPAIR(VLEV_110, 500000000),
+	VRPAIR(VLEV_115, 533000000),
+	VRPAIR(VLEV_120, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
+static struct platform_device *stamp_devices[] __initdata = {
+
+	&bfin_dpmc,
+
+#if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
+	&bf5xx_nand_device,
+#endif
+
+#if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
+	&bfin_pcmcia_cf_device,
+#endif
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+	&rtc_device,
+#endif
+
+#if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
+	&sl811_hcd_device,
+#endif
+
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+	&isp1362_hcd_device,
+#endif
+
+#if defined(CONFIG_USB_MUSB_HDRC) || defined(CONFIG_USB_MUSB_HDRC_MODULE)
+	&musb_device,
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	&smc91x_device,
+#endif
+
+#if defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
+	&dm9000_device,
+#endif
+
+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
+	&bfin_mac_device,
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+	&net2272_bfin_device,
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bfin_spi0_device,
+#endif
+
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+	&bfin_fb_adv7393_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+	&bfin_uart_device,
+#endif
+
+#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
+	&bfin_sir_device,
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+	&i2c_bfin_twi_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+	&bfin_sport0_uart_device,
+	&bfin_sport1_uart_device,
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+	&bfin_pata_device,
+#endif
+
+#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
+	&bfin_device_gpiokeys,
+#endif
+
+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+	&ezkit_flash_device,
+#endif
+
+	&bfin_gpios_device,
+};
+
+static int __init stamp_init(void)
+{
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
+
+#ifdef CONFIG_I2C_BOARDINFO
+	i2c_register_board_info(0, bfin_i2c_board_info,
+				ARRAY_SIZE(bfin_i2c_board_info));
+#endif
+
+	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
+	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+#endif
+	return 0;
+}
+
+arch_initcall(stamp_init);
+
+void native_machine_restart(char *cmd)
+{
+	/* workaround reboot hang when booting from SPI */
+	if ((bfin_read_SYSCR() & 0x7) == 0x3)
+		bfin_gpio_reset_spi0_ssel1();
+}
+
+void bfin_get_ether_addr(char *addr)
+{
+	random_ether_addr(addr);
+	printk(KERN_WARNING "%s:%s: Setting Ethernet MAC to a random one\n",
__FILE__, __func__);
+}
+EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf527/head.S b/arch/blackfin/mach-bf527/head.S
index 57bdb3b..fe05cc1 100644
--- a/arch/blackfin/mach-bf527/head.S
+++ b/arch/blackfin/mach-bf527/head.S
@@ -32,7 +32,7 @@
 #include <asm/blackfin.h>
 #include <asm/trace.h>

-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif
@@ -185,7 +185,7 @@ ENTRY(__start)

 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 	call _start_dma_code;
 #endif

@@ -318,7 +318,7 @@ ENDPROC(_real_start)
 __FINIT

 .section .l1.text
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)

 	/* Enable PHY CLK buffer output */
@@ -398,12 +398,6 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;

-	p0.l = LO(EBIU_SDBCTL);
-	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
-	r0 = mem_SDBCTL;
-	w[p0] = r0.l;
-	ssync;
-
 	P2.H = hi(EBIU_SDGCTL);
 	P2.L = lo(EBIU_SDGCTL);
 	R0 = [P2];
diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 1295dea..c671e85 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -31,7 +31,7 @@
 #include <linux/init.h>
 #include <asm/blackfin.h>
 #include <asm/trace.h>
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif
@@ -186,7 +186,7 @@ ENTRY(__start)

 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 	call _start_dma_code;
 #endif

@@ -319,7 +319,7 @@ ENDPROC(_real_start)
 __FINIT

 .section .l1.text
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)
 	p0.h = hi(SIC_IWR);
 	p0.l = lo(SIC_IWR);
@@ -390,12 +390,6 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;

-	p0.l = LO(EBIU_SDBCTL);
-	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
-	r0 = mem_SDBCTL;
-	w[p0] = r0.l;
-	ssync;
-
 	P2.H = hi(EBIU_SDGCTL);
 	P2.L = lo(EBIU_SDGCTL);
 	R0 = [P2];
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
b/arch/blackfin/mach-bf537/boards/stamp.c
index 671f9d6..6dbc76f 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -29,9 +29,12 @@
  */

 #include <linux/device.h>
+#include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mtd/plat-ram.h>
 #include <linux/mtd/physmap.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
@@ -355,6 +358,84 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif

+#if defined(CONFIG_MTD_NAND_PLATFORM) ||
defined(CONFIG_MTD_NAND_PLATFORM_MODULE)
+#ifdef CONFIG_MTD_PARTITIONS
+const char *part_probes[] = { "cmdlinepart", "RedBoot", NULL };
+
+static struct mtd_partition bfin_plat_nand_partitions[] = {
+	{
+		.name   = "linux kernel",
+		.size   = 0x400000,
+		.offset = 0,
+	}, {
+		.name   = "file system",
+		.size   = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
+	},
+};
+#endif
+
+#define BFIN_NAND_PLAT_CLE 2
+#define BFIN_NAND_PLAT_ALE 1
+static void bfin_plat_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
unsigned int ctrl)
+{
+	struct nand_chip *this = mtd->priv;
+
+	if (cmd == NAND_CMD_NONE)
+		return;
+
+	if (ctrl & NAND_CLE)
+		writeb(cmd, this->IO_ADDR_W + (1 << BFIN_NAND_PLAT_CLE));
+	else
+		writeb(cmd, this->IO_ADDR_W + (1 << BFIN_NAND_PLAT_ALE));
+}
+
+#define BFIN_NAND_PLAT_READY GPIO_PF3
+static int bfin_plat_nand_dev_ready(struct mtd_info *mtd)
+{
+	return gpio_get_value(BFIN_NAND_PLAT_READY);
+}
+
+static struct platform_nand_data bfin_plat_nand_data = {
+	.chip = {
+		.chip_delay = 30,
+#ifdef CONFIG_MTD_PARTITIONS
+		.part_probe_types = part_probes,
+		.partitions = bfin_plat_nand_partitions,
+		.nr_partitions = ARRAY_SIZE(bfin_plat_nand_partitions),
+#endif
+	},
+	.ctrl = {
+		.cmd_ctrl  = bfin_plat_nand_cmd_ctrl,
+		.dev_ready = bfin_plat_nand_dev_ready,
+	},
+};
+
+#define MAX(x, y) (x > y ? x : y)
+static struct resource bfin_plat_nand_resources = {
+	.start = 0x20212000,
+	.end   = 0x20212000 + (1 << MAX(BFIN_NAND_PLAT_CLE, BFIN_NAND_PLAT_ALE)),
+	.flags = IORESOURCE_IO,
+};
+
+static struct platform_device bfin_async_nand_device = {
+	.name = "gen_nand",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_plat_nand_resources,
+	.dev = {
+		.platform_data = &bfin_plat_nand_data,
+	},
+};
+
+static void bfin_plat_nand_init(void)
+{
+	gpio_request(BFIN_NAND_PLAT_READY, "bfin_nand_plat");
+}
+#else
+static void bfin_plat_nand_init(void) {}
+#endif
+
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 static struct mtd_partition stamp_partitions[] = {
 	{
@@ -780,7 +861,7 @@ static struct platform_device bfin_sport1_uart_device = {
 #endif

 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	55
+#define PATA_INT	IRQ_PF5

 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 1,
@@ -922,6 +1003,10 @@ static struct platform_device *stamp_devices[]
__initdata = {

 	&bfin_gpios_device,

+#if defined(CONFIG_MTD_NAND_PLATFORM) ||
defined(CONFIG_MTD_NAND_PLATFORM_MODULE)
+	&bfin_async_nand_device,
+#endif
+
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&stamp_flash_device,
 #endif
@@ -936,6 +1021,7 @@ static int __init stamp_init(void)
 				ARRAY_SIZE(bfin_i2c_board_info));
 #endif

+	bfin_plat_nand_init();
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));

diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index 48cd58a..6b019ea 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -32,7 +32,7 @@
 #include <asm/blackfin.h>
 #include <asm/trace.h>

-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif
@@ -217,7 +217,7 @@ ENTRY(__start)

 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 	call _start_dma_code;
 #endif

@@ -350,7 +350,7 @@ ENDPROC(_real_start)
 __FINIT

 .section .l1.text
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)

 	/* Enable PHY CLK buffer output */
@@ -430,12 +430,6 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;

-	p0.l = LO(EBIU_SDBCTL);
-	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
-	r0 = mem_SDBCTL;
-	w[p0] = r0.l;
-	ssync;
-
 	P2.H = hi(EBIU_SDGCTL);
 	P2.L = lo(EBIU_SDGCTL);
 	R0 = [P2];
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c
b/arch/blackfin/mach-bf548/boards/ezkit.c
index af7c211..f839106 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -61,6 +61,49 @@ const char bfin_board_name[] = "ADSP-BF548-EZKIT";
  *  Driver needs to know address, irq and flag pin.
  */

+#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
+static struct resource bfin_isp1761_resources[] = {
+	[0] = {
+		.name	= "isp1761-regs",
+		.start  = 0x2C0C0000,
+		.end    = 0x2C0C0000 + 0xfffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_PG7,
+		.end    = IRQ_PG7,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_isp1761_device = {
+	.name           = "isp1761",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(bfin_isp1761_resources),
+	.resource       = bfin_isp1761_resources,
+};
+
+static struct platform_device *bfin_isp1761_devices[] = {
+	&bfin_isp1761_device,
+};
+
+int __init bfin_isp1761_init(void)
+{
+	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
+
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
+	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
+
+	return platform_add_devices(bfin_isp1761_devices, num_devices);
+}
+
+void __exit bfin_isp1761_exit(void)
+{
+	platform_device_unregister(&bfin_isp1761_device);
+}
+arch_initcall(bfin_isp1761_init);
+#endif
+
 #if defined(CONFIG_FB_BF54X_LQ043) || defined(CONFIG_FB_BF54X_LQ043_MODULE)

 #include <asm/mach/bf54x-lq043.h>
@@ -177,6 +220,7 @@ static struct resource bfin_uart_resources[] = {
 	{
 		.start = 0xFFC03100,
 		.end = 0xFFC031FF,
+		.flags = IORESOURCE_MEM,
 	},
 #endif
 };
diff --git a/arch/blackfin/mach-bf548/head.S b/arch/blackfin/mach-bf548/head.S
index f719114..06b9178 100644
--- a/arch/blackfin/mach-bf548/head.S
+++ b/arch/blackfin/mach-bf548/head.S
@@ -31,7 +31,7 @@
 #include <linux/init.h>
 #include <asm/blackfin.h>
 #include <asm/trace.h>
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif
@@ -130,7 +130,7 @@ ENTRY(__start)

 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bf53x_relocate_l1_mem;
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 	call _start_dma_code;
 #endif
 	/* Code for initializing Async memory banks */
@@ -288,7 +288,7 @@ ENDPROC(_real_start)
 __FINIT

 .section .l1.text
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)

 	/* Enable PHY CLK buffer output */
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 5b8bd40..cf1a2df 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -377,12 +377,6 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;

-	p0.l = LO(EBIU_SDBCTL);
-	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
-	r0 = mem_SDBCTL;
-	w[p0] = r0.l;
-	ssync;
-
 	P2.H = hi(EBIU_SDGCTL);
 	P2.L = lo(EBIU_SDGCTL);
 	R0 = [P2];
diff --git a/arch/blackfin/mach-common/arch_checks.c
b/arch/blackfin/mach-common/arch_checks.c
index caaab49..f9160d8 100644
--- a/arch/blackfin/mach-common/arch_checks.c
+++ b/arch/blackfin/mach-common/arch_checks.c
@@ -53,9 +53,3 @@
 # endif

 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
-
-#ifdef CONFIG_MEM_SIZE
-#if (CONFIG_MEM_SIZE % 4)
-#error "SDRAM mem size must be multible of 4MB"
-#endif
-#endif
diff --git a/arch/blackfin/mach-common/dpmc_modes.S
b/arch/blackfin/mach-common/dpmc_modes.S
index b7981d3..5e3f1d8 100644
--- a/arch/blackfin/mach-common/dpmc_modes.S
+++ b/arch/blackfin/mach-common/dpmc_modes.S
@@ -7,7 +7,7 @@
 #include <linux/linkage.h>
 #include <asm/blackfin.h>
 #include <asm/mach/irq.h>
-
+#include <asm/dpmc.h>

 .section .l1.text

@@ -51,31 +51,32 @@ ENTRY(_sleep_mode)
 	RETS = [SP++];
 	( R7:0, P5:0 ) = [SP++];
 	RTS;
+ENDPROC(_sleep_mode)

 ENTRY(_hibernate_mode)
 	[--SP] = ( R7:0, P5:0 );
 	[--SP] =  RETS;

+	R3 = R0;
+	R0 = IWR_DISABLE_ALL;
+	R1 = IWR_DISABLE_ALL;
+	R2 = IWR_DISABLE_ALL;
 	call _set_sic_iwr;
+	call _set_dram_srfs;
+	SSYNC;

 	R0 = 0xFFFF (Z);
 	call _set_rtc_istat;

 	P0.H = hi(VR_CTL);
 	P0.L = lo(VR_CTL);
-	R1 = W[P0](z);
-	BITSET (R1, 8);
-	BITCLR (R1, 0);
-	BITCLR (R1, 1);
-	W[P0] = R1.L;
-	SSYNC;

+	W[P0] = R3.L;
 	CLI R2;
 	IDLE;
-
-	/* Actually, adding anything may not be necessary...SDRAM contents
-	 * are lost
-	 */
+.Lforever:
+	jump .Lforever;
+ENDPROC(_hibernate_mode)

 ENTRY(_deep_sleep)
 	[--SP] = ( R7:0, P5:0 );
@@ -131,6 +132,7 @@ ENTRY(_deep_sleep)
 	RETS = [SP++];
 	( R7:0, P5:0 ) = [SP++];
 	RTS;
+ENDPROC(_deep_sleep)

 ENTRY(_sleep_deeper)
 	[--SP] = ( R7:0, P5:0 );
@@ -232,53 +234,73 @@ ENTRY(_sleep_deeper)
 	RETS = [SP++];
 	( R7:0, P5:0 ) = [SP++];
 	RTS;
+ENDPROC(_sleep_deeper)

 ENTRY(_set_dram_srfs)
 	/*  set the dram to self refresh mode */
-#if defined(CONFIG_BF54x)
+	SSYNC;
+#if defined(EBIU_RSTCTL)	/* DDR */
 	P0.H = hi(EBIU_RSTCTL);
 	P0.L = lo(EBIU_RSTCTL);
 	R2 = [P0];
-	R3.H = hi(SRREQ);
-	R3.L = lo(SRREQ);
-#else
-	P0.H = hi(EBIU_SDGCTL);
+	BITSET(R2, 3); /* SRREQ enter self-refresh mode */
+	[P0] = R2;
+	SSYNC;
+1:
+	R2 = [P0];
+	CC = BITTST(R2, 4);
+	if !CC JUMP 1b;
+#else 				/* SDRAM */
 	P0.L = lo(EBIU_SDGCTL);
+	P0.H = hi(EBIU_SDGCTL);
 	R2 = [P0];
-	R3.H = hi(SRFS);
-	R3.L = lo(SRFS);
-#endif
-	R2 = R2|R3;
+	BITSET(R2, 24); /* SRFS enter self-refresh mode */
 	[P0] = R2;
-	ssync;
-#if defined(CONFIG_BF54x)
-.LSRR_MODE:
+	SSYNC;
+
+	P0.L = lo(EBIU_SDSTAT);
+	P0.H = hi(EBIU_SDSTAT);
+1:
+	R2 = w[P0];
+	SSYNC;
+	cc = BITTST(R2, 1); /* SDSRA poll self-refresh status */
+	if !cc jump 1b;
+
+	P0.L = lo(EBIU_SDGCTL);
+	P0.H = hi(EBIU_SDGCTL);
 	R2 = [P0];
-	CC = BITTST(R2, 4);
-	if !CC JUMP .LSRR_MODE;
+	BITCLR(R2, 0); /* SCTLE disable CLKOUT */
+	[P0] = R2;
 #endif
 	RTS;
+ENDPROC(_set_dram_srfs)

 ENTRY(_unset_dram_srfs)
 	/*  set the dram out of self refresh mode */
-#if defined(CONFIG_BF54x)
+#if defined(EBIU_RSTCTL)	/* DDR */
 	P0.H = hi(EBIU_RSTCTL);
 	P0.L = lo(EBIU_RSTCTL);
 	R2 = [P0];
-	R3.H = hi(SRREQ);
-	R3.L = lo(SRREQ);
-#else
+	BITCLR(R2, 3); /* clear SRREQ bit */
+	[P0] = R2;
+#elif defined(EBIU_SDGCTL)	/* SDRAM */
+
+	P0.L = lo(EBIU_SDGCTL); /* release CLKOUT from self-refresh */
+	P0.H = hi(EBIU_SDGCTL);
+	R2 = [P0];
+	BITSET(R2, 0); /* SCTLE enable CLKOUT */
+	[P0] = R2
+	SSYNC;
+
+	P0.L = lo(EBIU_SDGCTL); /* release SDRAM from self-refresh */
 	P0.H = hi(EBIU_SDGCTL);
-	P0.L = lo(EBIU_SDGCTL);
 	R2 = [P0];
-	R3.H = hi(SRFS);
-	R3.L = lo(SRFS);
+	BITCLR(R2, 24); /* clear SRFS bit */
+	[P0] = R2
 #endif
-	R3 = ~R3;
-	R2 = R2&R3;
-	[P0] = R2;
-	ssync;
+	SSYNC;
 	RTS;
+ENDPROC(_unset_dram_srfs)

 ENTRY(_set_sic_iwr)
 #if defined(CONFIG_BF54x) || defined(CONFIG_BF52x)  || defined(CONFIG_BF561)
@@ -300,6 +322,7 @@ ENTRY(_set_sic_iwr)

 	SSYNC;
 	RTS;
+ENDPROC(_set_sic_iwr)

 ENTRY(_set_rtc_istat)
 #ifndef CONFIG_BF561
@@ -307,8 +330,14 @@ ENTRY(_set_rtc_istat)
 	P0.L = lo(RTC_ISTAT);
 	w[P0] = R0.L;
 	SSYNC;
+#elif (ANOMALY_05000371)
+	nop;
+	nop;
+	nop;
+	nop;
 #endif
 	RTS;
+ENDPROC(_set_rtc_istat)

 ENTRY(_test_pll_locked)
 	P0.H = hi(PLL_STAT);
@@ -318,3 +347,509 @@ ENTRY(_test_pll_locked)
 	CC = BITTST(R0,5);
 	IF !CC JUMP 1b;
 	RTS;
+ENDPROC(_test_pll_locked)
+
+.section .text
+
+ENTRY(_do_hibernate)
+	[--SP] = ( R7:0, P5:0 );
+	[--SP] =  RETS;
+	/* Save System MMRs */
+	R2 = R0;
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+
+#ifdef SIC_IMASK0
+	PM_SYS_PUSH(SIC_IMASK0)
+#endif
+#ifdef SIC_IMASK1
+	PM_SYS_PUSH(SIC_IMASK1)
+#endif
+#ifdef SIC_IMASK2
+	PM_SYS_PUSH(SIC_IMASK2)
+#endif
+#ifdef SIC_IMASK
+	PM_SYS_PUSH(SIC_IMASK)
+#endif
+#ifdef SICA_IMASK0
+	PM_SYS_PUSH(SICA_IMASK0)
+#endif
+#ifdef SICA_IMASK1
+	PM_SYS_PUSH(SICA_IMASK1)
+#endif
+#ifdef SIC_IAR2
+	PM_SYS_PUSH(SIC_IAR0)
+	PM_SYS_PUSH(SIC_IAR1)
+	PM_SYS_PUSH(SIC_IAR2)
+#endif
+#ifdef SIC_IAR3
+	PM_SYS_PUSH(SIC_IAR3)
+#endif
+#ifdef SIC_IAR4
+	PM_SYS_PUSH(SIC_IAR4)
+	PM_SYS_PUSH(SIC_IAR5)
+	PM_SYS_PUSH(SIC_IAR6)
+#endif
+#ifdef SIC_IAR7
+	PM_SYS_PUSH(SIC_IAR7)
+#endif
+#ifdef SIC_IAR8
+	PM_SYS_PUSH(SIC_IAR8)
+	PM_SYS_PUSH(SIC_IAR9)
+	PM_SYS_PUSH(SIC_IAR10)
+	PM_SYS_PUSH(SIC_IAR11)
+#endif
+
+#ifdef SICA_IAR0
+	PM_SYS_PUSH(SICA_IAR0)
+	PM_SYS_PUSH(SICA_IAR1)
+	PM_SYS_PUSH(SICA_IAR2)
+	PM_SYS_PUSH(SICA_IAR3)
+	PM_SYS_PUSH(SICA_IAR4)
+	PM_SYS_PUSH(SICA_IAR5)
+	PM_SYS_PUSH(SICA_IAR6)
+	PM_SYS_PUSH(SICA_IAR7)
+#endif
+
+#ifdef SIC_IWR
+	PM_SYS_PUSH(SIC_IWR)
+#endif
+#ifdef SIC_IWR0
+	PM_SYS_PUSH(SIC_IWR0)
+#endif
+#ifdef SIC_IWR1
+	PM_SYS_PUSH(SIC_IWR1)
+#endif
+#ifdef SIC_IWR2
+	PM_SYS_PUSH(SIC_IWR2)
+#endif
+#ifdef SICA_IWR0
+	PM_SYS_PUSH(SICA_IWR0)
+#endif
+#ifdef SICA_IWR1
+	PM_SYS_PUSH(SICA_IWR1)
+#endif
+
+#ifdef PINT0_ASSIGN
+	PM_SYS_PUSH(PINT0_ASSIGN)
+	PM_SYS_PUSH(PINT1_ASSIGN)
+	PM_SYS_PUSH(PINT2_ASSIGN)
+	PM_SYS_PUSH(PINT3_ASSIGN)
+#endif
+
+	PM_SYS_PUSH(EBIU_AMBCTL0)
+	PM_SYS_PUSH(EBIU_AMBCTL1)
+	PM_SYS_PUSH16(EBIU_AMGCTL)
+
+#ifdef EBIU_FCTL
+	PM_SYS_PUSH(EBIU_MBSCTL)
+	PM_SYS_PUSH(EBIU_MODE)
+	PM_SYS_PUSH(EBIU_FCTL)
+#endif
+
+	PM_SYS_PUSH16(SYSCR)
+
+	/* Save Core MMRs */
+	P0.H = hi(SRAM_BASE_ADDRESS);
+	P0.L = lo(SRAM_BASE_ADDRESS);
+
+	PM_PUSH(DMEM_CONTROL)
+	PM_PUSH(DCPLB_ADDR0)
+	PM_PUSH(DCPLB_ADDR1)
+	PM_PUSH(DCPLB_ADDR2)
+	PM_PUSH(DCPLB_ADDR3)
+	PM_PUSH(DCPLB_ADDR4)
+	PM_PUSH(DCPLB_ADDR5)
+	PM_PUSH(DCPLB_ADDR6)
+	PM_PUSH(DCPLB_ADDR7)
+	PM_PUSH(DCPLB_ADDR8)
+	PM_PUSH(DCPLB_ADDR9)
+	PM_PUSH(DCPLB_ADDR10)
+	PM_PUSH(DCPLB_ADDR11)
+	PM_PUSH(DCPLB_ADDR12)
+	PM_PUSH(DCPLB_ADDR13)
+	PM_PUSH(DCPLB_ADDR14)
+	PM_PUSH(DCPLB_ADDR15)
+	PM_PUSH(DCPLB_DATA0)
+	PM_PUSH(DCPLB_DATA1)
+	PM_PUSH(DCPLB_DATA2)
+	PM_PUSH(DCPLB_DATA3)
+	PM_PUSH(DCPLB_DATA4)
+	PM_PUSH(DCPLB_DATA5)
+	PM_PUSH(DCPLB_DATA6)
+	PM_PUSH(DCPLB_DATA7)
+	PM_PUSH(DCPLB_DATA8)
+	PM_PUSH(DCPLB_DATA9)
+	PM_PUSH(DCPLB_DATA10)
+	PM_PUSH(DCPLB_DATA11)
+	PM_PUSH(DCPLB_DATA12)
+	PM_PUSH(DCPLB_DATA13)
+	PM_PUSH(DCPLB_DATA14)
+	PM_PUSH(DCPLB_DATA15)
+	PM_PUSH(IMEM_CONTROL)
+	PM_PUSH(ICPLB_ADDR0)
+	PM_PUSH(ICPLB_ADDR1)
+	PM_PUSH(ICPLB_ADDR2)
+	PM_PUSH(ICPLB_ADDR3)
+	PM_PUSH(ICPLB_ADDR4)
+	PM_PUSH(ICPLB_ADDR5)
+	PM_PUSH(ICPLB_ADDR6)
+	PM_PUSH(ICPLB_ADDR7)
+	PM_PUSH(ICPLB_ADDR8)
+	PM_PUSH(ICPLB_ADDR9)
+	PM_PUSH(ICPLB_ADDR10)
+	PM_PUSH(ICPLB_ADDR11)
+	PM_PUSH(ICPLB_ADDR12)
+	PM_PUSH(ICPLB_ADDR13)
+	PM_PUSH(ICPLB_ADDR14)
+	PM_PUSH(ICPLB_ADDR15)
+	PM_PUSH(ICPLB_DATA0)
+	PM_PUSH(ICPLB_DATA1)
+	PM_PUSH(ICPLB_DATA2)
+	PM_PUSH(ICPLB_DATA3)
+	PM_PUSH(ICPLB_DATA4)
+	PM_PUSH(ICPLB_DATA5)
+	PM_PUSH(ICPLB_DATA6)
+	PM_PUSH(ICPLB_DATA7)
+	PM_PUSH(ICPLB_DATA8)
+	PM_PUSH(ICPLB_DATA9)
+	PM_PUSH(ICPLB_DATA10)
+	PM_PUSH(ICPLB_DATA11)
+	PM_PUSH(ICPLB_DATA12)
+	PM_PUSH(ICPLB_DATA13)
+	PM_PUSH(ICPLB_DATA14)
+	PM_PUSH(ICPLB_DATA15)
+	PM_PUSH(EVT0)
+	PM_PUSH(EVT1)
+	PM_PUSH(EVT2)
+	PM_PUSH(EVT3)
+	PM_PUSH(EVT4)
+	PM_PUSH(EVT5)
+	PM_PUSH(EVT6)
+	PM_PUSH(EVT7)
+	PM_PUSH(EVT8)
+	PM_PUSH(EVT9)
+	PM_PUSH(EVT10)
+	PM_PUSH(EVT11)
+	PM_PUSH(EVT12)
+	PM_PUSH(EVT13)
+	PM_PUSH(EVT14)
+	PM_PUSH(EVT15)
+	PM_PUSH(IMASK)
+	PM_PUSH(ILAT)
+	PM_PUSH(IPRIO)
+	PM_PUSH(TCNTL)
+	PM_PUSH(TPERIOD)
+	PM_PUSH(TSCALE)
+	PM_PUSH(TCOUNT)
+	PM_PUSH(TBUFCTL)
+
+	/* Save Core Registers */
+	[--sp] = SYSCFG;
+	[--sp] = ( R7:0, P5:0 );
+	[--sp] = fp;
+	[--sp] = usp;
+
+	[--sp] = i0;
+	[--sp] = i1;
+	[--sp] = i2;
+	[--sp] = i3;
+
+	[--sp] = m0;
+	[--sp] = m1;
+	[--sp] = m2;
+	[--sp] = m3;
+
+	[--sp] = l0;
+	[--sp] = l1;
+	[--sp] = l2;
+	[--sp] = l3;
+
+	[--sp] = b0;
+	[--sp] = b1;
+	[--sp] = b2;
+	[--sp] = b3;
+	[--sp] = a0.x;
+	[--sp] = a0.w;
+	[--sp] = a1.x;
+	[--sp] = a1.w;
+
+	[--sp] = LC0;
+	[--sp] = LC1;
+	[--sp] = LT0;
+	[--sp] = LT1;
+	[--sp] = LB0;
+	[--sp] = LB1;
+
+	[--sp] = ASTAT;
+	[--sp] = CYCLES;
+	[--sp] = CYCLES2;
+
+	[--sp] = RETS;
+	r0 = RETI;
+	[--sp] = r0;
+	[--sp] = RETX;
+	[--sp] = RETN;
+	[--sp] = RETE;
+	[--sp] = SEQSTAT;
+
+	/* Save Magic, return address and Stack Pointer */
+	P0.H = 0;
+	P0.L = 0;
+	R0.H = 0xDEAD;	/* Hibernate Magic */
+	R0.L = 0xBEEF;
+	[P0++] = R0;	/* Store Hibernate Magic */
+	R0.H = .Lpm_resume_here;
+	R0.L = .Lpm_resume_here;
+	[P0++] = R0;	/* Save Return Address */
+	[P0++] = SP;	/* Save Stack Pointer */
+	P0.H = _hibernate_mode;
+	P0.L = _hibernate_mode;
+	R0 = R2;
+	call (P0); /* Goodbye */
+
+.Lpm_resume_here:
+
+	/* Restore Core Registers */
+	SEQSTAT = [sp++];
+	RETE = [sp++];
+	RETN = [sp++];
+	RETX = [sp++];
+	r0 = [sp++];
+	RETI = r0;
+	RETS = [sp++];
+
+	CYCLES2 = [sp++];
+	CYCLES = [sp++];
+	ASTAT = [sp++];
+
+	LB1 = [sp++];
+	LB0 = [sp++];
+	LT1 = [sp++];
+	LT0 = [sp++];
+	LC1 = [sp++];
+	LC0 = [sp++];
+
+	a1.w = [sp++];
+	a1.x = [sp++];
+	a0.w = [sp++];
+	a0.x = [sp++];
+	b3 = [sp++];
+	b2 = [sp++];
+	b1 = [sp++];
+	b0 = [sp++];
+
+	l3 = [sp++];
+	l2 = [sp++];
+	l1 = [sp++];
+	l0 = [sp++];
+
+	m3 = [sp++];
+	m2 = [sp++];
+	m1 = [sp++];
+	m0 = [sp++];
+
+	i3 = [sp++];
+	i2 = [sp++];
+	i1 = [sp++];
+	i0 = [sp++];
+
+	usp = [sp++];
+	fp = [sp++];
+
+	( R7 : 0, P5 : 0) = [ SP ++ ];
+	SYSCFG = [sp++];
+
+	/* Restore Core MMRs */
+
+	PM_POP(TBUFCTL)
+	PM_POP(TCOUNT)
+	PM_POP(TSCALE)
+	PM_POP(TPERIOD)
+	PM_POP(TCNTL)
+	PM_POP(IPRIO)
+	PM_POP(ILAT)
+	PM_POP(IMASK)
+	PM_POP(EVT15)
+	PM_POP(EVT14)
+	PM_POP(EVT13)
+	PM_POP(EVT12)
+	PM_POP(EVT11)
+	PM_POP(EVT10)
+	PM_POP(EVT9)
+	PM_POP(EVT8)
+	PM_POP(EVT7)
+	PM_POP(EVT6)
+	PM_POP(EVT5)
+	PM_POP(EVT4)
+	PM_POP(EVT3)
+	PM_POP(EVT2)
+	PM_POP(EVT1)
+	PM_POP(EVT0)
+	PM_POP(ICPLB_DATA15)
+	PM_POP(ICPLB_DATA14)
+	PM_POP(ICPLB_DATA13)
+	PM_POP(ICPLB_DATA12)
+	PM_POP(ICPLB_DATA11)
+	PM_POP(ICPLB_DATA10)
+	PM_POP(ICPLB_DATA9)
+	PM_POP(ICPLB_DATA8)
+	PM_POP(ICPLB_DATA7)
+	PM_POP(ICPLB_DATA6)
+	PM_POP(ICPLB_DATA5)
+	PM_POP(ICPLB_DATA4)
+	PM_POP(ICPLB_DATA3)
+	PM_POP(ICPLB_DATA2)
+	PM_POP(ICPLB_DATA1)
+	PM_POP(ICPLB_DATA0)
+	PM_POP(ICPLB_ADDR15)
+	PM_POP(ICPLB_ADDR14)
+	PM_POP(ICPLB_ADDR13)
+	PM_POP(ICPLB_ADDR12)
+	PM_POP(ICPLB_ADDR11)
+	PM_POP(ICPLB_ADDR10)
+	PM_POP(ICPLB_ADDR9)
+	PM_POP(ICPLB_ADDR8)
+	PM_POP(ICPLB_ADDR7)
+	PM_POP(ICPLB_ADDR6)
+	PM_POP(ICPLB_ADDR5)
+	PM_POP(ICPLB_ADDR4)
+	PM_POP(ICPLB_ADDR3)
+	PM_POP(ICPLB_ADDR2)
+	PM_POP(ICPLB_ADDR1)
+	PM_POP(ICPLB_ADDR0)
+	PM_POP(IMEM_CONTROL)
+	PM_POP(DCPLB_DATA15)
+	PM_POP(DCPLB_DATA14)
+	PM_POP(DCPLB_DATA13)
+	PM_POP(DCPLB_DATA12)
+	PM_POP(DCPLB_DATA11)
+	PM_POP(DCPLB_DATA10)
+	PM_POP(DCPLB_DATA9)
+	PM_POP(DCPLB_DATA8)
+	PM_POP(DCPLB_DATA7)
+	PM_POP(DCPLB_DATA6)
+	PM_POP(DCPLB_DATA5)
+	PM_POP(DCPLB_DATA4)
+	PM_POP(DCPLB_DATA3)
+	PM_POP(DCPLB_DATA2)
+	PM_POP(DCPLB_DATA1)
+	PM_POP(DCPLB_DATA0)
+	PM_POP(DCPLB_ADDR15)
+	PM_POP(DCPLB_ADDR14)
+	PM_POP(DCPLB_ADDR13)
+	PM_POP(DCPLB_ADDR12)
+	PM_POP(DCPLB_ADDR11)
+	PM_POP(DCPLB_ADDR10)
+	PM_POP(DCPLB_ADDR9)
+	PM_POP(DCPLB_ADDR8)
+	PM_POP(DCPLB_ADDR7)
+	PM_POP(DCPLB_ADDR6)
+	PM_POP(DCPLB_ADDR5)
+	PM_POP(DCPLB_ADDR4)
+	PM_POP(DCPLB_ADDR3)
+	PM_POP(DCPLB_ADDR2)
+	PM_POP(DCPLB_ADDR1)
+	PM_POP(DCPLB_ADDR0)
+	PM_POP(DMEM_CONTROL)
+
+	/* Restore System MMRs */
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	PM_SYS_POP16(SYSCR)
+
+#ifdef EBIU_FCTL
+	PM_SYS_POP(EBIU_FCTL)
+	PM_SYS_POP(EBIU_MODE)
+	PM_SYS_POP(EBIU_MBSCTL)
+#endif
+	PM_SYS_POP16(EBIU_AMGCTL)
+	PM_SYS_POP(EBIU_AMBCTL1)
+	PM_SYS_POP(EBIU_AMBCTL0)
+
+#ifdef PINT0_ASSIGN
+	PM_SYS_POP(PINT3_ASSIGN)
+	PM_SYS_POP(PINT2_ASSIGN)
+	PM_SYS_POP(PINT1_ASSIGN)
+	PM_SYS_POP(PINT0_ASSIGN)
+#endif
+
+#ifdef SICA_IWR1
+	PM_SYS_POP(SICA_IWR1)
+#endif
+#ifdef SICA_IWR0
+	PM_SYS_POP(SICA_IWR0)
+#endif
+#ifdef SIC_IWR2
+	PM_SYS_POP(SIC_IWR2)
+#endif
+#ifdef SIC_IWR1
+	PM_SYS_POP(SIC_IWR1)
+#endif
+#ifdef SIC_IWR0
+	PM_SYS_POP(SIC_IWR0)
+#endif
+#ifdef SIC_IWR
+	PM_SYS_POP(SIC_IWR)
+#endif
+
+#ifdef SICA_IAR0
+	PM_SYS_POP(SICA_IAR7)
+	PM_SYS_POP(SICA_IAR6)
+	PM_SYS_POP(SICA_IAR5)
+	PM_SYS_POP(SICA_IAR4)
+	PM_SYS_POP(SICA_IAR3)
+	PM_SYS_POP(SICA_IAR2)
+	PM_SYS_POP(SICA_IAR1)
+	PM_SYS_POP(SICA_IAR0)
+#endif
+
+#ifdef SIC_IAR8
+	PM_SYS_POP(SIC_IAR11)
+	PM_SYS_POP(SIC_IAR10)
+	PM_SYS_POP(SIC_IAR9)
+	PM_SYS_POP(SIC_IAR8)
+#endif
+#ifdef SIC_IAR7
+	PM_SYS_POP(SIC_IAR7)
+#endif
+#ifdef SIC_IAR6
+	PM_SYS_POP(SIC_IAR6)
+	PM_SYS_POP(SIC_IAR5)
+	PM_SYS_POP(SIC_IAR4)
+#endif
+#ifdef SIC_IAR3
+	PM_SYS_POP(SIC_IAR3)
+#endif
+#ifdef SIC_IAR2
+	PM_SYS_POP(SIC_IAR2)
+	PM_SYS_POP(SIC_IAR1)
+	PM_SYS_POP(SIC_IAR0)
+#endif
+#ifdef SICA_IMASK1
+	PM_SYS_POP(SICA_IMASK1)
+#endif
+#ifdef SICA_IMASK0
+	PM_SYS_POP(SICA_IMASK0)
+#endif
+#ifdef SIC_IMASK
+	PM_SYS_POP(SIC_IMASK)
+#endif
+#ifdef SIC_IMASK2
+	PM_SYS_POP(SIC_IMASK2)
+#endif
+#ifdef SIC_IMASK1
+	PM_SYS_POP(SIC_IMASK1)
+#endif
+#ifdef SIC_IMASK0
+	PM_SYS_POP(SIC_IMASK0)
+#endif
+
+	[--sp] = RETI;	/* Clear Global Interrupt Disable */
+	SP += 4;
+
+	RETS = [SP++];
+	( R7:0, P5:0 ) = [SP++];
+	RTS;
+ENDPROC(_do_hibernate)
diff --git a/arch/blackfin/mach-common/ints-priority.c
b/arch/blackfin/mach-common/ints-priority.c
index f5fd768..64d7461 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -459,6 +459,8 @@ static struct irq_chip bfin_gpio_irqchip = {
 	.mask = bfin_gpio_mask_irq,
 	.mask_ack = bfin_gpio_mask_ack_irq,
 	.unmask = bfin_gpio_unmask_irq,
+	.disable = bfin_gpio_mask_irq,
+	.enable = bfin_gpio_unmask_irq,
 	.set_type = bfin_gpio_irq_type,
 	.startup = bfin_gpio_irq_startup,
 	.shutdown = bfin_gpio_irq_shutdown,
@@ -846,6 +848,8 @@ static struct irq_chip bfin_gpio_irqchip = {
 	.mask = bfin_gpio_mask_irq,
 	.mask_ack = bfin_gpio_mask_ack_irq,
 	.unmask = bfin_gpio_unmask_irq,
+	.disable = bfin_gpio_mask_irq,
+	.enable = bfin_gpio_unmask_irq,
 	.set_type = bfin_gpio_irq_type,
 	.startup = bfin_gpio_irq_startup,
 	.shutdown = bfin_gpio_irq_shutdown,
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 0be805c..4fe6a23 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -38,8 +38,9 @@
 #include <linux/io.h>
 #include <linux/irq.h>

-#include <asm/dpmc.h>
 #include <asm/gpio.h>
+#include <asm/dma.h>
+#include <asm/dpmc.h>

 #ifdef CONFIG_PM_WAKEUP_GPIO_POLAR_H
 #define WAKEUP_TYPE	PM_WAKE_HIGH
@@ -61,16 +62,17 @@
 #define WAKEUP_TYPE	PM_WAKE_BOTH_EDGES
 #endif

+
 void bfin_pm_suspend_standby_enter(void)
 {
+	unsigned long flags;
+
 #ifdef CONFIG_PM_WAKEUP_BY_GPIO
 	gpio_pm_wakeup_request(CONFIG_PM_WAKEUP_GPIO_NUMBER, WAKEUP_TYPE);
 #endif

-	u32 flags;
-
 	local_irq_save(flags);
-	bfin_pm_setup();
+	bfin_pm_standby_setup();

 #ifdef CONFIG_PM_BFIN_SLEEP_DEEPER
 	sleep_deeper(bfin_sic_iwr[0], bfin_sic_iwr[1], bfin_sic_iwr[2]);
@@ -78,7 +80,7 @@ void bfin_pm_suspend_standby_enter(void)
 	sleep_mode(bfin_sic_iwr[0], bfin_sic_iwr[1], bfin_sic_iwr[2]);
 #endif

-	bfin_pm_restore();
+	bfin_pm_standby_restore();

 #if defined(CONFIG_BF54x) || defined(CONFIG_BF52x)  || defined(CONFIG_BF561)
 	bfin_write_SIC_IWR0(IWR_ENABLE_ALL);
@@ -93,6 +95,195 @@ void bfin_pm_suspend_standby_enter(void)
 	local_irq_restore(flags);
 }

+int bf53x_suspend_l1_mem(unsigned char *memptr)
+{
+	dma_memcpy(memptr, (const void *) L1_CODE_START, L1_CODE_LENGTH);
+	dma_memcpy(memptr + L1_CODE_LENGTH, (const void *) L1_DATA_A_START,
+			L1_DATA_A_LENGTH);
+	dma_memcpy(memptr + L1_CODE_LENGTH + L1_DATA_A_LENGTH,
+			(const void *) L1_DATA_B_START, L1_DATA_B_LENGTH);
+	memcpy(memptr + L1_CODE_LENGTH + L1_DATA_A_LENGTH +
+			L1_DATA_B_LENGTH, (const void *) L1_SCRATCH_START,
+			L1_SCRATCH_LENGTH);
+
+	return 0;
+}
+
+int bf53x_resume_l1_mem(unsigned char *memptr)
+{
+	dma_memcpy((void *) L1_CODE_START, memptr, L1_CODE_LENGTH);
+	dma_memcpy((void *) L1_DATA_A_START, memptr + L1_CODE_LENGTH,
+			L1_DATA_A_LENGTH);
+	dma_memcpy((void *) L1_DATA_B_START, memptr + L1_CODE_LENGTH +
+			L1_DATA_A_LENGTH, L1_DATA_B_LENGTH);
+	memcpy((void *) L1_SCRATCH_START, memptr + L1_CODE_LENGTH +
+			L1_DATA_A_LENGTH + L1_DATA_B_LENGTH, L1_SCRATCH_LENGTH);
+
+	return 0;
+}
+
+#ifdef CONFIG_BFIN_WB
+static void flushinv_all_dcache(void)
+{
+	u32 way, bank, subbank, set;
+	u32 status, addr;
+	u32 dmem_ctl = bfin_read_DMEM_CONTROL();
+
+	for (bank = 0; bank < 2; ++bank) {
+		if (!(dmem_ctl & (1 << (DMC1_P - bank))))
+			continue;
+
+		for (way = 0; way < 2; ++way)
+			for (subbank = 0; subbank < 4; ++subbank)
+				for (set = 0; set < 64; ++set) {
+
+					bfin_write_DTEST_COMMAND(
+						way << 26 |
+						bank << 23 |
+						subbank << 16 |
+						set << 5
+					);
+					CSYNC();
+					status = bfin_read_DTEST_DATA0();
+
+					/* only worry about valid/dirty entries */
+					if ((status & 0x3) != 0x3)
+						continue;
+
+					/* construct the address using the tag */
+					addr = (status & 0xFFFFC800) | (subbank << 12) | (set << 5);
+
+					/* flush it */
+					__asm__ __volatile__("FLUSHINV[%0];" : : "a"(addr));
+				}
+	}
+}
+#endif
+
+static inline void dcache_disable(void)
+{
+#ifdef CONFIG_BFIN_DCACHE
+	unsigned long ctrl;
+
+#ifdef CONFIG_BFIN_WB
+	flushinv_all_dcache();
+#endif
+	SSYNC();
+	ctrl = bfin_read_DMEM_CONTROL();
+	ctrl &= ~ENDCPLB;
+	bfin_write_DMEM_CONTROL(ctrl);
+	SSYNC();
+#endif
+}
+
+static inline void dcache_enable(void)
+{
+#ifdef CONFIG_BFIN_DCACHE
+	unsigned long ctrl;
+	SSYNC();
+	ctrl = bfin_read_DMEM_CONTROL();
+	ctrl |= ENDCPLB;
+	bfin_write_DMEM_CONTROL(ctrl);
+	SSYNC();
+#endif
+}
+
+static inline void icache_disable(void)
+{
+#ifdef CONFIG_BFIN_ICACHE
+	unsigned long ctrl;
+	SSYNC();
+	ctrl = bfin_read_IMEM_CONTROL();
+	ctrl &= ~ENICPLB;
+	bfin_write_IMEM_CONTROL(ctrl);
+	SSYNC();
+#endif
+}
+
+static inline void icache_enable(void)
+{
+#ifdef CONFIG_BFIN_ICACHE
+	unsigned long ctrl;
+	SSYNC();
+	ctrl = bfin_read_IMEM_CONTROL();
+	ctrl |= ENICPLB;
+	bfin_write_IMEM_CONTROL(ctrl);
+	SSYNC();
+#endif
+}
+
+int bfin_pm_suspend_mem_enter(void)
+{
+	unsigned long flags;
+	int wakeup, ret;
+
+	unsigned char *memptr = kmalloc(L1_CODE_LENGTH + L1_DATA_A_LENGTH
+					 + L1_DATA_B_LENGTH + L1_SCRATCH_LENGTH,
+					  GFP_KERNEL);
+
+	if (memptr == NULL) {
+		panic("bf53x_suspend_l1_mem malloc failed");
+		return -ENOMEM;
+	}
+
+	wakeup = bfin_read_VR_CTL() & ~FREQ;
+	wakeup |= SCKELOW;
+
+	/* FIXME: merge this somehow with set_irq_wake */
+#ifdef CONFIG_PM_BFIN_WAKE_RTC
+	wakeup |= WAKE;
+#endif
+#ifdef CONFIG_PM_BFIN_WAKE_PH6
+	wakeup |= PHYWE;
+#endif
+#ifdef CONFIG_PM_BFIN_WAKE_CAN
+	wakeup |= CANWE;
+#endif
+#ifdef CONFIG_PM_BFIN_WAKE_GP
+	wakeup |= GPWE;
+#endif
+#ifdef CONFIG_PM_BFIN_WAKE_USB
+	wakeup |= USBWE;
+#endif
+#ifdef CONFIG_PM_BFIN_WAKE_KEYPAD
+	wakeup |= KPADWE;
+#endif
+#ifdef CONFIG_PM_BFIN_WAKE_ROTARY
+	wakeup |= ROTWE;
+#endif
+
+	local_irq_save(flags);
+
+	ret = blackfin_dma_suspend();
+
+	if (ret) {
+		local_irq_restore(flags);
+		kfree(memptr);
+		return ret;
+	}
+
+	bfin_gpio_pm_hibernate_suspend();
+
+	dcache_disable();
+	icache_disable();
+	bf53x_suspend_l1_mem(memptr);
+
+	do_hibernate(wakeup);	/* Goodbye */
+
+	bf53x_resume_l1_mem(memptr);
+
+	icache_enable();
+	dcache_enable();
+
+	bfin_gpio_pm_hibernate_restore();
+	blackfin_dma_resume();
+
+	local_irq_restore(flags);
+	kfree(memptr);
+
+	return 0;
+}
+
 /*
  *	bfin_pm_valid - Tell the PM core that we only support the standby sleep
  *			state
@@ -101,7 +292,24 @@ void bfin_pm_suspend_standby_enter(void)
  */
 static int bfin_pm_valid(suspend_state_t state)
 {
-	return (state == PM_SUSPEND_STANDBY);
+	return (state == PM_SUSPEND_STANDBY
+#ifndef BF533_FAMILY
+	/*
+	 * On BF533/2/1:
+	 * If we enter Hibernate the SCKE Pin is driven Low,
+	 * so that the SDRAM enters Self Refresh Mode.
+	 * However when the reset sequence that follows hibernate
+	 * state is executed, SCKE is driven High, taking the
+	 * SDRAM out of Self Refresh.
+	 *
+	 * If you reconfigure and access the SDRAM "very quickly",
+	 * you are likely to avoid errors, otherwise the SDRAM
+	 * start losing its contents.
+	 * An external HW workaround is possible using logic gates.
+	 */
+	|| state == PM_SUSPEND_MEM
+#endif
+	);
 }

 /*
@@ -115,10 +323,9 @@ static int bfin_pm_enter(suspend_state_t state)
 	case PM_SUSPEND_STANDBY:
 		bfin_pm_suspend_standby_enter();
 		break;
-
 	case PM_SUSPEND_MEM:
-		return -ENOTSUPP;
-
+		bfin_pm_suspend_mem_enter();
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index 3246f91..5af3c31 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -41,215 +41,309 @@
 #include <asm/blackfin.h>
 #include "blackfin_sram.h"

-spinlock_t l1sram_lock, l1_data_sram_lock, l1_inst_sram_lock;
-
-#if CONFIG_L1_MAX_PIECE < 16
-#undef CONFIG_L1_MAX_PIECE
-#define CONFIG_L1_MAX_PIECE        16
-#endif
-
-#if CONFIG_L1_MAX_PIECE > 1024
-#undef CONFIG_L1_MAX_PIECE
-#define CONFIG_L1_MAX_PIECE        1024
-#endif
-
-#define SRAM_SLT_NULL      0
-#define SRAM_SLT_FREE      1
-#define SRAM_SLT_ALLOCATED 2
+static spinlock_t l1sram_lock, l1_data_sram_lock, l1_inst_sram_lock;
+static spinlock_t l2_sram_lock;

 /* the data structure for L1 scratchpad and DATA SRAM */
-struct l1_sram_piece {
+struct sram_piece {
 	void *paddr;
 	int size;
-	int flag;
 	pid_t pid;
+	struct sram_piece *next;
 };

-static struct l1_sram_piece l1_ssram[CONFIG_L1_MAX_PIECE];
+static struct sram_piece free_l1_ssram_head, used_l1_ssram_head;

 #if L1_DATA_A_LENGTH != 0
-static struct l1_sram_piece l1_data_A_sram[CONFIG_L1_MAX_PIECE];
+static struct sram_piece free_l1_data_A_sram_head, used_l1_data_A_sram_head;
 #endif

 #if L1_DATA_B_LENGTH != 0
-static struct l1_sram_piece l1_data_B_sram[CONFIG_L1_MAX_PIECE];
+static struct sram_piece free_l1_data_B_sram_head, used_l1_data_B_sram_head;
 #endif

 #if L1_CODE_LENGTH != 0
-static struct l1_sram_piece l1_inst_sram[CONFIG_L1_MAX_PIECE];
+static struct sram_piece free_l1_inst_sram_head, used_l1_inst_sram_head;
+#endif
+
+#ifdef L2_LENGTH
+static struct sram_piece free_l2_sram_head, used_l2_sram_head;
 #endif

+static struct kmem_cache *sram_piece_cache;
+
 /* L1 Scratchpad SRAM initialization function */
-void __init l1sram_init(void)
+static void __init l1sram_init(void)
 {
-	printk(KERN_INFO "Blackfin Scratchpad data SRAM: %d KB\n",
-	       L1_SCRATCH_LENGTH >> 10);
+	free_l1_ssram_head.next =
+		kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
+	if (!free_l1_ssram_head.next) {
+		printk(KERN_INFO"Fail to initialize Scratchpad data SRAM.\n");
+		return;
+	}
+
+	free_l1_ssram_head.next->paddr = (void *)L1_SCRATCH_START;
+	free_l1_ssram_head.next->size = L1_SCRATCH_LENGTH;
+	free_l1_ssram_head.next->pid = 0;
+	free_l1_ssram_head.next->next = NULL;

-	memset(&l1_ssram, 0x00, sizeof(l1_ssram));
-	l1_ssram[0].paddr = (void *)L1_SCRATCH_START;
-	l1_ssram[0].size = L1_SCRATCH_LENGTH;
-	l1_ssram[0].flag = SRAM_SLT_FREE;
+	used_l1_ssram_head.next = NULL;

 	/* mutex initialize */
 	spin_lock_init(&l1sram_lock);
+
+	printk(KERN_INFO "Blackfin Scratchpad data SRAM: %d KB\n",
+	       L1_SCRATCH_LENGTH >> 10);
 }

-void __init l1_data_sram_init(void)
+static void __init l1_data_sram_init(void)
 {
 #if L1_DATA_A_LENGTH != 0
-	memset(&l1_data_A_sram, 0x00, sizeof(l1_data_A_sram));
-	l1_data_A_sram[0].paddr = (void *)L1_DATA_A_START +
-					(_ebss_l1 - _sdata_l1);
-	l1_data_A_sram[0].size = L1_DATA_A_LENGTH - (_ebss_l1 - _sdata_l1);
-	l1_data_A_sram[0].flag = SRAM_SLT_FREE;
-
-	printk(KERN_INFO "Blackfin Data A SRAM: %d KB (%d KB free)\n",
-	       L1_DATA_A_LENGTH >> 10, l1_data_A_sram[0].size >> 10);
+	free_l1_data_A_sram_head.next =
+		kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
+	if (!free_l1_data_A_sram_head.next) {
+		printk(KERN_INFO"Fail to initialize L1 Data A SRAM.\n");
+		return;
+	}
+
+	free_l1_data_A_sram_head.next->paddr =
+		(void *)L1_DATA_A_START + (_ebss_l1 - _sdata_l1);
+	free_l1_data_A_sram_head.next->size =
+		L1_DATA_A_LENGTH - (_ebss_l1 - _sdata_l1);
+	free_l1_data_A_sram_head.next->pid = 0;
+	free_l1_data_A_sram_head.next->next = NULL;
+
+	used_l1_data_A_sram_head.next = NULL;
+
+	printk(KERN_INFO "Blackfin L1 Data A SRAM: %d KB (%d KB free)\n",
+		L1_DATA_A_LENGTH >> 10,
+		free_l1_data_A_sram_head.next->size >> 10);
 #endif
 #if L1_DATA_B_LENGTH != 0
-	memset(&l1_data_B_sram, 0x00, sizeof(l1_data_B_sram));
-	l1_data_B_sram[0].paddr = (void *)L1_DATA_B_START +
-				(_ebss_b_l1 - _sdata_b_l1);
-	l1_data_B_sram[0].size = L1_DATA_B_LENGTH - (_ebss_b_l1 - _sdata_b_l1);
-	l1_data_B_sram[0].flag = SRAM_SLT_FREE;
-
-	printk(KERN_INFO "Blackfin Data B SRAM: %d KB (%d KB free)\n",
-	       L1_DATA_B_LENGTH >> 10, l1_data_B_sram[0].size >> 10);
+	free_l1_data_B_sram_head.next =
+		kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
+	if (!free_l1_data_B_sram_head.next) {
+		printk(KERN_INFO"Fail to initialize L1 Data B SRAM.\n");
+		return;
+	}
+
+	free_l1_data_B_sram_head.next->paddr =
+		(void *)L1_DATA_B_START + (_ebss_b_l1 - _sdata_b_l1);
+	free_l1_data_B_sram_head.next->size =
+		L1_DATA_B_LENGTH - (_ebss_b_l1 - _sdata_b_l1);
+	free_l1_data_B_sram_head.next->pid = 0;
+	free_l1_data_B_sram_head.next->next = NULL;
+
+	used_l1_data_B_sram_head.next = NULL;
+
+	printk(KERN_INFO "Blackfin L1 Data B SRAM: %d KB (%d KB free)\n",
+		L1_DATA_B_LENGTH >> 10,
+		free_l1_data_B_sram_head.next->size >> 10);
 #endif

 	/* mutex initialize */
 	spin_lock_init(&l1_data_sram_lock);
 }

-void __init l1_inst_sram_init(void)
+static void __init l1_inst_sram_init(void)
 {
 #if L1_CODE_LENGTH != 0
-	memset(&l1_inst_sram, 0x00, sizeof(l1_inst_sram));
-	l1_inst_sram[0].paddr = (void *)L1_CODE_START + (_etext_l1 - _stext_l1);
-	l1_inst_sram[0].size = L1_CODE_LENGTH - (_etext_l1 - _stext_l1);
-	l1_inst_sram[0].flag = SRAM_SLT_FREE;
+	free_l1_inst_sram_head.next =
+		kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
+	if (!free_l1_inst_sram_head.next) {
+		printk(KERN_INFO"Fail to initialize L1 Instruction SRAM.\n");
+		return;
+	}

-	printk(KERN_INFO "Blackfin Instruction SRAM: %d KB (%d KB free)\n",
-	       L1_CODE_LENGTH >> 10, l1_inst_sram[0].size >> 10);
+	free_l1_inst_sram_head.next->paddr =
+		(void *)L1_CODE_START + (_etext_l1 - _stext_l1);
+	free_l1_inst_sram_head.next->size =
+		L1_CODE_LENGTH - (_etext_l1 - _stext_l1);
+	free_l1_inst_sram_head.next->pid = 0;
+	free_l1_inst_sram_head.next->next = NULL;
+
+	used_l1_inst_sram_head.next = NULL;
+
+	printk(KERN_INFO "Blackfin L1 Instruction SRAM: %d KB (%d KB free)\n",
+		L1_CODE_LENGTH >> 10,
+		free_l1_inst_sram_head.next->size >> 10);
 #endif

 	/* mutex initialize */
 	spin_lock_init(&l1_inst_sram_lock);
 }

-/* L1 memory allocate function */
-static void *_l1_sram_alloc(size_t size, struct l1_sram_piece *pfree,
int count)
+static void __init l2_sram_init(void)
 {
-	int i, index = 0;
-	void *addr = NULL;
+#ifdef L2_LENGTH
+	free_l2_sram_head.next =
+		kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
+	if (!free_l2_sram_head.next) {
+		printk(KERN_INFO"Fail to initialize L2 SRAM.\n");
+		return;
+	}

-	if (size <= 0)
+	free_l2_sram_head.next->paddr = (void *)L2_START +
+		(_etext_l2 - _stext_l2) + (_edata_l2 - _sdata_l2);
+	free_l2_sram_head.next->size = L2_LENGTH -
+		(_etext_l2 - _stext_l2) + (_edata_l2 - _sdata_l2);
+	free_l2_sram_head.next->pid = 0;
+	free_l2_sram_head.next->next = NULL;
+
+	used_l2_sram_head.next = NULL;
+
+	printk(KERN_INFO "Blackfin L2 SRAM: %d KB (%d KB free)\n",
+		L2_LENGTH >> 10,
+		free_l2_sram_head.next->size >> 10);
+#endif
+
+	/* mutex initialize */
+	spin_lock_init(&l2_sram_lock);
+}
+void __init bfin_sram_init(void)
+{
+	sram_piece_cache = kmem_cache_create("sram_piece_cache",
+				sizeof(struct sram_piece),
+				0, SLAB_PANIC, NULL);
+
+	l1sram_init();
+	l1_data_sram_init();
+	l1_inst_sram_init();
+	l2_sram_init();
+}
+
+/* SRAM allocate function */
+static void *_sram_alloc(size_t size, struct sram_piece *pfree_head,
+		struct sram_piece *pused_head)
+{
+	struct sram_piece *pslot, *plast, *pavail;
+
+	if (size <= 0 || !pfree_head || !pused_head)
 		return NULL;

 	/* Align the size */
 	size = (size + 3) & ~3;

-	/* not use the good method to match the best slot !!! */
-	/* search an available memory slot */
-	for (i = 0; i < count; i++) {
-		if ((pfree[i].flag == SRAM_SLT_FREE)
-		    && (pfree[i].size >= size)) {
-			addr = pfree[i].paddr;
-			pfree[i].flag = SRAM_SLT_ALLOCATED;
-			pfree[i].pid = current->pid;
-			index = i;
-			break;
-		}
+	pslot = pfree_head->next;
+	plast = pfree_head;
+
+	/* search an available piece slot */
+	while (pslot != NULL && size > pslot->size) {
+		plast = pslot;
+		pslot = pslot->next;
 	}
-	if (i >= count)
+
+	if (!pslot)
 		return NULL;

-	/* updated the NULL memory slot !!! */
-	if (pfree[i].size > size) {
-		for (i = 0; i < count; i++) {
-			if (pfree[i].flag == SRAM_SLT_NULL) {
-				pfree[i].pid = 0;
-				pfree[i].flag = SRAM_SLT_FREE;
-				pfree[i].paddr = addr + size;
-				pfree[i].size = pfree[index].size - size;
-				pfree[index].size = size;
-				break;
-			}
-		}
+	if (pslot->size == size) {
+		plast->next = pslot->next;
+		pavail = pslot;
+	} else {
+		pavail = kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
+
+		if (!pavail)
+			return NULL;
+
+		pavail->paddr = pslot->paddr;
+		pavail->size = size;
+		pslot->paddr += size;
+		pslot->size -= size;
 	}

-	return addr;
+	pavail->pid = current->pid;
+
+	pslot = pused_head->next;
+	plast = pused_head;
+
+	/* insert new piece into used piece list !!! */
+	while (pslot != NULL && pavail->paddr < pslot->paddr) {
+		plast = pslot;
+		pslot = pslot->next;
+	}
+
+	pavail->next = pslot;
+	plast->next = pavail;
+
+	return pavail->paddr;
 }

 /* Allocate the largest available block.  */
-static void *_l1_sram_alloc_max(struct l1_sram_piece *pfree, int count,
+static void *_sram_alloc_max(struct sram_piece *pfree_head,
+				struct sram_piece *pused_head,
 				unsigned long *psize)
 {
-	unsigned long best = 0;
-	int i, index = -1;
-	void *addr = NULL;
+	struct sram_piece *pslot, *pmax;

-	/* search an available memory slot */
-	for (i = 0; i < count; i++) {
-		if (pfree[i].flag == SRAM_SLT_FREE && pfree[i].size > best) {
-			addr = pfree[i].paddr;
-			index = i;
-			best = pfree[i].size;
-		}
+	if (!pfree_head || !pused_head)
+		return NULL;
+
+	pmax = pslot = pfree_head->next;
+
+	/* search an available piece slot */
+	while (pslot != NULL) {
+		if (pslot->size > pmax->size)
+			pmax = pslot;
+		pslot = pslot->next;
 	}
-	if (index < 0)
+
+	if (!pmax)
 		return NULL;
-	*psize = best;

-	pfree[index].pid = current->pid;
-	pfree[index].flag = SRAM_SLT_ALLOCATED;
-	return addr;
+	*psize = pmax->size;
+
+	return _sram_alloc(*psize, pfree_head, pused_head);
 }

-/* L1 memory free function */
-static int _l1_sram_free(const void *addr,
-			struct l1_sram_piece *pfree,
-			int count)
+/* SRAM free function */
+static int _sram_free(const void *addr,
+			struct sram_piece *pfree_head,
+			struct sram_piece *pused_head)
 {
-	int i, index = 0;
+	struct sram_piece *pslot, *plast, *pavail;
+
+	if (!pfree_head || !pused_head)
+		return -1;

 	/* search the relevant memory slot */
-	for (i = 0; i < count; i++) {
-		if (pfree[i].paddr == addr) {
-			if (pfree[i].flag != SRAM_SLT_ALLOCATED) {
-				/* error log */
-				return -1;
-			}
-			index = i;
-			break;
-		}
+	pslot = pused_head->next;
+	plast = pused_head;
+
+	/* search an available piece slot */
+	while (pslot != NULL && pslot->paddr != addr) {
+		plast = pslot;
+		pslot = pslot->next;
 	}
-	if (i >= count)
+
+	if (!pslot)
 		return -1;

-	pfree[index].pid = 0;
-	pfree[index].flag = SRAM_SLT_FREE;
-
-	/* link the next address slot */
-	for (i = 0; i < count; i++) {
-		if (((pfree[index].paddr + pfree[index].size) == pfree[i].paddr)
-		    && (pfree[i].flag == SRAM_SLT_FREE)) {
-			pfree[i].pid = 0;
-			pfree[i].flag = SRAM_SLT_NULL;
-			pfree[index].size += pfree[i].size;
-			pfree[index].flag = SRAM_SLT_FREE;
-			break;
-		}
+	plast->next = pslot->next;
+	pavail = pslot;
+	pavail->pid = 0;
+
+	/* insert free pieces back to the free list */
+	pslot = pfree_head->next;
+	plast = pfree_head;
+
+	while (pslot != NULL && addr > pslot->paddr) {
+		plast = pslot;
+		pslot = pslot->next;
+	}
+
+	if (plast != pfree_head && plast->paddr + plast->size == pavail->paddr) {
+		plast->size += pavail->size;
+		kmem_cache_free(sram_piece_cache, pavail);
+	} else {
+		pavail->next = plast;
+		plast->next = pavail;
+		plast = pavail;
 	}

-	/* link the last address slot */
-	for (i = 0; i < count; i++) {
-		if (((pfree[i].paddr + pfree[i].size) == pfree[index].paddr) &&
-		    (pfree[i].flag == SRAM_SLT_FREE)) {
-			pfree[index].flag = SRAM_SLT_NULL;
-			pfree[i].size += pfree[index].size;
-			break;
-		}
+	if (pslot && plast->paddr + plast->size == pslot->paddr) {
+		plast->size += pslot->size;
+		plast->next = pslot->next;
+		kmem_cache_free(sram_piece_cache, pslot);
 	}

 	return 0;
@@ -273,6 +367,11 @@ int sram_free(const void *addr)
 		 && addr < (void *)(L1_DATA_B_START + L1_DATA_B_LENGTH))
 		return l1_data_B_sram_free(addr);
 #endif
+#ifdef L2_LENGTH
+	else if (addr >= (void *)L2_START
+		 && addr < (void *)(L2_START + L2_LENGTH))
+		return l2_sram_free(addr);
+#endif
 	else
 		return -1;
 }
@@ -287,7 +386,8 @@ void *l1_data_A_sram_alloc(size_t size)
 	spin_lock_irqsave(&l1_data_sram_lock, flags);

 #if L1_DATA_A_LENGTH != 0
-	addr = _l1_sram_alloc(size, l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
+	addr = _sram_alloc(size, &free_l1_data_A_sram_head,
+			&used_l1_data_A_sram_head);
 #endif

 	/* add mutex operation */
@@ -309,8 +409,8 @@ int l1_data_A_sram_free(const void *addr)
 	spin_lock_irqsave(&l1_data_sram_lock, flags);

 #if L1_DATA_A_LENGTH != 0
-	ret = _l1_sram_free(addr,
-			   l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
+	ret = _sram_free(addr, &free_l1_data_A_sram_head,
+			&used_l1_data_A_sram_head);
 #else
 	ret = -1;
 #endif
@@ -331,7 +431,8 @@ void *l1_data_B_sram_alloc(size_t size)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1_data_sram_lock, flags);

-	addr = _l1_sram_alloc(size, l1_data_B_sram, ARRAY_SIZE(l1_data_B_sram));
+	addr = _sram_alloc(size, &free_l1_data_B_sram_head,
+			&used_l1_data_B_sram_head);

 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1_data_sram_lock, flags);
@@ -355,7 +456,8 @@ int l1_data_B_sram_free(const void *addr)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1_data_sram_lock, flags);

-	ret = _l1_sram_free(addr, l1_data_B_sram, ARRAY_SIZE(l1_data_B_sram));
+	ret = _sram_free(addr, &free_l1_data_B_sram_head,
+			&used_l1_data_B_sram_head);

 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1_data_sram_lock, flags);
@@ -408,7 +510,8 @@ void *l1_inst_sram_alloc(size_t size)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1_inst_sram_lock, flags);

-	addr = _l1_sram_alloc(size, l1_inst_sram, ARRAY_SIZE(l1_inst_sram));
+	addr = _sram_alloc(size, &free_l1_inst_sram_head,
+			&used_l1_inst_sram_head);

 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1_inst_sram_lock, flags);
@@ -432,7 +535,8 @@ int l1_inst_sram_free(const void *addr)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1_inst_sram_lock, flags);

-	ret = _l1_sram_free(addr, l1_inst_sram, ARRAY_SIZE(l1_inst_sram));
+	ret = _sram_free(addr, &free_l1_inst_sram_head,
+			&used_l1_inst_sram_head);

 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1_inst_sram_lock, flags);
@@ -453,7 +557,8 @@ void *l1sram_alloc(size_t size)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1sram_lock, flags);

-	addr = _l1_sram_alloc(size, l1_ssram, ARRAY_SIZE(l1_ssram));
+	addr = _sram_alloc(size, &free_l1_ssram_head,
+			&used_l1_ssram_head);

 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1sram_lock, flags);
@@ -470,7 +575,8 @@ void *l1sram_alloc_max(size_t *psize)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1sram_lock, flags);

-	addr = _l1_sram_alloc_max(l1_ssram, ARRAY_SIZE(l1_ssram), psize);
+	addr = _sram_alloc_max(&free_l1_ssram_head,
+			&used_l1_ssram_head, psize);

 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1sram_lock, flags);
@@ -487,7 +593,8 @@ int l1sram_free(const void *addr)
 	/* add mutex operation */
 	spin_lock_irqsave(&l1sram_lock, flags);

-	ret = _l1_sram_free(addr, l1_ssram, ARRAY_SIZE(l1_ssram));
+	ret = _sram_free(addr, &free_l1_ssram_head,
+			&used_l1_ssram_head);

 	/* add mutex operation */
 	spin_unlock_irqrestore(&l1sram_lock, flags);
@@ -495,6 +602,64 @@ int l1sram_free(const void *addr)
 	return ret;
 }

+void *l2_sram_alloc(size_t size)
+{
+#ifdef L2_LENGTH
+	unsigned flags;
+	void *addr;
+
+	/* add mutex operation */
+	spin_lock_irqsave(&l2_sram_lock, flags);
+
+	addr = _sram_alloc(size, &free_l2_sram_head,
+			&used_l2_sram_head);
+
+	/* add mutex operation */
+	spin_unlock_irqrestore(&l2_sram_lock, flags);
+
+	pr_debug("Allocated address in l2_sram_alloc is 0x%lx+0x%lx\n",
+		 (long unsigned int)addr, size);
+
+	return addr;
+#else
+	return NULL;
+#endif
+}
+EXPORT_SYMBOL(l2_sram_alloc);
+
+void *l2_sram_zalloc(size_t size)
+{
+	void *addr = l2_sram_alloc(size);
+
+	if (addr)
+		memset(addr, 0x00, size);
+
+	return addr;
+}
+EXPORT_SYMBOL(l2_sram_zalloc);
+
+int l2_sram_free(const void *addr)
+{
+#ifdef L2_LENGTH
+	unsigned flags;
+	int ret;
+
+	/* add mutex operation */
+	spin_lock_irqsave(&l2_sram_lock, flags);
+
+	ret = _sram_free(addr, &free_l2_sram_head,
+			&used_l2_sram_head);
+
+	/* add mutex operation */
+	spin_unlock_irqrestore(&l2_sram_lock, flags);
+
+	return ret;
+#else
+	return -1;
+#endif
+}
+EXPORT_SYMBOL(l2_sram_free);
+
 int sram_free_with_lsl(const void *addr)
 {
 	struct sram_list_struct *lsl, **tmp;
@@ -533,6 +698,9 @@ void *sram_alloc_with_lsl(size_t size, unsigned long flags)
 	if (addr == NULL && (flags & L1_DATA_B_SRAM))
 		addr = l1_data_B_sram_alloc(size);

+	if (addr == NULL && (flags & L2_SRAM))
+		addr = l2_sram_alloc(size);
+
 	if (addr == NULL) {
 		kfree(lsl);
 		return NULL;
@@ -549,49 +717,80 @@ EXPORT_SYMBOL(sram_alloc_with_lsl);
 /* Once we get a real allocator, we'll throw all of this away.
  * Until then, we need some sort of visibility into the L1 alloc.
  */
-static void _l1sram_proc_read(char *buf, int *len, const char *desc,
-		struct l1_sram_piece *pfree, const int array_size)
+/* Need to keep line of output the same.  Currently, that is 44 bytes
+ * (including newline).
+ */
+static int _sram_proc_read(char *buf, int *len, int count, const char *desc,
+		struct sram_piece *pfree_head,
+		struct sram_piece *pused_head)
 {
-	int i;
-
-	*len += sprintf(&buf[*len], "--- L1 %-14s Size  PID State\n", desc);
-	for (i = 0; i < array_size; ++i) {
-		const char *alloc_type;
-		switch (pfree[i].flag) {
-		case SRAM_SLT_NULL:      alloc_type = "NULL"; break;
-		case SRAM_SLT_FREE:      alloc_type = "FREE"; break;
-		case SRAM_SLT_ALLOCATED: alloc_type = "ALLOCATED"; break;
-		default:                 alloc_type = "????"; break;
-		}
-		*len += sprintf(&buf[*len], "%p-%p %8i %4i %s\n",
-			pfree[i].paddr, pfree[i].paddr + pfree[i].size,
-			pfree[i].size, pfree[i].pid, alloc_type);
+	struct sram_piece *pslot;
+
+	if (!pfree_head || !pused_head)
+		return -1;
+
+	*len += sprintf(&buf[*len], "--- SRAM %-14s Size   PID State     \n", desc);
+
+	/* search the relevant memory slot */
+	pslot = pused_head->next;
+
+	while (pslot != NULL) {
+		*len += sprintf(&buf[*len], "%p-%p %10i %5i %-10s\n",
+			pslot->paddr, pslot->paddr + pslot->size,
+			pslot->size, pslot->pid, "ALLOCATED");
+
+		pslot = pslot->next;
 	}
+
+	pslot = pfree_head->next;
+
+	while (pslot != NULL) {
+		*len += sprintf(&buf[*len], "%p-%p %10i %5i %-10s\n",
+			pslot->paddr, pslot->paddr + pslot->size,
+			pslot->size, pslot->pid, "FREE");
+
+		pslot = pslot->next;
+	}
+
+	return 0;
 }
-static int l1sram_proc_read(char *buf, char **start, off_t offset, int count,
+static int sram_proc_read(char *buf, char **start, off_t offset, int count,
 		int *eof, void *data)
 {
 	int len = 0;

-	_l1sram_proc_read(buf, &len, "Scratchpad",
-			l1_ssram, ARRAY_SIZE(l1_ssram));
+	if (_sram_proc_read(buf, &len, count, "Scratchpad",
+			&free_l1_ssram_head, &used_l1_ssram_head))
+		goto not_done;
 #if L1_DATA_A_LENGTH != 0
-	_l1sram_proc_read(buf, &len, "Data A",
-			l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
+	if (_sram_proc_read(buf, &len, count, "L1 Data A",
+			&free_l1_data_A_sram_head,
+			&used_l1_data_A_sram_head))
+		goto not_done;
 #endif
 #if L1_DATA_B_LENGTH != 0
-	_l1sram_proc_read(buf, &len, "Data B",
-			l1_data_B_sram, ARRAY_SIZE(l1_data_B_sram));
+	if (_sram_proc_read(buf, &len, count, "L1 Data B",
+			&free_l1_data_B_sram_head,
+			&used_l1_data_B_sram_head))
+		goto not_done;
 #endif
 #if L1_CODE_LENGTH != 0
-	_l1sram_proc_read(buf, &len, "Instruction",
-			l1_inst_sram, ARRAY_SIZE(l1_inst_sram));
+	if (_sram_proc_read(buf, &len, count, "L1 Instruction",
+			&free_l1_inst_sram_head, &used_l1_inst_sram_head))
+		goto not_done;
+#endif
+#ifdef L2_LENGTH
+	if (_sram_proc_read(buf, &len, count, "L2",
+			&free_l2_sram_head, &used_l2_sram_head))
+		goto not_done;
 #endif

+	*eof = 1;
+ not_done:
 	return len;
 }

-static int __init l1sram_proc_init(void)
+static int __init sram_proc_init(void)
 {
 	struct proc_dir_entry *ptr;
 	ptr = create_proc_entry("sram", S_IFREG | S_IRUGO, NULL);
@@ -600,8 +799,8 @@ static int __init l1sram_proc_init(void)
 		return -1;
 	}
 	ptr->owner = THIS_MODULE;
-	ptr->read_proc = l1sram_proc_read;
+	ptr->read_proc = sram_proc_read;
 	return 0;
 }
-late_initcall(l1sram_proc_init);
+late_initcall(sram_proc_init);
 #endif
diff --git a/arch/blackfin/mm/blackfin_sram.h b/arch/blackfin/mm/blackfin_sram.h
index 0fb73b7..8cb0945 100644
--- a/arch/blackfin/mm/blackfin_sram.h
+++ b/arch/blackfin/mm/blackfin_sram.h
@@ -30,9 +30,7 @@
 #ifndef __BLACKFIN_SRAM_H__
 #define __BLACKFIN_SRAM_H__

-extern void l1sram_init(void);
-extern void l1_inst_sram_init(void);
-extern void l1_data_sram_init(void);
+extern void bfin_sram_init(void);
 extern void *l1sram_alloc(size_t);

 #endif
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index ec3141f..4aab21f 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -164,11 +164,14 @@ void __init mem_init(void)
 		"(%uk init code, %uk kernel code, %uk data, %uk dma, %uk reserved)\n",
 		(unsigned long) freepages << (PAGE_SHIFT-10), _ramend >> 10,
 		initk, codek, datak, DMA_UNCACHED_REGION >> 10, (reservedpages <<
(PAGE_SHIFT-10)));
+}
+
+static int __init sram_init(void)
+{
+	unsigned long tmp;

 	/* Initialize the blackfin L1 Memory. */
-	l1sram_init();
-	l1_data_sram_init();
-	l1_inst_sram_init();
+	bfin_sram_init();

 	/* Allocate this once; never free it.  We assume this gives us a
 	   pointer to the start of L1 scratchpad memory; panic if it
@@ -179,7 +182,10 @@ void __init mem_init(void)
 			tmp, (unsigned long)L1_SCRATCH_TASK_INFO);
 		panic("No L1, time to give up\n");
 	}
+
+	return 0;
 }
+pure_initcall(sram_init);

 static void __init free_init_pages(const char *what, unsigned long
begin, unsigned long end)
 {
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index fd9bb77..f069309 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1,7 +1,7 @@
 /*
  * Blackfin On-Chip Serial Driver
  *
- * Copyright 2006-2007 Analog Devices Inc.
+ * Copyright 2006-2008 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -42,6 +42,9 @@
 #define BFIN_SERIAL_MAJOR	204
 #define BFIN_SERIAL_MINOR	64

+static struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
+static int nr_active_ports = ARRAY_SIZE(bfin_serial_resource);
+
 /*
  * Setup for console. Argument comes from the menuconfig
  */
@@ -126,13 +129,13 @@ static int kgdb_entry_state;
 void kgdb_put_debug_char(int chr)
 {
 	struct bfin_serial_port *uart;
-	
+
 	if (CONFIG_KGDB_UART_PORT < 0
 		|| CONFIG_KGDB_UART_PORT >= BFIN_UART_NR_PORTS)
 		uart = &bfin_serial_ports[0];
 	else
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
-	
+
 	while (!(UART_GET_LSR(uart) & THRE)) {
 		SSYNC();
 	}
@@ -152,7 +155,7 @@ int kgdb_get_debug_char(void)
 		uart = &bfin_serial_ports[0];
 	else
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
-	
+
 	while(!(UART_GET_LSR(uart) & DR)) {
 		SSYNC();
 	}
@@ -859,7 +862,7 @@ static void __init bfin_serial_init_ports(void)
 		return;
 	first = 0;

-	for (i = 0; i < nr_ports; i++) {
+	for (i = 0; i < nr_active_ports; i++) {
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;
 		bfin_serial_ports[i].port.line      = i;
@@ -961,7 +964,7 @@ bfin_serial_console_setup(struct console *co, char *options)
 	 * if so, search for the first available port that does have
 	 * console support.
 	 */
-	if (co->index == -1 || co->index >= nr_ports)
+	if (co->index == -1 || co->index >= nr_active_ports)
 		co->index = 0;
 	uart = &bfin_serial_ports[co->index];

@@ -1056,7 +1059,7 @@ static __init void early_serial_write(struct
console *con, const char *s,
 	}
 }

-static struct __init console bfin_early_serial_console = {
+static struct __initdata console bfin_early_serial_console = {
 	.name = "early_BFuart",
 	.write = early_serial_write,
 	.device = uart_console_device,
@@ -1072,7 +1075,7 @@ struct console __init
*bfin_earlyserial_init(unsigned int port,
 	struct bfin_serial_port *uart;
 	struct ktermios t;

-	if (port == -1 || port >= nr_ports)
+	if (port == -1 || port >= nr_active_ports)
 		port = 0;
 	bfin_serial_init_ports();
 	bfin_early_serial_console.index = port;
@@ -1100,20 +1103,26 @@ static struct uart_driver bfin_serial_reg = {

 static int bfin_serial_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct bfin_serial_port *uart = platform_get_drvdata(dev);
+	int i;

-	if (uart)
-		uart_suspend_port(&bfin_serial_reg, &uart->port);
+	for (i = 0; i < nr_active_ports; i++) {
+		if (bfin_serial_ports[i].port.dev != &dev->dev)
+			continue;
+		uart_suspend_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
+	}

 	return 0;
 }

 static int bfin_serial_resume(struct platform_device *dev)
 {
-	struct bfin_serial_port *uart = platform_get_drvdata(dev);
+	int i;

-	if (uart)
-		uart_resume_port(&bfin_serial_reg, &uart->port);
+	for (i = 0; i < nr_active_ports; i++) {
+		if (bfin_serial_ports[i].port.dev != &dev->dev)
+			continue;
+		uart_resume_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
+	}

 	return 0;
 }
@@ -1128,32 +1137,31 @@ static int bfin_serial_probe(struct
platform_device *dev)
 			break;

 	if (i < dev->num_resources) {
-		for (i = 0; i < nr_ports; i++, res++) {
+		for (i = 0; i < nr_active_ports; i++, res++) {
 			if (bfin_serial_ports[i].port.mapbase != res->start)
 				continue;
 			bfin_serial_ports[i].port.dev = &dev->dev;
 			uart_add_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
-			platform_set_drvdata(dev, &bfin_serial_ports[i]);
 		}
 	}

 	return 0;
 }

-static int bfin_serial_remove(struct platform_device *pdev)
+static int bfin_serial_remove(struct platform_device *dev)
 {
-	struct bfin_serial_port *uart = platform_get_drvdata(pdev);
-
+	int i;

+	for (i = 0; i < nr_active_ports; i++) {
+		if (bfin_serial_ports[i].port.dev != &dev->dev)
+			continue;
+		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
+		bfin_serial_ports[i].port.dev = NULL;
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	gpio_free(uart->cts_pin);
-	gpio_free(uart->rts_pin);
+		gpio_free(bfin_serial_ports[i].cts_pin);
+		gpio_free(bfin_serial_ports[i].rts_pin);
 #endif
-
-	platform_set_drvdata(pdev, NULL);
-
-	if (uart)
-		uart_remove_one_port(&bfin_serial_reg, &uart->port);
+	}

 	return 0;
 }
diff --git a/include/asm-blackfin/bfin-global.h
b/include/asm-blackfin/bfin-global.h
index 7603383..320aa5e 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -92,16 +92,20 @@ extern void *l1_data_B_sram_alloc(size_t);
 extern void *l1_inst_sram_alloc(size_t);
 extern void *l1_data_sram_alloc(size_t);
 extern void *l1_data_sram_zalloc(size_t);
+extern void *l2_sram_alloc(size_t);
+extern void *l2_sram_zalloc(size_t);
 extern int l1_data_A_sram_free(const void*);
 extern int l1_data_B_sram_free(const void*);
 extern int l1_inst_sram_free(const void*);
 extern int l1_data_sram_free(const void*);
+extern int l2_sram_free(const void *);
 extern int sram_free(const void*);

 #define L1_INST_SRAM		0x00000001
 #define L1_DATA_A_SRAM		0x00000002
 #define L1_DATA_B_SRAM		0x00000004
 #define L1_DATA_SRAM		0x00000006
+#define L2_SRAM			0x00000008
 extern void *sram_alloc_with_lsl(size_t, unsigned long);
 extern int sram_free_with_lsl(const void*);

@@ -114,7 +118,9 @@ extern struct file_operations dpmc_fops;
 extern unsigned long _ramstart, _ramend, _rambase;
 extern unsigned long memory_start, memory_end, physical_mem_end;
 extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
-    _ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _ebss_b_l1[];
+	_ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _ebss_b_l1[],
+	_stext_l2[], _etext_l2[], _sdata_l2[], _edata_l2[], _sbss_l2[],
+	_ebss_l2[], _l2_lma_start[];

 #ifdef CONFIG_MTD_UCLINUX
 extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
diff --git a/include/asm-blackfin/dma.h b/include/asm-blackfin/dma.h
index c0d5259..3cd4b52 100644
--- a/include/asm-blackfin/dma.h
+++ b/include/asm-blackfin/dma.h
@@ -144,8 +144,16 @@ struct dma_channel {
 	void *data;
 	unsigned int dma_enable_flag;
 	unsigned int loopback_flag;
+#ifdef CONFIG_PM
+	unsigned short saved_peripheral_map;
+#endif
 };

+#ifdef CONFIG_PM
+int blackfin_dma_suspend(void);
+void blackfin_dma_resume(void);
+#endif
+
 /*******************************************************************************
 *	DMA API's
 *******************************************************************************/
diff --git a/include/asm-blackfin/dpmc.h b/include/asm-blackfin/dpmc.h
index 7f34cd3..de28e6e 100644
--- a/include/asm-blackfin/dpmc.h
+++ b/include/asm-blackfin/dpmc.h
@@ -7,63 +7,18 @@
 #ifndef _BLACKFIN_DPMC_H_
 #define _BLACKFIN_DPMC_H_

-#define SLEEP_MODE		1
-#define DEEP_SLEEP_MODE		2
-#define ACTIVE_PLL_DISABLED	3
-#define FULLON_MODE		4
-#define ACTIVE_PLL_ENABLED	5
-#define HIBERNATE_MODE		6
-
-#define IOCTL_FULL_ON_MODE	_IO('s', 0xA0)
-#define IOCTL_ACTIVE_MODE	_IO('s', 0xA1)
-#define IOCTL_SLEEP_MODE	_IO('s', 0xA2)
-#define IOCTL_DEEP_SLEEP_MODE	_IO('s', 0xA3)
-#define IOCTL_HIBERNATE_MODE	_IO('s', 0xA4)
-#define IOCTL_CHANGE_FREQUENCY	_IOW('s', 0xA5, unsigned long)
-#define IOCTL_CHANGE_VOLTAGE	_IOW('s', 0xA6, unsigned long)
-#define IOCTL_SET_CCLK		_IOW('s', 0xA7, unsigned long)
-#define IOCTL_SET_SCLK		_IOW('s', 0xA8, unsigned long)
-#define IOCTL_GET_PLLSTATUS	_IOW('s', 0xA9, unsigned long)
-#define IOCTL_GET_CORECLOCK	_IOW('s', 0xAA, unsigned long)
-#define IOCTL_GET_SYSTEMCLOCK	_IOW('s', 0xAB, unsigned long)
-#define IOCTL_GET_VCO		_IOW('s', 0xAC, unsigned long)
-#define IOCTL_DISABLE_WDOG_TIMER _IO('s', 0xAD)
-#define IOCTL_UNMASK_WDOG_WAKEUP_EVENT _IO('s',0xAE)
-#define IOCTL_PROGRAM_WDOG_TIMER _IOW('s',0xAF,unsigned long)
-#define IOCTL_CLEAR_WDOG_WAKEUP_EVENT _IO('s',0xB0)
-#define IOCTL_SLEEP_DEEPER_MODE _IO('s',0xB1)
-
-#define DPMC_MINOR		254
-
-#define ON	0
-#define OFF	1
-
 #ifdef __KERNEL__
+#ifndef __ASSEMBLY__

-unsigned long calc_volt(void);
-int calc_vlev(int vlt);
-unsigned long change_voltage(unsigned long volt);
-int calc_msel(int vco_hz);
-unsigned long change_frequency(unsigned long vco_mhz);
-int set_pll_div(unsigned short sel, unsigned char flag);
-int get_vco(void);
-unsigned long change_system_clock(unsigned long clock);
-unsigned long change_core_clock(unsigned long clock);
-unsigned long get_pll_status(void);
-void change_baud(int baud);
-void fullon_mode(void);
-void active_mode(void);
 void sleep_mode(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
 void deep_sleep(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
 void hibernate_mode(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
 void sleep_deeper(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
-void program_wdog_timer(unsigned long);
-void unmask_wdog_wakeup_evt(void);
-void clear_wdog_wakeup_evt(void);
-void disable_wdog_timer(void);
+void do_hibernate(int wakeup);
+void set_dram_srfs(void);
+void unset_dram_srfs(void);

-extern unsigned long get_cclk(void);
-extern unsigned long get_sclk(void);
+#define VRPAIR(vlev, freq) (((vlev) << 16) | ((freq) >> 16))

 struct bfin_dpmc_platform_data {
 	const unsigned int *tuple_tab;
@@ -71,8 +26,33 @@ struct bfin_dpmc_platform_data {
 	unsigned short vr_settling_time; /* in us */
 };

-#define VRPAIR(vlev, freq) (((vlev) << 16) | ((freq) >> 16))
+#else
+
+#define PM_PUSH(x) \
+	R0 = [P0 + (x - SRAM_BASE_ADDRESS)];\
+	[--SP] =  R0;\
+
+#define PM_POP(x) \
+	R0 = [SP++];\
+	[P0 + (x - SRAM_BASE_ADDRESS)] = R0;\
+
+#define PM_SYS_PUSH(x) \
+	R0 = [P0 + (x - PLL_CTL)];\
+	[--SP] =  R0;\
+
+#define PM_SYS_POP(x) \
+	R0 = [SP++];\
+	[P0 + (x - PLL_CTL)] = R0;\
+
+#define PM_SYS_PUSH16(x) \
+	R0 = w[P0 + (x - PLL_CTL)];\
+	[--SP] =  R0;\
+
+#define PM_SYS_POP16(x) \
+	R0 = [SP++];\
+	w[P0 + (x - PLL_CTL)] = R0;\

+#endif
 #endif	/* __KERNEL__ */

 #endif	/*_BLACKFIN_DPMC_H_*/
diff --git a/include/asm-blackfin/elf.h b/include/asm-blackfin/elf.h
index 30303fc..67a03a8 100644
--- a/include/asm-blackfin/elf.h
+++ b/include/asm-blackfin/elf.h
@@ -15,6 +15,8 @@
 #define EF_BFIN_FDPIC		0x00000002	/* -mfdpic */
 #define EF_BFIN_CODE_IN_L1	0x00000010	/* --code-in-l1 */
 #define EF_BFIN_DATA_IN_L1	0x00000020	/* --data-in-l1 */
+#define EF_BFIN_CODE_IN_L2	0x00000040	/* --code-in-l2 */
+#define EF_BFIN_DATA_IN_L2	0x00000080	/* --data-in-l2 */

 typedef unsigned long elf_greg_t;

diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index ff95e9d..168f125 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -376,8 +376,12 @@ struct gpio_port_t {
 #endif

 #ifdef CONFIG_PM
-unsigned int bfin_pm_setup(void);
-void bfin_pm_restore(void);
+
+unsigned int bfin_pm_standby_setup(void);
+void bfin_pm_standby_restore(void);
+
+void bfin_gpio_pm_hibernate_restore(void);
+void bfin_gpio_pm_hibernate_suspend(void);

 #ifndef CONFIG_BF54x
 #define PM_WAKE_RISING	0x1
@@ -392,17 +396,8 @@ void gpio_pm_wakeup_free(unsigned gpio);

 struct gpio_port_s {
 	unsigned short data;
-	unsigned short data_clear;
-	unsigned short data_set;
-	unsigned short toggle;
 	unsigned short maska;
-	unsigned short maska_clear;
-	unsigned short maska_set;
-	unsigned short maska_toggle;
 	unsigned short maskb;
-	unsigned short maskb_clear;
-	unsigned short maskb_set;
-	unsigned short maskb_toggle;
 	unsigned short dir;
 	unsigned short polar;
 	unsigned short edge;
@@ -411,10 +406,10 @@ struct gpio_port_s {

 	unsigned short fer;
 	unsigned short reserved;
+	unsigned short mux;
 };
 #endif /*CONFIG_BF54x*/
 #endif /*CONFIG_PM*/
-
 /***********************************************************
 *
 * FUNCTIONS: Blackfin GPIO Driver
diff --git a/include/asm-blackfin/mach-bf527/anomaly.h
b/include/asm-blackfin/mach-bf527/anomaly.h
index 4725268..b7b166f 100644
--- a/include/asm-blackfin/mach-bf527/anomaly.h
+++ b/include/asm-blackfin/mach-bf527/anomaly.h
@@ -23,6 +23,8 @@
 #define ANOMALY_05000245 (1)
 /* Sensitivity To Noise with Slow Input Edge Rates on External SPORT
TX and RX Clocks */
 #define ANOMALY_05000265 (1)
+/* New Feature: EMAC TX DMA Word Alignment */
+#define ANOMALY_05000285 (1)
 /* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are
Interrupted */
 #define ANOMALY_05000312 (1)
 /* Incorrect Access of OTP_STATUS During otp_write() Function */
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index 2526b6e..a23d047 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -119,7 +119,6 @@ static inline void UART_CLEAR_LSR(struct
bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }

-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long uart_base_addr;
 	int uart_irq;
@@ -164,8 +163,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };

-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"

 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/include/asm-blackfin/mach-bf527/bfin_sir.h
b/include/asm-blackfin/mach-bf527/bfin_sir.h
index 0612d0c..cfd8ad4 100644
--- a/include/asm-blackfin/mach-bf527/bfin_sir.h
+++ b/include/asm-blackfin/mach-bf527/bfin_sir.h
@@ -118,16 +118,25 @@ static inline void SIR_UART_CLEAR_LSR(struct
bfin_sir_port *port)

 #define DRIVER_NAME "bfin_sir"

-static void bfin_sir_hw_init(void)
+static int bfin_sir_hw_init(void)
 {
+	int ret = -ENODEV;
 #ifdef CONFIG_BFIN_SIR0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART0_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART0_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif

 #ifdef CONFIG_BFIN_SIR1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART1_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART1_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif
-	SSYNC();
+	return ret;
 }
diff --git a/include/asm-blackfin/mach-bf527/defBF527.h
b/include/asm-blackfin/mach-bf527/defBF527.h
index 82134f5..f1a70db 100644
--- a/include/asm-blackfin/mach-bf527/defBF527.h
+++ b/include/asm-blackfin/mach-bf527/defBF527.h
@@ -302,6 +302,7 @@
 #define	PHYIE             0x00000001    /* PHY_INT Interrupt Enable
                            */
 #define	RXDWA             0x00000002    /* Receive Frame DMA Word
Alignment (Odd/Even*)           */
 #define	RXCKS             0x00000004    /* Enable RX Frame TCP/UDP
Checksum Computation           */
+#define	TXDWA             0x00000010    /* Transmit Frame DMA Word
Alignment (Odd/Even*)          */
 #define	MDCDIV            0x00003F00    /* SCLK:MDC Clock Divisor
[MDC=SCLK/(2*(N+1))]            */

 #define	SET_MDCDIV(x) (((x)&0x3F)<< 8)   /* Set MDC Clock Divisor
                            */
diff --git a/include/asm-blackfin/mach-bf527/mem_init.h
b/include/asm-blackfin/mach-bf527/mem_init.h
index 008ca66..cbe03f4 100644
--- a/include/asm-blackfin/mach-bf527/mem_init.h
+++ b/include/asm-blackfin/mach-bf527/mem_init.h
@@ -146,33 +146,6 @@
 #define SDRAM_CL    CL_3
 #endif

-#if (CONFIG_MEM_SIZE == 128)
-#define SDRAM_SIZE      EBSZ_128
-#endif
-#if (CONFIG_MEM_SIZE == 64)
-#define SDRAM_SIZE      EBSZ_64
-#endif
-#if (CONFIG_MEM_SIZE == 32)
-#define SDRAM_SIZE      EBSZ_32
-#endif
-#if (CONFIG_MEM_SIZE == 16)
-#define SDRAM_SIZE      EBSZ_16
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 11)
-#define SDRAM_WIDTH     EBCAW_11
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 10)
-#define SDRAM_WIDTH     EBCAW_10
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 9)
-#define SDRAM_WIDTH     EBCAW_9
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 8)
-#define SDRAM_WIDTH     EBCAW_8
-#endif
-
-#define mem_SDBCTL      (SDRAM_WIDTH | SDRAM_SIZE | EBE)
-
 /* Equation from section 17 (p17-46) of BF533 HRM */
 #define mem_SDRRC       (((CONFIG_SCLK_HZ / 1000) * SDRAM_Tref) /
SDRAM_NRA) - (SDRAM_tRAS_num + SDRAM_tRP_num)

diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index ebf592b..20471cd 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -111,7 +111,6 @@ static inline void UART_CLEAR_LSR(struct
bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }

-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -142,7 +141,6 @@ struct bfin_serial_res bfin_serial_resource[] = {

 #define DRIVER_NAME "bfin-uart"

-int nr_ports = BFIN_UART_NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {

diff --git a/include/asm-blackfin/mach-bf533/bfin_sir.h
b/include/asm-blackfin/mach-bf533/bfin_sir.h
index cefcf8b..9bb87e9 100644
--- a/include/asm-blackfin/mach-bf533/bfin_sir.h
+++ b/include/asm-blackfin/mach-bf533/bfin_sir.h
@@ -110,11 +110,16 @@ static inline void SIR_UART_CLEAR_LSR(struct
bfin_sir_port *port)

 #define DRIVER_NAME "bfin_sir"

-static void bfin_sir_hw_init(void)
+static int bfin_sir_hw_init(void)
 {
+	int ret = -ENODEV;
 #ifdef CONFIG_BFIN_SIR0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART0_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART0_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif
-	SSYNC();
+	return ret;
 }
diff --git a/include/asm-blackfin/mach-bf533/mem_init.h
b/include/asm-blackfin/mach-bf533/mem_init.h
index f8f3190..995c06b 100644
--- a/include/asm-blackfin/mach-bf533/mem_init.h
+++ b/include/asm-blackfin/mach-bf533/mem_init.h
@@ -133,33 +133,6 @@
 #define SDRAM_CL    CL_3
 #endif

-#if (CONFIG_MEM_SIZE == 128)
-#define SDRAM_SIZE      EBSZ_128
-#endif
-#if (CONFIG_MEM_SIZE == 64)
-#define SDRAM_SIZE      EBSZ_64
-#endif
-#if (CONFIG_MEM_SIZE == 32)
-#define SDRAM_SIZE      EBSZ_32
-#endif
-#if (CONFIG_MEM_SIZE == 16)
-#define SDRAM_SIZE      EBSZ_16
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 11)
-#define SDRAM_WIDTH     EBCAW_11
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 10)
-#define SDRAM_WIDTH     EBCAW_10
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 9)
-#define SDRAM_WIDTH     EBCAW_9
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 8)
-#define SDRAM_WIDTH     EBCAW_8
-#endif
-
-#define mem_SDBCTL      (SDRAM_WIDTH | SDRAM_SIZE | EBE)
-
 /* Equation from section 17 (p17-46) of BF533 HRM */
 #define mem_SDRRC       (((CONFIG_SCLK_HZ / 1000) * SDRAM_Tref)  /
SDRAM_NRA) - (SDRAM_tRAS_num + SDRAM_tRP_num)

diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 1bf56ff..08dfe30 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -119,7 +119,6 @@ static inline void UART_CLEAR_LSR(struct
bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }

-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -164,8 +163,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };

-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"

 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/include/asm-blackfin/mach-bf537/bfin_sir.h
b/include/asm-blackfin/mach-bf537/bfin_sir.h
index 0612d0c..cfd8ad4 100644
--- a/include/asm-blackfin/mach-bf537/bfin_sir.h
+++ b/include/asm-blackfin/mach-bf537/bfin_sir.h
@@ -118,16 +118,25 @@ static inline void SIR_UART_CLEAR_LSR(struct
bfin_sir_port *port)

 #define DRIVER_NAME "bfin_sir"

-static void bfin_sir_hw_init(void)
+static int bfin_sir_hw_init(void)
 {
+	int ret = -ENODEV;
 #ifdef CONFIG_BFIN_SIR0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART0_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART0_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif

 #ifdef CONFIG_BFIN_SIR1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART1_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART1_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif
-	SSYNC();
+	return ret;
 }
diff --git a/include/asm-blackfin/mach-bf537/defBF537.h
b/include/asm-blackfin/mach-bf537/defBF537.h
index 3f45590..abde24c 100644
--- a/include/asm-blackfin/mach-bf537/defBF537.h
+++ b/include/asm-blackfin/mach-bf537/defBF537.h
@@ -290,6 +290,7 @@
 #define	PHYIE		0x00000001	/* PHY_INT Interrupt Enable
                                    */
 #define	RXDWA		0x00000002	/* Receive Frame DMA Word Alignment
(Odd/Even*)         */
 #define	RXCKS		0x00000004	/* Enable RX Frame TCP/UDP Checksum
Computation         */
+#define	TXDWA		0x00000010	/* Transmit Frame DMA Word Alignment
(Odd/Even*)        */
 #define	MDCDIV		0x00003F00	/* SCLK:MDC Clock Divisor
[MDC=SCLK/(2*(N+1))]          */

 #define	SET_MDCDIV(x)	(((x)&0x3F)<< 8)	/* Set MDC Clock Divisor
                         */
diff --git a/include/asm-blackfin/mach-bf537/mem_init.h
b/include/asm-blackfin/mach-bf537/mem_init.h
index 9ad979d..f67698f 100644
--- a/include/asm-blackfin/mach-bf537/mem_init.h
+++ b/include/asm-blackfin/mach-bf537/mem_init.h
@@ -139,33 +139,6 @@
 #define SDRAM_CL    CL_3
 #endif

-#if (CONFIG_MEM_SIZE == 128)
-#define SDRAM_SIZE      EBSZ_128
-#endif
-#if (CONFIG_MEM_SIZE == 64)
-#define SDRAM_SIZE      EBSZ_64
-#endif
-#if (CONFIG_MEM_SIZE == 32)
-#define SDRAM_SIZE      EBSZ_32
-#endif
-#if (CONFIG_MEM_SIZE == 16)
-#define SDRAM_SIZE      EBSZ_16
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 11)
-#define SDRAM_WIDTH     EBCAW_11
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 10)
-#define SDRAM_WIDTH     EBCAW_10
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 9)
-#define SDRAM_WIDTH     EBCAW_9
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 8)
-#define SDRAM_WIDTH     EBCAW_8
-#endif
-
-#define mem_SDBCTL      (SDRAM_WIDTH | SDRAM_SIZE | EBE)
-
 /* Equation from section 17 (p17-46) of BF533 HRM */
 #define mem_SDRRC       (((CONFIG_SCLK_HZ / 1000) * SDRAM_Tref) /
SDRAM_NRA) - (SDRAM_tRAS_num + SDRAM_tRP_num)

diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 5e29446..76976b1 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -105,7 +105,6 @@ struct bfin_serial_port {
 #endif
 };

-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -170,8 +169,6 @@ struct bfin_serial_res bfin_serial_resource[] = {
 #endif
 };

-int nr_ports = ARRAY_SIZE(bfin_serial_resource);
-
 #define DRIVER_NAME "bfin-uart"

 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
diff --git a/include/asm-blackfin/mach-bf548/bfin_sir.h
b/include/asm-blackfin/mach-bf548/bfin_sir.h
index 5e94271..c41f9cf 100644
--- a/include/asm-blackfin/mach-bf548/bfin_sir.h
+++ b/include/asm-blackfin/mach-bf548/bfin_sir.h
@@ -124,26 +124,43 @@ struct bfin_sir_self {

 #define DRIVER_NAME "bfin_sir"

-static void bfin_sir_hw_init(void)
+static int bfin_sir_hw_init(void)
 {
+	int ret = -ENODEV;
 #ifdef CONFIG_BFIN_SIR0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART0_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART0_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif

 #ifdef CONFIG_BFIN_SIR1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART1_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART1_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif

 #ifdef CONFIG_BFIN_SIR2
-	peripheral_request(P_UART2_TX, DRIVER_NAME);
-	peripheral_request(P_UART2_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART2_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART2_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif

 #ifdef CONFIG_BFIN_SIR3
-	peripheral_request(P_UART3_TX, DRIVER_NAME);
-	peripheral_request(P_UART3_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART3_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART3_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif
-	SSYNC();
+	return ret;
 }
diff --git a/include/asm-blackfin/mach-bf548/gpio.h
b/include/asm-blackfin/mach-bf548/gpio.h
index cb8b0f1..bba82dc 100644
--- a/include/asm-blackfin/mach-bf548/gpio.h
+++ b/include/asm-blackfin/mach-bf548/gpio.h
@@ -209,3 +209,11 @@ struct gpio_port_t {
 	unsigned short dummy7;
 	unsigned int port_mux;
 };
+
+struct gpio_port_s {
+	unsigned short fer;
+	unsigned short data;
+	unsigned short dir;
+	unsigned short inen;
+	unsigned int mux;
+};
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index 8aa0278..6cddca4 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -111,7 +111,6 @@ static inline void UART_CLEAR_LSR(struct
bfin_serial_port *uart)
 	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
 }

-struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
 	int		uart_irq;
@@ -142,7 +141,6 @@ struct bfin_serial_res bfin_serial_resource[] = {

 #define DRIVER_NAME "bfin-uart"

-int nr_ports = BFIN_UART_NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {

diff --git a/include/asm-blackfin/mach-bf561/bfin_sir.h
b/include/asm-blackfin/mach-bf561/bfin_sir.h
index cefcf8b..9bb87e9 100644
--- a/include/asm-blackfin/mach-bf561/bfin_sir.h
+++ b/include/asm-blackfin/mach-bf561/bfin_sir.h
@@ -110,11 +110,16 @@ static inline void SIR_UART_CLEAR_LSR(struct
bfin_sir_port *port)

 #define DRIVER_NAME "bfin_sir"

-static void bfin_sir_hw_init(void)
+static int bfin_sir_hw_init(void)
 {
+	int ret = -ENODEV;
 #ifdef CONFIG_BFIN_SIR0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
+	ret = peripheral_request(P_UART0_TX, DRIVER_NAME);
+	if (ret)
+		return ret;
+	ret = peripheral_request(P_UART0_RX, DRIVER_NAME);
+	if (ret)
+		return ret;
 #endif
-	SSYNC();
+	return ret;
 }
diff --git a/include/asm-blackfin/mach-bf561/mem_init.h
b/include/asm-blackfin/mach-bf561/mem_init.h
index 439a589..e163260 100644
--- a/include/asm-blackfin/mach-bf561/mem_init.h
+++ b/include/asm-blackfin/mach-bf561/mem_init.h
@@ -131,33 +131,6 @@
 #define SDRAM_CL    CL_3
 #endif

-#if (CONFIG_MEM_SIZE == 128)
-#define SDRAM_SIZE      EB0_SZ_128
-#endif
-#if (CONFIG_MEM_SIZE == 64)
-#define SDRAM_SIZE      EB0_SZ_64
-#endif
-#if ( CONFIG_MEM_SIZE == 32)
-#define SDRAM_SIZE      EB0_SZ_32
-#endif
-#if (CONFIG_MEM_SIZE == 16)
-#define SDRAM_SIZE      EB0_SZ_16
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 11)
-#define SDRAM_WIDTH     EB0_CAW_11
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 10)
-#define SDRAM_WIDTH     EB0_CAW_10
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 9)
-#define SDRAM_WIDTH     EB0_CAW_9
-#endif
-#if (CONFIG_MEM_ADD_WIDTH == 8)
-#define SDRAM_WIDTH     EB0_CAW_8
-#endif
-
-#define mem_SDBCTL      (SDRAM_WIDTH | SDRAM_SIZE | EB0_E)
-
 /* Equation from section 17 (p17-46) of BF533 HRM */
 #define mem_SDRRC       (((CONFIG_SCLK_HZ / 1000) * SDRAM_Tref) /
SDRAM_NRA) - (SDRAM_tRAS_num + SDRAM_tRP_num)

diff --git a/include/asm-blackfin/module.h b/include/asm-blackfin/module.h
index 3c7ce16..e3128df 100644
--- a/include/asm-blackfin/module.h
+++ b/include/asm-blackfin/module.h
@@ -6,8 +6,6 @@
 #define Elf_Shdr        Elf32_Shdr
 #define Elf_Sym         Elf32_Sym
 #define Elf_Ehdr        Elf32_Ehdr
-#define FLG_CODE_IN_L1	0x10
-#define FLG_DATA_IN_L1	0x20

 struct mod_arch_specific {
 	Elf_Shdr	*text_l1;
@@ -15,5 +13,8 @@ struct mod_arch_specific {
 	Elf_Shdr	*bss_a_l1;
 	Elf_Shdr	*data_b_l1;
 	Elf_Shdr	*bss_b_l1;
+	Elf_Shdr	*text_l2;
+	Elf_Shdr	*data_l2;
+	Elf_Shdr	*bss_l2;
 };
 #endif				/* _ASM_BFIN_MODULE_H */
diff --git a/include/asm-blackfin/processor.h b/include/asm-blackfin/processor.h
index 1c00407..6f3995b 100644
--- a/include/asm-blackfin/processor.h
+++ b/include/asm-blackfin/processor.h
@@ -112,7 +112,26 @@ unsigned long get_wchan(struct task_struct *p);
 static inline uint32_t __pure bfin_revid(void)
 {
 	/* stored in the upper 4 bits */
-	return bfin_read_CHIPID() >> 28;
+	uint32_t revid = bfin_read_CHIPID() >> 28;
+
+#ifdef CONFIG_BF52x
+	/* ANOMALY_05000357
+	 * Incorrect Revision Number in DSPID Register
+	 */
+	if (revid == 0)
+		switch (bfin_read16(_BOOTROM_GET_DXE_ADDRESS_TWI)) {
+		case 0x0010:
+			revid = 0;
+			break;
+		case 0x2796:
+			revid = 1;
+			break;
+		default:
+			revid = 0xFFFF;
+			break;
+		}
+#endif
+	return revid;
 }

 static inline uint32_t __pure bfin_compiled_revid(void)
