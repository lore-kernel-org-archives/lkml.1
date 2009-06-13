Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbZFMNXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbZFMNXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZFMNXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:23:04 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:50328 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZFMNXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:23:03 -0400
Date: Sat, 13 Jun 2009 09:21:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Makefiles that contain references to non-existent CONFIG vars
Message-ID: <alpine.LFD.2.00.0906130918430.15703@localhost>
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


  just for the fun of it, here's the (short) result of scanning the
current tree for Makefiles *only* that contain references to CONFIG
variables that don't appear to exist.  once -rc1 is out, i'll do this
again officially and direct to the appropriate people but since it's
such a short list, i figured i'd post it now and people can take a
whack at it.

===== ATHEROS_AR71XX =====
./drivers/net/wireless/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
===== GENERIC_CSUM =====
./lib/Makefile:obj-$(CONFIG_GENERIC_CSUM) += checksum.o
===== HAVE_GPIO_LIB =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_HAVE_GPIO_LIB) += gpio.o gpio_extended.o
===== HDPU_FEATURES =====
./drivers/misc/Makefile:obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
./drivers/misc/hdpuftrs/Makefile:obj-$(CONFIG_HDPU_FEATURES) := hdpu_cpustate.o hdpu_nexus.o
===== IPIPE_TRACE_MCOUNT =====
./arch/blackfin/kernel/Makefile:obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o
===== MSPETH =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
===== PROFILE =====
./arch/mn10300/kernel/Makefile:obj-$(CONFIG_PROFILE) += profile.o profile-low.o
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
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
