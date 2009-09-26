Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZIZPad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZIZPad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZIZPac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:30:32 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34963 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZIZPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:30:31 -0400
Date: Sat, 26 Sep 2009 11:30:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel Makefiles that refer to non-existent CONFIG variables
Message-ID: <alpine.LFD.2.00.0909261127100.31074@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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


  since the following list is short, i'll just toss it out there --
Makefiles that use, for conditional processing, CONFIG variables that
don't appear to even exist (meaning, of course, that the corresponding
contents will never, ever be processed).  like i said, it's a short
list so, what the heck:

===== ARCH_QSD =====
./drivers/staging/dream/camera/Makefile:obj-$(CONFIG_ARCH_QSD) += msm_vfe8x.o msm_vfe8x_proc.o msm_io8x.o
===== ATHEROS_AR71XX =====
./drivers/net/wireless/ath/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
===== HAVE_GPIO_LIB =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_HAVE_GPIO_LIB) += gpio.o gpio_extended.o
===== HDPU_FEATURES =====
./drivers/misc/Makefile:obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
./drivers/misc/hdpuftrs/Makefile:obj-$(CONFIG_HDPU_FEATURES) := hdpu_cpustate.o hdpu_nexus.o
===== IPIPE =====
./arch/blackfin/kernel/Makefile:obj-$(CONFIG_IPIPE)                  += ipipe.o
===== KEYBOARD_QT2160 =====
./drivers/input/keyboard/Makefile:obj-$(CONFIG_KEYBOARD_QT2160)		+= qt2160.o
===== MSM_ADSP =====
./drivers/staging/dream/Makefile:obj-$(CONFIG_MSM_ADSP)		+= qdsp5/ smd/
===== MSPETH =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
===== PPC_BOOK3E_32 =====
./arch/powerpc/kernel/Makefile:extra-$(CONFIG_PPC_BOOK3E_32)	:= head_new_booke.o
===== PROFILE =====
./arch/mn10300/kernel/Makefile:obj-$(CONFIG_PROFILE) += profile.o profile-low.o
===== PROM_CONSOLE =====
./arch/mips/dec/Makefile:obj-$(CONFIG_PROM_CONSOLE)	+= promcon.o
===== USB_MSP71XX =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
===== XFS_TRACE =====
./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o \
./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
===== XTENSA_VARIANT_LINUX_CUSTOM =====
./arch/xtensa/Makefile:variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)	:= custom

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
