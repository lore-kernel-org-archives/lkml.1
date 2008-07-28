Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYG1ULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYG1ULT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYG1ULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:11:08 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44830 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYG1ULH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:11:07 -0400
Date: Mon, 28 Jul 2008 16:09:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bad CONFIG variable references from Makefiles
Message-ID: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain>
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


  a complete list of all references to non-existent CONFIG variables
exclusively from Makefiles in the tree.  since the list is so short,
i'm not bothering to break it up by subsystem or arch.  enjoy.


===== ARCH_OMAP3 =====
./arch/arm/mach-omap2/Makefile:obj-$(CONFIG_ARCH_OMAP3)		+= clock34xx.o
===== CACHE_XSC3L2 =====
./arch/arm/mm/Makefile:obj-$(CONFIG_CACHE_XSC3L2)	+= cache-xsc3l2.o
===== ETRAXFS_SIM =====
./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
===== FB_SH7343VOU =====
./drivers/video/Makefile:obj-$(CONFIG_FB_SH7343VOU)	  += sh7343_voufb.o
===== HDPU_FEATURES =====
./drivers/misc/Makefile:obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
./drivers/misc/hdpuftrs/Makefile:obj-$(CONFIG_HDPU_FEATURES) := hdpu_cpustate.o hdpu_nexus.o
===== MSPETH =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
===== OMAP_MBOX_FWK =====
./arch/arm/plat-omap/Makefile:obj-$(CONFIG_OMAP_MBOX_FWK) += mailbox.o
===== PROFILE =====
./arch/mn10300/kernel/Makefile:obj-$(CONFIG_PROFILE) += profile.o profile-low.o
===== RADIO_MIROPCM20 =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
===== RADIO_MIROPCM20_RDS =====
./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
===== SA1100_USB =====
./arch/arm/mach-sa1100/Makefile:#obj-$(CONFIG_SA1100_USB)		+= usb/
===== TTY_LOG =====
./arch/um/os-Linux/Makefile:obj-$(CONFIG_TTY_LOG) += tty_log.o
./arch/um/os-Linux/Makefile:user-objs-$(CONFIG_TTY_LOG) += tty_log.o
===== USB_MSP71XX =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
===== V850E_UART =====
./drivers/serial/Makefile:obj-$(CONFIG_V850E_UART) += v850e_uart.o
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
