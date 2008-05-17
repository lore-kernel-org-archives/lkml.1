Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYEQUqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYEQUqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbYEQUqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:46:04 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46939 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbYEQUqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:46:01 -0400
Date: Sat, 17 May 2008 16:45:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: references from Makefiles to non-existent CONFIG variables
Message-ID: <alpine.LFD.1.10.0805171641190.14930@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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


  here's the current, unadulterated list of references from Makefiles
to CONFIG variables that are not defined in any Kconfig file.  once
again, enjoy.

p.s.  if history is any guide, i'm sure i'll get an email or two from
someone upbraiding me for mentioning one of their variables and
staunchly defending its (utterly irrelevant) existence.  folks, some
of these variables have been around so long, i can rattle off half of
them from memory.  so howzabout dealing with them once and for all?
it's just a thought.


===== ARCH_OMAP3 =====
./arch/arm/mach-omap2/Makefile:obj-$(CONFIG_ARCH_OMAP3)		+= clock34xx.o
===== CPU_ARM946T =====
./arch/arm/Makefile:tune-$(CONFIG_CPU_ARM946T)	:=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
===== CPU_R4000 =====
./arch/mips/kernel/Makefile:obj-$(CONFIG_CPU_R4000)		+= r4k_fpu.o r4k_switch.o
===== ETRAXFS_SIM =====
./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
===== L7200_KEYB =====
./drivers/acorn/char/Makefile:obj-$(CONFIG_L7200_KEYB)	+= defkeymap-l7200.o keyb_l7200.o
===== MSPETH =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
===== OMAP_MBOX_FWK =====
./arch/arm/plat-omap/Makefile:obj-$(CONFIG_OMAP_MBOX_FWK) += mailbox.o
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
===== XEN_XENCOMM =====
./drivers/xen/Makefile:obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
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
