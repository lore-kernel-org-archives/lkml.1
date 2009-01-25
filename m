Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZAYGIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZAYGIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 01:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZAYGIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 01:08:11 -0500
Received: from mail.cyberdogtech.com ([64.22.125.39]:33720 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZAYGII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 01:08:08 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2009 01:08:08 EST
Date: Sun, 25 Jan 2009 00:02:14 -0600
From: Matt LaPlante <kernel@cyberdogtech.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 2/2] Kconfig cleanup - new.
Message-Id: <20090125000214.55608957.kernel@cyberdogtech.com>
In-Reply-To: <49791C06.6010805@oracle.com>
References: <1232569236-11926-1-git-send-email-kernel1@cyberdogtech.com>
	<49791C06.6010805@oracle.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 17:23:18 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Matt LaPlante wrote:
> > These are new kconfig cleanups, as of 2.6.29-rc2.
> 
> I only reviewed the new patch since you said that the other one had
> already been approved.
> 
> 
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index e2a4ff6..d85ab89 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -71,11 +71,10 @@ config FUNCTION_GRAPH_TRACER
> >  	help
> >  	  Enable the kernel to trace a function at both its return
> >  	  and its entry.
> > -	  It's first purpose is to trace the duration of functions and
> > -	  draw a call graph for each thread with some informations like
> > -	  the return value.
> > -	  This is done by setting the current return address on the current
> > -	  task structure into a stack of calls.
> > +	  Its first purpose is to trace the duration of functions and
> > +	  draw a call graph for each thread with some information like
> > +	  the return value. This is done by setting the current return 
> > +    address on the current task structure into a stack of calls.
> 
> spacing typo.
> Fix that & add:
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks - spacing fixed; patch below.
----

These are new kconfig cleanups, as of 2.6.29-rc2.

Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/avr32/Kconfig                  |    6 +++---
 drivers/hid/Kconfig                 |    2 +-
 drivers/isdn/mISDN/Kconfig          |   10 ++++++----
 drivers/media/common/tuners/Kconfig |    2 +-
 drivers/mfd/Kconfig                 |    2 +-
 drivers/mmc/host/Kconfig            |    2 +-
 drivers/scsi/Kconfig                |    4 ++--
 drivers/staging/Kconfig             |    4 ++--
 drivers/staging/comedi/Kconfig      |    4 ++--
 drivers/staging/go7007/Kconfig      |    4 ++--
 drivers/staging/panel/Kconfig       |    2 +-
 drivers/usb/gadget/Kconfig          |    2 +-
 drivers/uwb/Kconfig                 |    4 ++--
 drivers/xen/Kconfig                 |    2 +-
 fs/Kconfig                          |    2 +-
 fs/ext4/Kconfig                     |    2 +-
 fs/ubifs/Kconfig                    |    4 ++--
 init/Kconfig                        |    2 +-
 kernel/trace/Kconfig                |    9 ++++-----
 net/phonet/Kconfig                  |    2 +-
 net/wimax/Kconfig                   |    2 +-
 sound/soc/blackfin/Kconfig          |    2 +-
 22 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index b189680..296b09c 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -127,13 +127,13 @@ config BOARD_HAMMERHEAD
 	select CPU_AT32AP7000
 	select USB_ARCH_HAS_HCD
 	help
-	  The Hammerhead platform is built around a AVR32 32-bit microcontroller from Atmel.
+	  The Hammerhead platform is built around an AVR32 32-bit microcontroller from Atmel.
 	  It offers versatile peripherals, such as ethernet, usb device, usb host etc.
 
-	  The board also incooperates a power supply and is a Power over Ethernet (PoE) Powered
+	  The board also incorporates a power supply and is a Power over Ethernet (PoE) Powered
 	  Device (PD).
 
-	  Additonally, a Cyclone III FPGA from Altera is integrated on the board. The FPGA is
+	  Additionally, a Cyclone III FPGA from Altera is integrated on the board. The FPGA is
 	  mapped into the 32-bit AVR memory bus. The FPGA offers two DDR2 SDRAM interfaces, which
 	  will cover even the most exceptional need of memory bandwidth. Together with the onboard
 	  video decoder the board is ready for video processing.
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e85c8fe..504cfaa 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -243,7 +243,7 @@ config GREENASIA_FF
 	select INPUT_FF_MEMLESS
 	---help---
 	Say Y here if you have a GreenAsia (Product ID 0x12) based game controller
-	(like MANTA Warior MM816 and SpeedLink Strike2 SL-6635) or adapter
+	(like MANTA Warrior MM816 and SpeedLink Strike2 SL-6635) or adapter
 	and want to enable force feedback support for it.
 
 config HID_TOPSEED
diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 4938355..1747a02 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -14,13 +14,15 @@ config MISDN_DSP
 	depends on MISDN
 	help
 	  Enable support for digital audio processing capability.
+
 	  This module may be used for special applications that require
-	  cross connecting of bchannels, conferencing, dtmf decoding
+	  cross connecting of bchannels, conferencing, dtmf decoding,
 	  echo cancelation, tone generation, and Blowfish encryption and
-	  decryption.
-	  It may use hardware features if available.
+	  decryption. It may use hardware features if available.
+
 	  E.g. it is required for PBX4Linux. Go to http://isdn.eversberg.eu
-	  and get more informations about this module and it's usage.
+	  and get more information about this module and its usage.
+
 	  If unsure, say 'N'.
 
 config MISDN_L1OIP
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 6f92bea..da058c1 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -147,7 +147,7 @@ config MEDIA_TUNER_XC5000
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon tuner XC5000 from Xceive.
-	  This device is only used inside a SiP called togther with a
+	  This device is only used inside a SiP called together with a
 	  demodulator for now.
 
 config MEDIA_TUNER_MXL5005S
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 06a2b0f..75f35db 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -88,7 +88,7 @@ config MENELAUS
 	help
 	  If you say yes here you get support for the Texas Instruments
 	  TWL92330/Menelaus Power Management chip. This include voltage
-	  regulators, Dual slot memory card tranceivers, real-time clock
+	  regulators, Dual slot memory card transceivers, real-time clock
 	  and other features that are often used in portable devices like
 	  cell phones and PDAs.
 
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index dfa585f..6509435 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -157,7 +157,7 @@ config MMC_SPI
 	select CRC7
 	select CRC_ITU_T
 	help
-	  Some systems accss MMC/SD/SDIO cards using a SPI controller
+	  Some systems access MMC/SD/SDIO cards using a SPI controller
 	  instead of using a "native" MMC/SD/SDIO controller.  This has a
 	  disadvantage of being relatively high overhead, but a compensating
 	  advantage of working on many systems without dedicated MMC/SD/SDIO
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 256c7be..0cc3f67 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1377,7 +1377,7 @@ config SCSI_LPFC_DEBUG_FS
 	bool "Emulex LightPulse Fibre Channel debugfs Support"
 	depends on SCSI_LPFC && DEBUG_FS
 	help
-	  This makes debugging infomation from the lpfc driver
+	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
 config SCSI_SIM710
@@ -1385,7 +1385,7 @@ config SCSI_SIM710
 	depends on (EISA || MCA) && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
-	  This driver for NCR53c710 based SCSI host adapters.
+	  This driver is for NCR53c710 based SCSI host adapters.
 
 	  It currently supports Compaq EISA cards and NCR MCA cards
 
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index ce6badd..190099a 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -4,7 +4,7 @@ menuconfig STAGING
 	---help---
 	  This option allows you to select a number of drivers that are
 	  not of the "normal" Linux kernel quality level.  These drivers
-	  are placed here in order to get a wider audience for use of
+	  are placed here in order to get a wider audience to make use of
 	  them.  Please note that these drivers are under heavy
 	  development, may or may not work, and may contain userspace
 	  interfaces that most likely will be changed in the near
@@ -12,7 +12,7 @@ menuconfig STAGING
 
 	  Using any of these drivers will taint your kernel which might
 	  affect support options from both the community, and various
-	  commercial support orginizations.
+	  commercial support organizations.
 
 	  If you wish to work on these drivers, to help improve them, or
 	  to report problems you have with them, please see the
diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index b501bfb..916e22a 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1,8 +1,8 @@
 config COMEDI
-	tristate "Data Acquision support (comedi)"
+	tristate "Data acquisition support (comedi)"
 	default N
 	---help---
-	  Enable support a wide range of data acquision devices
+	  Enable support a wide range of data acquisition devices
 	  for Linux.
 
 config COMEDI_RT
diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
index f2cf7f6..ca6ade6 100644
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@ -10,7 +10,7 @@ config VIDEO_GO7007
 	select CRC32
 	default N
 	---help---
-	  This is a video4linux driver for some wierd device...
+	  This is a video4linux driver for some weird device...
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called go7007
@@ -20,7 +20,7 @@ config VIDEO_GO7007_USB
 	depends on VIDEO_GO7007 && USB
 	default N
 	---help---
-	  This is a video4linux driver for some wierd device...
+	  This is a video4linux driver for some weird device...
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called go7007-usb
diff --git a/drivers/staging/panel/Kconfig b/drivers/staging/panel/Kconfig
index c4b30f2..3abe7c9 100644
--- a/drivers/staging/panel/Kconfig
+++ b/drivers/staging/panel/Kconfig
@@ -110,7 +110,7 @@ config PANEL_LCD_BWIDTH
 	---help---
 	  Most LCDs use a standard controller which supports hardware lines of 40
 	  characters, although sometimes only 16, 20 or 24 of them are really wired
-	  to the terminal. This results in some non-visible but adressable characters,
+	  to the terminal. This results in some non-visible but addressable characters,
 	  and is the case for most parallel LCDs. Other LCDs, and some serial ones,
 	  however, use the same line width internally as what is visible. The KS0074
 	  for example, uses 16 characters per line for 16 visible characters per line.
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 3219d13..292084f 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -390,7 +390,7 @@ config USB_GADGET_FSL_QE
 	   controllers having QE or CPM2, given minor tweaks.
 
 	   Set CONFIG_USB_GADGET to "m" to build this driver as a
-	   dynmically linked module called "fsl_qe_udc".
+	   dynamically linked module called "fsl_qe_udc".
 
 config USB_FSL_QE
 	tristate
diff --git a/drivers/uwb/Kconfig b/drivers/uwb/Kconfig
index ca78312..bac8e7a 100644
--- a/drivers/uwb/Kconfig
+++ b/drivers/uwb/Kconfig
@@ -48,10 +48,10 @@ config UWB_WHCI
         help
           This driver enables the radio controller for WHCI cards.
 
-          WHCI is an specification developed by Intel
+          WHCI is a specification developed by Intel
           (http://www.intel.com/technology/comms/wusb/whci.htm) much
           in the spirit of USB's EHCI, but for UWB and Wireless USB
-          radio/host controllers connected via memmory mapping (eg:
+          radio/host controllers connected via memory mapping (eg:
           PCI). Most of these cards come also with a Wireless USB host
           controller.
 
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 526187c..8ac9cdd 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -37,7 +37,7 @@ config XEN_COMPAT_XENFS
          The old xenstore userspace tools expect to find "xenbus"
          under /proc/xen, but "xenbus" is now found at the root of the
          xenfs filesystem.  Selecting this causes the kernel to create
-         the compatibilty mount point /proc/xen if it is running on
+         the compatibility mount point /proc/xen if it is running on
          a xen platform.
          If in doubt, say yes.
 
diff --git a/fs/Kconfig b/fs/Kconfig
index b920ad4..4baa1b3 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -323,7 +323,7 @@ config PRINT_QUOTA_WARNING
 	  Note that this behavior is currently deprecated and may go away in
 	  future. Please use notification via netlink socket instead.
 
-# Generic support for tree structured quota files. Seleted when needed.
+# Generic support for tree structured quota files. Selected when needed.
 config QUOTA_TREE
 	 tristate
 
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 7505482..418b6f3 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -18,7 +18,7 @@ config EXT4_FS
 	  filesystem; while there will be some performance gains from
 	  the delayed allocation and inode table readahead, the best
 	  performance gains will require enabling ext4 features in the
-	  filesystem, or formating a new filesystem as an ext4
+	  filesystem, or formatting a new filesystem as an ext4
 	  filesystem initially.
 
 	  To compile this file system support as a module, choose M here. The
diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
index e35b54d..830e3f7 100644
--- a/fs/ubifs/Kconfig
+++ b/fs/ubifs/Kconfig
@@ -22,7 +22,7 @@ config UBIFS_FS_ADVANCED_COMPR
 	depends on UBIFS_FS
 	help
 	  This option allows to explicitly choose which compressions, if any,
-	  are enabled in UBIFS. Removing compressors means inbility to read
+	  are enabled in UBIFS. Removing compressors means inability to read
 	  existing file systems.
 
 	  If unsure, say 'N'.
@@ -32,7 +32,7 @@ config UBIFS_FS_LZO
 	depends on UBIFS_FS
 	default y
 	help
-	   LZO compressor is generally faster then zlib but compresses worse.
+	   LZO compressor is generally faster than zlib but compresses worse.
 	   Say 'Y' if unsure.
 
 config UBIFS_FS_ZLIB
diff --git a/init/Kconfig b/init/Kconfig
index 8249715..bf7d1d5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -958,7 +958,7 @@ config INIT_ALL_POSSIBLE
 	  cpu_possible_map, some of them chose to initialize cpu_possible_map
 	  with all 1s, and others with all 0s.  When they were centralised,
 	  it was better to provide this option than to break all the archs
-	  and have several arch maintainers persuing me down dark alleys.
+	  and have several arch maintainers pursuing me down dark alleys.
 
 config STOP_MACHINE
 	bool
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e2a4ff6..d85ab89 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -71,11 +71,10 @@ config FUNCTION_GRAPH_TRACER
 	help
 	  Enable the kernel to trace a function at both its return
 	  and its entry.
-	  It's first purpose is to trace the duration of functions and
-	  draw a call graph for each thread with some informations like
-	  the return value.
-	  This is done by setting the current return address on the current
-	  task structure into a stack of calls.
+	  Its first purpose is to trace the duration of functions and
+	  draw a call graph for each thread with some information like
+	  the return value. This is done by setting the current return 
+	  address on the current task structure into a stack of calls.
 
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
diff --git a/net/phonet/Kconfig b/net/phonet/Kconfig
index 51a5669..6ec7d55 100644
--- a/net/phonet/Kconfig
+++ b/net/phonet/Kconfig
@@ -6,7 +6,7 @@ config PHONET
 	tristate "Phonet protocols family"
 	help
 	  The Phone Network protocol (PhoNet) is a packet-oriented
-	  communication protocol developped by Nokia for use with its modems.
+	  communication protocol developed by Nokia for use with its modems.
 
 	  This is required for Maemo to use cellular data connectivity (if
 	  supported). It can also be used to control Nokia phones
diff --git a/net/wimax/Kconfig b/net/wimax/Kconfig
index 18495cd..1b46747 100644
--- a/net/wimax/Kconfig
+++ b/net/wimax/Kconfig
@@ -8,7 +8,7 @@
 #
 # As well, enablement of the RFKILL code means we need the INPUT layer
 # support to inject events coming from hw rfkill switches. That
-# dependency could be killed if input.h provided appropiate means to
+# dependency could be killed if input.h provided appropriate means to
 # work when input is disabled.
 
 comment "WiMAX Wireless Broadband support requires CONFIG_INPUT enabled"
diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index 0a2f8f9..811596f 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -42,7 +42,7 @@ config SND_BF5XX_AC97
 	  You will also need to select the audio interfaces to support below.
 
 	  Note:
-	  AC97 codecs which do not implment the slot-16 mode will not function
+	  AC97 codecs which do not implement the slot-16 mode will not function
 	  properly with this driver. This driver is known to work with the
 	  Analog Devices line of AC97 codecs.
 
-- 
1.5.6.3


