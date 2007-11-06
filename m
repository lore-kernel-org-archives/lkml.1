Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXKFE5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXKFE5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 23:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbXKFE5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 23:57:04 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:47002 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbXKFE5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:57:03 -0500
Date: Mon, 5 Nov 2007 23:55:25 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: non-existent CONFIG variables referenced from Makefiles
Message-ID: <Pine.LNX.4.64.0711052350340.18454@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  as opposed to the much larger list of non-existent config variables
being tested from source or header files, here's a much shorter list
of such variables being referenced from within Makefiles (i removed
all entries related to the sound/oss directory since that whole thing
is going away, anyway, right?):


===== CPU_ARM946T =====
./arch/arm/Makefile:tune-$(CONFIG_CPU_ARM946T)	:=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
===== CPU_R4000 =====
./arch/mips/kernel/Makefile:obj-$(CONFIG_CPU_R4000)		+= r4k_fpu.o r4k_switch.o
===== ETRAXFS_SIM =====
./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
===== HARDWARE_PM =====
./arch/blackfin/oprofile/Makefile:oprofile-$(CONFIG_HARDWARE_PM) += op_model_bf533.o
===== L7200_KEYB =====
./drivers/acorn/char/Makefile:obj-$(CONFIG_L7200_KEYB)	+= defkeymap-l7200.o keyb_l7200.o
===== MACHINE =====
./arch/ppc/boot/simple/Makefile:# zimage-$(CONFIG_MACHINE) and zimagerd-$(CONFIG_MACHINE) to the target
./arch/ppc/boot/simple/Makefile:# that produces the desired image and they must set end-$(CONFIG_MACHINE)
./arch/ppc/boot/simple/Makefile:# than 'zImage.elf', set end-$(CONFIG_MACHINE) to be the suffix used for
./arch/ppc/boot/simple/Makefile:# set entrypoint-$(CONFIG_MACHINE) to the location which the image should be
./arch/ppc/boot/simple/Makefile:# loaded at.  The optimal setting for entrypoint-$(CONFIG_MACHINE) is the link
./arch/ppc/boot/simple/Makefile:# misc-$(CONFIG_MACHINE) variable.
===== MSPETH =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
===== OPROFILE_ARM11_CORE =====
./arch/arm/oprofile/Makefile:oprofile-$(CONFIG_OPROFILE_ARM11_CORE)	+= op_model_arm11_core.o
===== OPROFILE_ARMV6 =====
./arch/arm/oprofile/Makefile:oprofile-$(CONFIG_OPROFILE_ARMV6)	+= op_model_v6.o
===== OPROFILE_CELL =====
./arch/powerpc/oprofile/Makefile:oprofile-$(CONFIG_OPROFILE_CELL) += op_model_cell.o \
===== OPROFILE_MPCORE =====
./arch/arm/oprofile/Makefile:oprofile-$(CONFIG_OPROFILE_MPCORE)	+= op_model_mpcore.o
===== PCI_HOST_ITE8152 =====
./arch/arm/common/Makefile:obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
===== RADIO_MIROPCM20 =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
===== RADIO_MIROPCM20_RDS =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
===== SA1100_USB =====
./arch/arm/mach-sa1100/Makefile:#obj-$(CONFIG_SA1100_USB)		+= usb/
===== SOUND_TVMIXER =====
./drivers/media/video/Makefile:obj-$(CONFIG_SOUND_TVMIXER) += tvmixer.o
===== TTY_LOG =====
./arch/um/os-Linux/Makefile:obj-$(CONFIG_TTY_LOG) += tty_log.o
./arch/um/os-Linux/Makefile:user-objs-$(CONFIG_TTY_LOG) += tty_log.o
===== USB_MSP71XX =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
===== XTENSA_VARIANT_LINUX_CUSTOM =====
./arch/xtensa/Makefile:variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)	:= custom

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
