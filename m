Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYKDWtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYKDWtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYKDWti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:49:38 -0500
Received: from xenotime.net ([72.52.64.118]:34882 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754838AbYKDWtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:49:36 -0500
Message-ID: <4910CE6D.1020006@xenotime.net>
Date: Tue, 04 Nov 2008 14:36:29 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/3] documentation: update header file paths
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update several Documentation/ files and a few sub-dir files (only one change
in each) to reflect changed header files locations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DMA-mapping.txt          |    2 +-
 Documentation/ioctl-number.txt         |    8 ++++----
 Documentation/kernel-parameters.txt    |    4 ++--
 Documentation/magic-number.txt         |    6 +++---
 Documentation/mips/AU1xxx_IDE.README   |    2 +-
 Documentation/powerpc/cpu_features.txt |    2 +-
 Documentation/x86/zero-page.txt        |    2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

--- lin2628-rc3.orig/Documentation/DMA-mapping.txt
+++ lin2628-rc3/Documentation/DMA-mapping.txt
@@ -26,7 +26,7 @@ mapped only for the time they are actual
 transfer.
 
 The following API will work of course even on platforms where no such
-hardware exists, see e.g. include/asm-i386/pci.h for how it is implemented on
+hardware exists, see e.g. arch/x86/include/asm/pci.h for how it is implemented on
 top of the virt_to_bus interface.
 
 First of all, you should make sure
--- lin2628-rc3.orig/Documentation/kernel-parameters.txt
+++ lin2628-rc3/Documentation/kernel-parameters.txt
@@ -480,8 +480,8 @@ and is between 256 and 4096 characters. 
 
 	clearcpuid=BITNUM [X86]
 			Disable CPUID feature X for the kernel. See
-			include/asm-x86/cpufeature.h for the valid bit numbers.
-			Note the Linux specific bits are not necessarily
+			arch/x86/include/asm/cpufeature.h for the valid bit
+			numbers. Note the Linux specific bits are not necessarily
 			stable over kernel options, but the vendor specific
 			ones should be.
 			Also note that user programs calling CPUID directly
--- lin2628-rc3.orig/Documentation/magic-number.txt
+++ lin2628-rc3/Documentation/magic-number.txt
@@ -125,14 +125,14 @@ TRIDENT_CARD_MAGIC    0x5072696E  triden
 ROUTER_MAGIC          0x524d4157  wan_device        include/linux/wanrouter.h
 SCC_MAGIC             0x52696368  gs_port           drivers/char/scc.h
 SAVEKMSG_MAGIC1       0x53415645  savekmsg          arch/*/amiga/config.c
-GDA_MAGIC             0x58464552  gda               include/asm-mips64/sn/gda.h
+GDA_MAGIC             0x58464552  gda               arch/mips/include/asm/sn/gda.h
 RED_MAGIC1            0x5a2cf071  (any)             mm/slab.c
 STL_PORTMAGIC         0x5a7182c9  stlport           include/linux/stallion.h
 EEPROM_MAGIC_VALUE    0x5ab478d2  lanai_dev         drivers/atm/lanai.c
 HDLCDRV_MAGIC         0x5ac6e778  hdlcdrv_state     include/linux/hdlcdrv.h
 EPCA_MAGIC            0x5c6df104  channel           include/linux/epca.h
 PCXX_MAGIC            0x5c6df104  channel           drivers/char/pcxx.h
-KV_MAGIC              0x5f4b565f  kernel_vars_s     include/asm-mips64/sn/klkernvars.h
+KV_MAGIC              0x5f4b565f  kernel_vars_s     arch/mips/include/asm/sn/klkernvars.h
 I810_STATE_MAGIC      0x63657373  i810_state        sound/oss/i810_audio.c
 TRIDENT_STATE_MAGIC   0x63657373  trient_state      sound/oss/trident.c
 M3_CARD_MAGIC         0x646e6f50  m3_card           sound/oss/maestro3.c
@@ -158,7 +158,7 @@ CCB_MAGIC             0xf2691ad2  ccb   
 QUEUE_MAGIC_FREE      0xf7e1c9a3  queue_entry       drivers/scsi/arm/queue.c
 QUEUE_MAGIC_USED      0xf7e1cc33  queue_entry       drivers/scsi/arm/queue.c
 HTB_CMAGIC            0xFEFAFEF1  htb_class         net/sched/sch_htb.c
-NMI_MAGIC             0x48414d4d455201 nmi_s        include/asm-mips64/sn/nmi.h
+NMI_MAGIC             0x48414d4d455201 nmi_s        arch/mips/include/asm/sn/nmi.h
 
 Note that there are also defined special per-driver magic numbers in sound
 memory management. See include/sound/sndmagic.h for complete list of them. Many
--- lin2628-rc3.orig/Documentation/powerpc/cpu_features.txt
+++ lin2628-rc3/Documentation/powerpc/cpu_features.txt
@@ -31,7 +31,7 @@ anyways).
 
 After detecting the processor type, the kernel patches out sections of code
 that shouldn't be used by writing nop's over it. Using cpufeatures requires
-just 2 macros (found in include/asm-ppc/cputable.h), as seen in head.S
+just 2 macros (found in arch/powerpc/include/asm/cputable.h), as seen in head.S
 transfer_to_handler:
 
 	#ifdef CONFIG_ALTIVEC
--- lin2628-rc3.orig/Documentation/x86/zero-page.txt
+++ lin2628-rc3/Documentation/x86/zero-page.txt
@@ -3,7 +3,7 @@ protocol of kernel. These should be fill
 real-mode setup code of the kernel. References/settings to it mainly
 are in:
 
-  include/asm-x86/bootparam.h
+  arch/x86/include/asm/bootparam.h
 
 
 Offset	Proto	Name		Meaning
--- lin2628-rc3.orig/Documentation/mips/AU1xxx_IDE.README
+++ lin2628-rc3/Documentation/mips/AU1xxx_IDE.README
@@ -44,7 +44,7 @@ FILES, CONFIGS AND COMPATABILITY
 
 Two files are introduced:
 
-  a) 'include/asm-mips/mach-au1x00/au1xxx_ide.h'
+  a) 'arch/mips/include/asm/mach-au1x00/au1xxx_ide.h'
      containes : struct _auide_hwif
                  timing parameters for PIO mode 0/1/2/3/4
                  timing parameters for MWDMA 0/1/2
--- lin2628-rc3.orig/Documentation/ioctl-number.txt
+++ lin2628-rc3/Documentation/ioctl-number.txt
@@ -84,7 +84,7 @@ Code	Seq#	Include File		Comments
 'B'	C0-FF				advanced bbus
 					<mailto:maassen@uni-freiburg.de>
 'C'	all	linux/soundcard.h
-'D'	all	asm-s390/dasd.h
+'D'	all	arch/s390/include/asm/dasd.h
 'E'	all	linux/input.h
 'F'	all	linux/fb.h
 'H'	all	linux/hiddev.h
@@ -104,7 +104,7 @@ Code	Seq#	Include File		Comments
 'S'	80-81	scsi/scsi_ioctl.h	conflict!
 'S'	82-FF	scsi/scsi.h		conflict!
 'T'	all	linux/soundcard.h	conflict!
-'T'	all	asm-i386/ioctls.h	conflict!
+'T'	all	arch/x86/include/asm/ioctls.h	conflict!
 'U'	00-EF	linux/drivers/usb/usb.h
 'V'	all	linux/vt.h
 'W'	00-1F	linux/watchdog.h	conflict!
@@ -119,7 +119,7 @@ Code	Seq#	Include File		Comments
 					<mailto:natalia@nikhefk.nikhef.nl>
 'c'	00-7F	linux/comstats.h	conflict!
 'c'	00-7F	linux/coda.h		conflict!
-'c'	80-9F	asm-s390/chsc.h
+'c'	80-9F	arch/s390/include/asm/chsc.h
 'd'	00-FF	linux/char/drm/drm/h	conflict!
 'd'	00-DF	linux/video_decoder.h	conflict!
 'd'	F0-FF	linux/digi1.h
@@ -166,7 +166,7 @@ Code	Seq#	Include File		Comments
 					<mailto:oe@port.de>
 0x80	00-1F	linux/fb.h
 0x81	00-1F	linux/videotext.h
-0x89	00-06	asm-i386/sockios.h
+0x89	00-06	arch/x86/include/asm/sockios.h
 0x89	0B-DF	linux/sockios.h
 0x89	E0-EF	linux/sockios.h		SIOCPROTOPRIVATE range
 0x89	F0-FF	linux/sockios.h		SIOCDEVPRIVATE range
