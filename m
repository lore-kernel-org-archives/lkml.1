Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbXCaKMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbXCaKMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 06:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXCaKMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 06:12:47 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53973 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXCaKMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 06:12:45 -0400
X-Originating-Ip: 74.109.98.130
Date: Sat, 31 Mar 2007 06:12:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: updated list of "dead" Makefile CONFIG_ variables
Message-ID: <Pine.LNX.4.64.0703310552560.26371@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  based on the previous list posted, and some feedback, the updated
list of CONFIG_ variables that exist in Makefiles for which there is
no corresponding Kconfig definition *anywhere* in the source tree.

drivers/:

===== L7200_KEYB =====
./drivers/acorn/char/Makefile:obj-$(CONFIG_L7200_KEYB)  += defkeymap-l7200.o keyb_l7200.o
===== SCSI_FD_8xx =====
./drivers/scsi/Makefile:obj-$(CONFIG_SCSI_FD_8xx)       += seagate.o
===== USB_OHCI_AT91 =====
./drivers/usb/Makefile:obj-$(CONFIG_USB_OHCI_AT91)      += host/

fs/:

===== NLS_ABC =====
./fs/nls/Makefile:obj-$(CONFIG_NLS_ABC)         += nls_abc.o
===== NLS_ISO8859_10 =====
./fs/nls/Makefile:obj-$(CONFIG_NLS_ISO8859_10)  += nls_iso8859-10.o

arch/:

===== CPU_AP7000 =====
./arch/avr32/Makefile:cpuflags-$(CONFIG_CPU_AP7000)     += -mcpu=ap7000
===== CPU_ARM946T =====
./arch/arm/Makefile:tune-$(CONFIG_CPU_ARM946T)  :=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
===== CPU_R4000 =====
./arch/mips/kernel/Makefile:obj-$(CONFIG_CPU_R4000)             += r4k_fpu.o r4k_switch.o
===== ETRAXFS_SIM =====
./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
===== MACHINE =====
./arch/ppc/boot/simple/Makefile:# zimage-$(CONFIG_MACHINE) and zimagerd-$(CONFIG_MACHINE) to the target
./arch/ppc/boot/simple/Makefile:# that produces the desired image and they must set end-$(CONFIG_MACHINE)
./arch/ppc/boot/simple/Makefile:# than 'zImage.elf', set end-$(CONFIG_MACHINE) to be the suffix used for
./arch/ppc/boot/simple/Makefile:# set entrypoint-$(CONFIG_MACHINE) to the location which the image should be
./arch/ppc/boot/simple/Makefile:# loaded at.  The optimal setting for entrypoint-$(CONFIG_MACHINE) is the link
./arch/ppc/boot/simple/Makefile:# misc-$(CONFIG_MACHINE) variable.
===== REMOTE_DEBUG =====
./arch/mips/momentum/jaguar_atx/Makefile:obj-$(CONFIG_REMOTE_DEBUG) += dbg_io.o
===== SA1100_USB =====
./arch/arm/mach-sa1100/Makefile:#obj-$(CONFIG_SA1100_USB)              += usb/
===== SH_KGDB =====
./arch/sh/kernel/Makefile:obj-$(CONFIG_SH_KGDB)         += kgdb_stub.o kgdb_jmp.o
./arch/sh/Makefile:cflags-$(CONFIG_SH_KGDB)             += -g
===== TTY_LOG =====
./arch/um/os-Linux/Makefile:obj-$(CONFIG_TTY_LOG) += tty_log.o
./arch/um/os-Linux/Makefile:user-objs-$(CONFIG_TTY_LOG) += tty_log.o
===== VGA_HOSE =====
./arch/alpha/kernel/Makefile:obj-$(CONFIG_VGA_HOSE)     += console.o
===== XTENSA_VARIANT_LINUX_CUSTOM =====
./arch/xtensa/Makefile:variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)    := custom



-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
