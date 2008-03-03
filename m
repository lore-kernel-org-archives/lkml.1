Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYCCM5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYCCM5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYCCM5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:57:24 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:51110 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYCCM5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:57:22 -0500
Date: Mon, 3 Mar 2008 07:57:16 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bad Makefile references to undefined CONFIG variables
Message-ID: <alpine.LFD.1.00.0803030755120.2220@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  as opposed to references to undefined CONFIG variables from Kconfig
files, this is the entire list of such references from *Makefiles*.
i'll get more specific about this later today but i figured i'd just
toss out the entire list for perusal right now, since it's not that
long.


===== CPU_ARM946T =====
./arch/arm/Makefile:tune-$(CONFIG_CPU_ARM946T)	:=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
===== CPU_R4000 =====
./arch/mips/kernel/Makefile:obj-$(CONFIG_CPU_R4000)		+= r4k_fpu.o r4k_switch.o
===== ETRAXFS_SIM =====
./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
===== IDE_ETRAX =====
./drivers/ide/cris/Makefile:obj-$(CONFIG_IDE_ETRAX)			+= ide-cris.o
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
===== PCSPEAKER =====
./arch/mips/kernel/Makefile:obj-$(CONFIG_PCSPEAKER)		+= pcspeaker.o
===== PPC_MPC86XADS =====
./arch/powerpc/boot/Makefile:image-$(CONFIG_PPC_MPC86XADS)		+= cuImage.mpc866ads
===== PPC_MPC885ADS =====
./arch/powerpc/boot/Makefile:image-$(CONFIG_PPC_MPC885ADS)		+= cuImage.mpc885ads
===== PROFILE =====
./arch/mn10300/kernel/Makefile:obj-$(CONFIG_PROFILE) += profile.o profile-low.o
===== RADIO_MIROPCM20 =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
===== RADIO_MIROPCM20_RDS =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
===== SA1100_USB =====
./arch/arm/mach-sa1100/Makefile:#obj-$(CONFIG_SA1100_USB)		+= usb/
===== SOUND_WM97XX =====
./sound/oss/Makefile:obj-$(CONFIG_SOUND_WM97XX)	+= ac97_plugin_wm97xx.o
===== TIPAR =====
./drivers/char/Makefile:obj-$(CONFIG_TIPAR)		+= tipar.o
===== TTY_LOG =====
./arch/um/os-Linux/Makefile:obj-$(CONFIG_TTY_LOG) += tty_log.o
./arch/um/os-Linux/Makefile:user-objs-$(CONFIG_TTY_LOG) += tty_log.o
===== USB_MSP71XX =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
===== XFS_TRACE =====
./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o
./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
===== XTENSA_VARIANT_LINUX_CUSTOM =====
./arch/xtensa/Makefile:variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)	:= custom


rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
