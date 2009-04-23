Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZDWAMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZDWAMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZDWAMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:12:34 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:59395 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZDWAMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:12:33 -0400
Date: Wed, 22 Apr 2009 20:11:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bad references to CONFIG variables from Makefiles
Message-ID: <alpine.LFD.2.00.0904222009340.19256@localhost.localdomain>
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


  a much shorter list of references to non-existent CONFIG variables
from Makefiles only, short enough to just include inline:

===== ATHEROS_AR71XX =====
./drivers/net/wireless/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
===== ETRAXFS_SIM =====
./arch/cris/arch-v32/kernel/Makefile:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
===== EVENT_PROFILE =====
./kernel/trace/Makefile:obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
===== FB_CYBLA =====
./drivers/video/Makefile:obj-$(CONFIG_FB_CYBLA)            += cyblafb.o
===== HAVE_GPIO_LIB =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_HAVE_GPIO_LIB) += gpio.o gpio_extended.o
===== HDPU_FEATURES =====
./drivers/misc/hdpuftrs/Makefile:obj-$(CONFIG_HDPU_FEATURES) := hdpu_cpustate.o hdpu_nexus.o
./drivers/misc/Makefile:obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
===== IPIPE =====
./arch/blackfin/kernel/Makefile:obj-$(CONFIG_IPIPE)                  += ipipe.o
===== IPIPE_TRACE_MCOUNT =====
./arch/blackfin/kernel/Makefile:obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o
===== MSPETH =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
===== PROFILE =====
./arch/mn10300/kernel/Makefile:obj-$(CONFIG_PROFILE) += profile.o profile-low.o
===== SND_SOC_WM8991 =====
./sound/soc/codecs/Makefile:obj-$(CONFIG_SND_SOC_WM8991)	+= snd-soc-wm8991.o
===== USB_MSP71XX =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
===== XFS_TRACE =====
./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o \
./fs/xfs/Makefile:xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
===== XILINX_MICROBLAZE0_USE_PCMP =====
./arch/microblaze/Makefile:CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP) += -mxl-pattern-compare
===== XTENSA_VARIANT_LINUX_CUSTOM =====
./arch/xtensa/Makefile:variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)	:= custom

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
