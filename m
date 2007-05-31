Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbXEaJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbXEaJ2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXEaJ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:27:47 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37197
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbXEaJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:27:42 -0400
From: Rob Landley <rob@landley.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
Date: Thu, 31 May 2007 03:04:15 -0400
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
References: <200705222225.39949.rob@landley.net> <200705230025.45007.rob@landley.net> <Pine.LNX.4.64.0705230922580.19474@anakin>
In-Reply-To: <Pine.LNX.4.64.0705230922580.19474@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310304.16503.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>
Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Move architecture-specific Documentation into a common subdirectory.

--

  Equivalent to:

  cd Documentation
  mkdir -p arch/amiga
  git-mv zorro.txt m68k/README.buddha arch/amiga
  git-mv arm cris blackfin parisc powerpc s390 x86_64 uml arch
  git-mv sh mips fujitsu/frv m68k ia64 i386 sparc arch

diff --git a/Documentation/m68k/README.buddha b/Documentation/arch/amiga/README.buddha
similarity index 100%
rename from Documentation/m68k/README.buddha
rename to Documentation/arch/amiga/README.buddha
diff --git a/Documentation/zorro.txt b/Documentation/arch/amiga/zorro.txt
similarity index 100%
rename from Documentation/zorro.txt
rename to Documentation/arch/amiga/zorro.txt
diff --git a/Documentation/arm/00-INDEX b/Documentation/arch/arm/00-INDEX
similarity index 100%
rename from Documentation/arm/00-INDEX
rename to Documentation/arch/arm/00-INDEX
diff --git a/Documentation/arm/Booting b/Documentation/arch/arm/Booting
similarity index 100%
rename from Documentation/arm/Booting
rename to Documentation/arch/arm/Booting
diff --git a/Documentation/arm/IXP2000 b/Documentation/arch/arm/IXP2000
similarity index 100%
rename from Documentation/arm/IXP2000
rename to Documentation/arch/arm/IXP2000
diff --git a/Documentation/arm/IXP4xx b/Documentation/arch/arm/IXP4xx
similarity index 100%
rename from Documentation/arm/IXP4xx
rename to Documentation/arch/arm/IXP4xx
diff --git a/Documentation/arm/Interrupts b/Documentation/arch/arm/Interrupts
similarity index 100%
rename from Documentation/arm/Interrupts
rename to Documentation/arch/arm/Interrupts
diff --git a/Documentation/arm/Netwinder b/Documentation/arch/arm/Netwinder
similarity index 100%
rename from Documentation/arm/Netwinder
rename to Documentation/arch/arm/Netwinder
diff --git a/Documentation/arm/Porting b/Documentation/arch/arm/Porting
similarity index 100%
rename from Documentation/arm/Porting
rename to Documentation/arch/arm/Porting
diff --git a/Documentation/arm/README b/Documentation/arch/arm/README
similarity index 100%
rename from Documentation/arm/README
rename to Documentation/arch/arm/README
diff --git a/Documentation/arm/SA1100/ADSBitsy b/Documentation/arch/arm/SA1100/ADSBitsy
similarity index 100%
rename from Documentation/arm/SA1100/ADSBitsy
rename to Documentation/arch/arm/SA1100/ADSBitsy
diff --git a/Documentation/arm/SA1100/Assabet b/Documentation/arch/arm/SA1100/Assabet
similarity index 100%
rename from Documentation/arm/SA1100/Assabet
rename to Documentation/arch/arm/SA1100/Assabet
diff --git a/Documentation/arm/SA1100/Brutus b/Documentation/arch/arm/SA1100/Brutus
similarity index 100%
rename from Documentation/arm/SA1100/Brutus
rename to Documentation/arch/arm/SA1100/Brutus
diff --git a/Documentation/arm/SA1100/CERF b/Documentation/arch/arm/SA1100/CERF
similarity index 100%
rename from Documentation/arm/SA1100/CERF
rename to Documentation/arch/arm/SA1100/CERF
diff --git a/Documentation/arm/SA1100/FreeBird b/Documentation/arch/arm/SA1100/FreeBird
similarity index 100%
rename from Documentation/arm/SA1100/FreeBird
rename to Documentation/arch/arm/SA1100/FreeBird
diff --git a/Documentation/arm/SA1100/GraphicsClient b/Documentation/arch/arm/SA1100/GraphicsClient
similarity index 100%
rename from Documentation/arm/SA1100/GraphicsClient
rename to Documentation/arch/arm/SA1100/GraphicsClient
diff --git a/Documentation/arm/SA1100/GraphicsMaster b/Documentation/arch/arm/SA1100/GraphicsMaster
similarity index 100%
rename from Documentation/arm/SA1100/GraphicsMaster
rename to Documentation/arch/arm/SA1100/GraphicsMaster
diff --git a/Documentation/arm/SA1100/HUW_WEBPANEL b/Documentation/arch/arm/SA1100/HUW_WEBPANEL
similarity index 100%
rename from Documentation/arm/SA1100/HUW_WEBPANEL
rename to Documentation/arch/arm/SA1100/HUW_WEBPANEL
diff --git a/Documentation/arm/SA1100/Itsy b/Documentation/arch/arm/SA1100/Itsy
similarity index 100%
rename from Documentation/arm/SA1100/Itsy
rename to Documentation/arch/arm/SA1100/Itsy
diff --git a/Documentation/arm/SA1100/LART b/Documentation/arch/arm/SA1100/LART
similarity index 100%
rename from Documentation/arm/SA1100/LART
rename to Documentation/arch/arm/SA1100/LART
diff --git a/Documentation/arm/SA1100/PLEB b/Documentation/arch/arm/SA1100/PLEB
similarity index 100%
rename from Documentation/arm/SA1100/PLEB
rename to Documentation/arch/arm/SA1100/PLEB
diff --git a/Documentation/arm/SA1100/Pangolin b/Documentation/arch/arm/SA1100/Pangolin
similarity index 100%
rename from Documentation/arm/SA1100/Pangolin
rename to Documentation/arch/arm/SA1100/Pangolin
diff --git a/Documentation/arm/SA1100/Tifon b/Documentation/arch/arm/SA1100/Tifon
similarity index 100%
rename from Documentation/arm/SA1100/Tifon
rename to Documentation/arch/arm/SA1100/Tifon
diff --git a/Documentation/arm/SA1100/Victor b/Documentation/arch/arm/SA1100/Victor
similarity index 100%
rename from Documentation/arm/SA1100/Victor
rename to Documentation/arch/arm/SA1100/Victor
diff --git a/Documentation/arm/SA1100/Yopy b/Documentation/arch/arm/SA1100/Yopy
similarity index 100%
rename from Documentation/arm/SA1100/Yopy
rename to Documentation/arch/arm/SA1100/Yopy
diff --git a/Documentation/arm/SA1100/empeg b/Documentation/arch/arm/SA1100/empeg
similarity index 100%
rename from Documentation/arm/SA1100/empeg
rename to Documentation/arch/arm/SA1100/empeg
diff --git a/Documentation/arm/SA1100/nanoEngine b/Documentation/arch/arm/SA1100/nanoEngine
similarity index 100%
rename from Documentation/arm/SA1100/nanoEngine
rename to Documentation/arch/arm/SA1100/nanoEngine
diff --git a/Documentation/arm/SA1100/serial_UART b/Documentation/arch/arm/SA1100/serial_UART
similarity index 100%
rename from Documentation/arm/SA1100/serial_UART
rename to Documentation/arch/arm/SA1100/serial_UART
diff --git a/Documentation/arm/Samsung-S3C24XX/DMA.txt b/Documentation/arch/arm/Samsung-S3C24XX/DMA.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/DMA.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/DMA.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/EB2410ITX.txt b/Documentation/arch/arm/Samsung-S3C24XX/EB2410ITX.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/EB2410ITX.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/EB2410ITX.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/GPIO.txt b/Documentation/arch/arm/Samsung-S3C24XX/GPIO.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/GPIO.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/GPIO.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/H1940.txt b/Documentation/arch/arm/Samsung-S3C24XX/H1940.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/H1940.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/H1940.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/Overview.txt b/Documentation/arch/arm/Samsung-S3C24XX/Overview.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/Overview.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/Overview.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/S3C2412.txt b/Documentation/arch/arm/Samsung-S3C24XX/S3C2412.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/S3C2412.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/S3C2412.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/S3C2413.txt b/Documentation/arch/arm/Samsung-S3C24XX/S3C2413.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/S3C2413.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/S3C2413.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/SMDK2440.txt b/Documentation/arch/arm/Samsung-S3C24XX/SMDK2440.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/SMDK2440.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/SMDK2440.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/Suspend.txt b/Documentation/arch/arm/Samsung-S3C24XX/Suspend.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/Suspend.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/Suspend.txt
diff --git a/Documentation/arm/Samsung-S3C24XX/USB-Host.txt b/Documentation/arch/arm/Samsung-S3C24XX/USB-Host.txt
similarity index 100%
rename from Documentation/arm/Samsung-S3C24XX/USB-Host.txt
rename to Documentation/arch/arm/Samsung-S3C24XX/USB-Host.txt
diff --git a/Documentation/arm/Setup b/Documentation/arch/arm/Setup
similarity index 100%
rename from Documentation/arm/Setup
rename to Documentation/arch/arm/Setup
diff --git a/Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen b/Documentation/arch/arm/Sharp-LH/ADC-LH7-Touchscreen
similarity index 100%
rename from Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
rename to Documentation/arch/arm/Sharp-LH/ADC-LH7-Touchscreen
diff --git a/Documentation/arm/Sharp-LH/CompactFlash b/Documentation/arch/arm/Sharp-LH/CompactFlash
similarity index 100%
rename from Documentation/arm/Sharp-LH/CompactFlash
rename to Documentation/arch/arm/Sharp-LH/CompactFlash
diff --git a/Documentation/arm/Sharp-LH/IOBarrier b/Documentation/arch/arm/Sharp-LH/IOBarrier
similarity index 100%
rename from Documentation/arm/Sharp-LH/IOBarrier
rename to Documentation/arch/arm/Sharp-LH/IOBarrier
diff --git a/Documentation/arm/Sharp-LH/KEV7A400 b/Documentation/arch/arm/Sharp-LH/KEV7A400
similarity index 100%
rename from Documentation/arm/Sharp-LH/KEV7A400
rename to Documentation/arch/arm/Sharp-LH/KEV7A400
diff --git a/Documentation/arm/Sharp-LH/LCDPanels b/Documentation/arch/arm/Sharp-LH/LCDPanels
similarity index 100%
rename from Documentation/arm/Sharp-LH/LCDPanels
rename to Documentation/arch/arm/Sharp-LH/LCDPanels
diff --git a/Documentation/arm/Sharp-LH/LPD7A400 b/Documentation/arch/arm/Sharp-LH/LPD7A400
similarity index 100%
rename from Documentation/arm/Sharp-LH/LPD7A400
rename to Documentation/arch/arm/Sharp-LH/LPD7A400
diff --git a/Documentation/arm/Sharp-LH/LPD7A40X b/Documentation/arch/arm/Sharp-LH/LPD7A40X
similarity index 100%
rename from Documentation/arm/Sharp-LH/LPD7A40X
rename to Documentation/arch/arm/Sharp-LH/LPD7A40X
diff --git a/Documentation/arm/Sharp-LH/SDRAM b/Documentation/arch/arm/Sharp-LH/SDRAM
similarity index 100%
rename from Documentation/arm/Sharp-LH/SDRAM
rename to Documentation/arch/arm/Sharp-LH/SDRAM
diff --git a/Documentation/arm/Sharp-LH/VectoredInterruptController b/Documentation/arch/arm/Sharp-LH/VectoredInterruptController
similarity index 100%
rename from Documentation/arm/Sharp-LH/VectoredInterruptController
rename to Documentation/arch/arm/Sharp-LH/VectoredInterruptController
diff --git a/Documentation/arm/VFP/release-notes.txt b/Documentation/arch/arm/VFP/release-notes.txt
similarity index 100%
rename from Documentation/arm/VFP/release-notes.txt
rename to Documentation/arch/arm/VFP/release-notes.txt
diff --git a/Documentation/arm/empeg/README b/Documentation/arch/arm/empeg/README
similarity index 100%
rename from Documentation/arm/empeg/README
rename to Documentation/arch/arm/empeg/README
diff --git a/Documentation/arm/empeg/ir.txt b/Documentation/arch/arm/empeg/ir.txt
similarity index 100%
rename from Documentation/arm/empeg/ir.txt
rename to Documentation/arch/arm/empeg/ir.txt
diff --git a/Documentation/arm/empeg/mkdevs b/Documentation/arch/arm/empeg/mkdevs
similarity index 100%
rename from Documentation/arm/empeg/mkdevs
rename to Documentation/arch/arm/empeg/mkdevs
diff --git a/Documentation/arm/mem_alignment b/Documentation/arch/arm/mem_alignment
similarity index 100%
rename from Documentation/arm/mem_alignment
rename to Documentation/arch/arm/mem_alignment
diff --git a/Documentation/arm/memory.txt b/Documentation/arch/arm/memory.txt
similarity index 100%
rename from Documentation/arm/memory.txt
rename to Documentation/arch/arm/memory.txt
diff --git a/Documentation/arm/nwfpe/NOTES b/Documentation/arch/arm/nwfpe/NOTES
similarity index 100%
rename from Documentation/arm/nwfpe/NOTES
rename to Documentation/arch/arm/nwfpe/NOTES
diff --git a/Documentation/arm/nwfpe/README b/Documentation/arch/arm/nwfpe/README
similarity index 100%
rename from Documentation/arm/nwfpe/README
rename to Documentation/arch/arm/nwfpe/README
diff --git a/Documentation/arm/nwfpe/README.FPE b/Documentation/arch/arm/nwfpe/README.FPE
similarity index 100%
rename from Documentation/arm/nwfpe/README.FPE
rename to Documentation/arch/arm/nwfpe/README.FPE
diff --git a/Documentation/arm/nwfpe/TODO b/Documentation/arch/arm/nwfpe/TODO
similarity index 100%
rename from Documentation/arm/nwfpe/TODO
rename to Documentation/arch/arm/nwfpe/TODO
diff --git a/Documentation/blackfin/00-INDEX b/Documentation/arch/blackfin/00-INDEX
similarity index 100%
rename from Documentation/blackfin/00-INDEX
rename to Documentation/arch/blackfin/00-INDEX
diff --git a/Documentation/blackfin/Filesystems b/Documentation/arch/blackfin/Filesystems
similarity index 100%
rename from Documentation/blackfin/Filesystems
rename to Documentation/arch/blackfin/Filesystems
diff --git a/Documentation/blackfin/cache-lock.txt b/Documentation/arch/blackfin/cache-lock.txt
similarity index 100%
rename from Documentation/blackfin/cache-lock.txt
rename to Documentation/arch/blackfin/cache-lock.txt
diff --git a/Documentation/blackfin/cachefeatures.txt b/Documentation/arch/blackfin/cachefeatures.txt
similarity index 100%
rename from Documentation/blackfin/cachefeatures.txt
rename to Documentation/arch/blackfin/cachefeatures.txt
diff --git a/Documentation/cris/README b/Documentation/arch/cris/README
similarity index 100%
rename from Documentation/cris/README
rename to Documentation/arch/cris/README
diff --git a/Documentation/fujitsu/frv/README.txt b/Documentation/arch/frv/README.txt
similarity index 100%
rename from Documentation/fujitsu/frv/README.txt
rename to Documentation/arch/frv/README.txt
diff --git a/Documentation/fujitsu/frv/atomic-ops.txt b/Documentation/arch/frv/atomic-ops.txt
similarity index 100%
rename from Documentation/fujitsu/frv/atomic-ops.txt
rename to Documentation/arch/frv/atomic-ops.txt
diff --git a/Documentation/fujitsu/frv/booting.txt b/Documentation/arch/frv/booting.txt
similarity index 100%
rename from Documentation/fujitsu/frv/booting.txt
rename to Documentation/arch/frv/booting.txt
diff --git a/Documentation/fujitsu/frv/clock.txt b/Documentation/arch/frv/clock.txt
similarity index 100%
rename from Documentation/fujitsu/frv/clock.txt
rename to Documentation/arch/frv/clock.txt
diff --git a/Documentation/fujitsu/frv/configuring.txt b/Documentation/arch/frv/configuring.txt
similarity index 100%
rename from Documentation/fujitsu/frv/configuring.txt
rename to Documentation/arch/frv/configuring.txt
diff --git a/Documentation/fujitsu/frv/features.txt b/Documentation/arch/frv/features.txt
similarity index 100%
rename from Documentation/fujitsu/frv/features.txt
rename to Documentation/arch/frv/features.txt
diff --git a/Documentation/fujitsu/frv/gdbinit b/Documentation/arch/frv/gdbinit
similarity index 100%
rename from Documentation/fujitsu/frv/gdbinit
rename to Documentation/arch/frv/gdbinit
diff --git a/Documentation/fujitsu/frv/gdbstub.txt b/Documentation/arch/frv/gdbstub.txt
similarity index 100%
rename from Documentation/fujitsu/frv/gdbstub.txt
rename to Documentation/arch/frv/gdbstub.txt
diff --git a/Documentation/fujitsu/frv/kernel-ABI.txt b/Documentation/arch/frv/kernel-ABI.txt
similarity index 100%
rename from Documentation/fujitsu/frv/kernel-ABI.txt
rename to Documentation/arch/frv/kernel-ABI.txt
diff --git a/Documentation/fujitsu/frv/mmu-layout.txt b/Documentation/arch/frv/mmu-layout.txt
similarity index 100%
rename from Documentation/fujitsu/frv/mmu-layout.txt
rename to Documentation/arch/frv/mmu-layout.txt
diff --git a/Documentation/i386/IO-APIC.txt b/Documentation/arch/i386/IO-APIC.txt
similarity index 100%
rename from Documentation/i386/IO-APIC.txt
rename to Documentation/arch/i386/IO-APIC.txt
diff --git a/Documentation/i386/boot.txt b/Documentation/arch/i386/boot.txt
similarity index 100%
rename from Documentation/i386/boot.txt
rename to Documentation/arch/i386/boot.txt
diff --git a/Documentation/i386/usb-legacy-support.txt b/Documentation/arch/i386/usb-legacy-support.txt
similarity index 100%
rename from Documentation/i386/usb-legacy-support.txt
rename to Documentation/arch/i386/usb-legacy-support.txt
diff --git a/Documentation/i386/zero-page.txt b/Documentation/arch/i386/zero-page.txt
similarity index 100%
rename from Documentation/i386/zero-page.txt
rename to Documentation/arch/i386/zero-page.txt
diff --git a/Documentation/ia64/IRQ-redir.txt b/Documentation/arch/ia64/IRQ-redir.txt
similarity index 100%
rename from Documentation/ia64/IRQ-redir.txt
rename to Documentation/arch/ia64/IRQ-redir.txt
diff --git a/Documentation/ia64/README b/Documentation/arch/ia64/README
similarity index 100%
rename from Documentation/ia64/README
rename to Documentation/arch/ia64/README
diff --git a/Documentation/ia64/aliasing-test.c b/Documentation/arch/ia64/aliasing-test.c
similarity index 100%
rename from Documentation/ia64/aliasing-test.c
rename to Documentation/arch/ia64/aliasing-test.c
diff --git a/Documentation/ia64/aliasing.txt b/Documentation/arch/ia64/aliasing.txt
similarity index 100%
rename from Documentation/ia64/aliasing.txt
rename to Documentation/arch/ia64/aliasing.txt
diff --git a/Documentation/ia64/efirtc.txt b/Documentation/arch/ia64/efirtc.txt
similarity index 100%
rename from Documentation/ia64/efirtc.txt
rename to Documentation/arch/ia64/efirtc.txt
diff --git a/Documentation/ia64/err_inject.txt b/Documentation/arch/ia64/err_inject.txt
similarity index 100%
rename from Documentation/ia64/err_inject.txt
rename to Documentation/arch/ia64/err_inject.txt
diff --git a/Documentation/ia64/fsys.txt b/Documentation/arch/ia64/fsys.txt
similarity index 100%
rename from Documentation/ia64/fsys.txt
rename to Documentation/arch/ia64/fsys.txt
diff --git a/Documentation/ia64/mca.txt b/Documentation/arch/ia64/mca.txt
similarity index 100%
rename from Documentation/ia64/mca.txt
rename to Documentation/arch/ia64/mca.txt
diff --git a/Documentation/ia64/serial.txt b/Documentation/arch/ia64/serial.txt
similarity index 100%
rename from Documentation/ia64/serial.txt
rename to Documentation/arch/ia64/serial.txt
diff --git a/Documentation/m68k/00-INDEX b/Documentation/arch/m68k/00-INDEX
similarity index 100%
rename from Documentation/m68k/00-INDEX
rename to Documentation/arch/m68k/00-INDEX
diff --git a/Documentation/m68k/kernel-options.txt b/Documentation/arch/m68k/kernel-options.txt
similarity index 100%
rename from Documentation/m68k/kernel-options.txt
rename to Documentation/arch/m68k/kernel-options.txt
diff --git a/Documentation/mips/AU1xxx_IDE.README b/Documentation/arch/mips/AU1xxx_IDE.README
similarity index 100%
rename from Documentation/mips/AU1xxx_IDE.README
rename to Documentation/arch/mips/AU1xxx_IDE.README
diff --git a/Documentation/mips/GT64120.README b/Documentation/arch/mips/GT64120.README
similarity index 100%
rename from Documentation/mips/GT64120.README
rename to Documentation/arch/mips/GT64120.README
diff --git a/Documentation/mips/time.README b/Documentation/arch/mips/time.README
similarity index 100%
rename from Documentation/mips/time.README
rename to Documentation/arch/mips/time.README
diff --git a/Documentation/parisc/00-INDEX b/Documentation/arch/parisc/00-INDEX
similarity index 100%
rename from Documentation/parisc/00-INDEX
rename to Documentation/arch/parisc/00-INDEX
diff --git a/Documentation/parisc/debugging b/Documentation/arch/parisc/debugging
similarity index 100%
rename from Documentation/parisc/debugging
rename to Documentation/arch/parisc/debugging
diff --git a/Documentation/parisc/registers b/Documentation/arch/parisc/registers
similarity index 100%
rename from Documentation/parisc/registers
rename to Documentation/arch/parisc/registers
diff --git a/Documentation/powerpc/00-INDEX b/Documentation/arch/powerpc/00-INDEX
similarity index 100%
rename from Documentation/powerpc/00-INDEX
rename to Documentation/arch/powerpc/00-INDEX
diff --git a/Documentation/powerpc/SBC8260_memory_mapping.txt b/Documentation/arch/powerpc/SBC8260_memory_mapping.txt
similarity index 100%
rename from Documentation/powerpc/SBC8260_memory_mapping.txt
rename to Documentation/arch/powerpc/SBC8260_memory_mapping.txt
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/arch/powerpc/booting-without-of.txt
similarity index 100%
rename from Documentation/powerpc/booting-without-of.txt
rename to Documentation/arch/powerpc/booting-without-of.txt
diff --git a/Documentation/powerpc/cpu_features.txt b/Documentation/arch/powerpc/cpu_features.txt
similarity index 100%
rename from Documentation/powerpc/cpu_features.txt
rename to Documentation/arch/powerpc/cpu_features.txt
diff --git a/Documentation/powerpc/eeh-pci-error-recovery.txt b/Documentation/arch/powerpc/eeh-pci-error-recovery.txt
similarity index 100%
rename from Documentation/powerpc/eeh-pci-error-recovery.txt
rename to Documentation/arch/powerpc/eeh-pci-error-recovery.txt
diff --git a/Documentation/powerpc/hvcs.txt b/Documentation/arch/powerpc/hvcs.txt
similarity index 100%
rename from Documentation/powerpc/hvcs.txt
rename to Documentation/arch/powerpc/hvcs.txt
diff --git a/Documentation/powerpc/mpc52xx-device-tree-bindings.txt b/Documentation/arch/powerpc/mpc52xx-device-tree-bindings.txt
similarity index 100%
rename from Documentation/powerpc/mpc52xx-device-tree-bindings.txt
rename to Documentation/arch/powerpc/mpc52xx-device-tree-bindings.txt
diff --git a/Documentation/powerpc/mpc52xx.txt b/Documentation/arch/powerpc/mpc52xx.txt
similarity index 100%
rename from Documentation/powerpc/mpc52xx.txt
rename to Documentation/arch/powerpc/mpc52xx.txt
diff --git a/Documentation/powerpc/ppc_htab.txt b/Documentation/arch/powerpc/ppc_htab.txt
similarity index 100%
rename from Documentation/powerpc/ppc_htab.txt
rename to Documentation/arch/powerpc/ppc_htab.txt
diff --git a/Documentation/powerpc/smp.txt b/Documentation/arch/powerpc/smp.txt
similarity index 100%
rename from Documentation/powerpc/smp.txt
rename to Documentation/arch/powerpc/smp.txt
diff --git a/Documentation/powerpc/sound.txt b/Documentation/arch/powerpc/sound.txt
similarity index 100%
rename from Documentation/powerpc/sound.txt
rename to Documentation/arch/powerpc/sound.txt
diff --git a/Documentation/powerpc/zImage_layout.txt b/Documentation/arch/powerpc/zImage_layout.txt
similarity index 100%
rename from Documentation/powerpc/zImage_layout.txt
rename to Documentation/arch/powerpc/zImage_layout.txt
diff --git a/Documentation/s390/3270.ChangeLog b/Documentation/arch/s390/3270.ChangeLog
similarity index 100%
rename from Documentation/s390/3270.ChangeLog
rename to Documentation/arch/s390/3270.ChangeLog
diff --git a/Documentation/s390/3270.txt b/Documentation/arch/s390/3270.txt
similarity index 100%
rename from Documentation/s390/3270.txt
rename to Documentation/arch/s390/3270.txt
diff --git a/Documentation/s390/CommonIO b/Documentation/arch/s390/CommonIO
similarity index 100%
rename from Documentation/s390/CommonIO
rename to Documentation/arch/s390/CommonIO
diff --git a/Documentation/s390/DASD b/Documentation/arch/s390/DASD
similarity index 100%
rename from Documentation/s390/DASD
rename to Documentation/arch/s390/DASD
diff --git a/Documentation/s390/Debugging390.txt b/Documentation/arch/s390/Debugging390.txt
similarity index 100%
rename from Documentation/s390/Debugging390.txt
rename to Documentation/arch/s390/Debugging390.txt
diff --git a/Documentation/s390/TAPE b/Documentation/arch/s390/TAPE
similarity index 100%
rename from Documentation/s390/TAPE
rename to Documentation/arch/s390/TAPE
diff --git a/Documentation/s390/cds.txt b/Documentation/arch/s390/cds.txt
similarity index 100%
rename from Documentation/s390/cds.txt
rename to Documentation/arch/s390/cds.txt
diff --git a/Documentation/s390/config3270.sh b/Documentation/arch/s390/config3270.sh
similarity index 100%
rename from Documentation/s390/config3270.sh
rename to Documentation/arch/s390/config3270.sh
diff --git a/Documentation/s390/driver-model.txt b/Documentation/arch/s390/driver-model.txt
similarity index 100%
rename from Documentation/s390/driver-model.txt
rename to Documentation/arch/s390/driver-model.txt
diff --git a/Documentation/s390/monreader.txt b/Documentation/arch/s390/monreader.txt
similarity index 100%
rename from Documentation/s390/monreader.txt
rename to Documentation/arch/s390/monreader.txt
diff --git a/Documentation/s390/s390dbf.txt b/Documentation/arch/s390/s390dbf.txt
similarity index 100%
rename from Documentation/s390/s390dbf.txt
rename to Documentation/arch/s390/s390dbf.txt
diff --git a/Documentation/s390/zfcpdump.txt b/Documentation/arch/s390/zfcpdump.txt
similarity index 100%
rename from Documentation/s390/zfcpdump.txt
rename to Documentation/arch/s390/zfcpdump.txt
diff --git a/Documentation/sh/clk.txt b/Documentation/arch/sh/clk.txt
similarity index 100%
rename from Documentation/sh/clk.txt
rename to Documentation/arch/sh/clk.txt
diff --git a/Documentation/sh/kgdb.txt b/Documentation/arch/sh/kgdb.txt
similarity index 100%
rename from Documentation/sh/kgdb.txt
rename to Documentation/arch/sh/kgdb.txt
diff --git a/Documentation/sh/new-machine.txt b/Documentation/arch/sh/new-machine.txt
similarity index 100%
rename from Documentation/sh/new-machine.txt
rename to Documentation/arch/sh/new-machine.txt
diff --git a/Documentation/sh/register-banks.txt b/Documentation/arch/sh/register-banks.txt
similarity index 100%
rename from Documentation/sh/register-banks.txt
rename to Documentation/arch/sh/register-banks.txt
diff --git a/Documentation/sparc/README-2.5 b/Documentation/arch/sparc/README-2.5
similarity index 100%
rename from Documentation/sparc/README-2.5
rename to Documentation/arch/sparc/README-2.5
diff --git a/Documentation/sparc/sbus_drivers.txt b/Documentation/arch/sparc/sbus_drivers.txt
similarity index 100%
rename from Documentation/sparc/sbus_drivers.txt
rename to Documentation/arch/sparc/sbus_drivers.txt
diff --git a/Documentation/uml/UserModeLinux-HOWTO.txt b/Documentation/arch/uml/UserModeLinux-HOWTO.txt
similarity index 100%
rename from Documentation/uml/UserModeLinux-HOWTO.txt
rename to Documentation/arch/uml/UserModeLinux-HOWTO.txt
diff --git a/Documentation/x86_64/boot-options.txt b/Documentation/arch/x86_64/boot-options.txt
similarity index 100%
rename from Documentation/x86_64/boot-options.txt
rename to Documentation/arch/x86_64/boot-options.txt
diff --git a/Documentation/x86_64/cpu-hotplug-spec b/Documentation/arch/x86_64/cpu-hotplug-spec
similarity index 100%
rename from Documentation/x86_64/cpu-hotplug-spec
rename to Documentation/arch/x86_64/cpu-hotplug-spec
diff --git a/Documentation/x86_64/fake-numa-for-cpusets b/Documentation/arch/x86_64/fake-numa-for-cpusets
similarity index 100%
rename from Documentation/x86_64/fake-numa-for-cpusets
rename to Documentation/arch/x86_64/fake-numa-for-cpusets
diff --git a/Documentation/x86_64/kernel-stacks b/Documentation/arch/x86_64/kernel-stacks
similarity index 100%
rename from Documentation/x86_64/kernel-stacks
rename to Documentation/arch/x86_64/kernel-stacks
diff --git a/Documentation/x86_64/machinecheck b/Documentation/arch/x86_64/machinecheck
similarity index 100%
rename from Documentation/x86_64/machinecheck
rename to Documentation/arch/x86_64/machinecheck
diff --git a/Documentation/x86_64/mm.txt b/Documentation/arch/x86_64/mm.txt
similarity index 100%
rename from Documentation/x86_64/mm.txt
rename to Documentation/arch/x86_64/mm.txt

