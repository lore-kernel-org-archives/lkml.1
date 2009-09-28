Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZI1ULE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZI1ULE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZI1ULD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:11:03 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:50043 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZI1ULC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:11:02 -0400
Date: Mon, 28 Sep 2009 16:11:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: final scan results:  bad Kconfig "select"s
Message-ID: <alpine.LFD.2.00.0909281609270.16036@localhost>
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


  short list of "select" directives to non-existent Kconfig variables:

===== CRYPTO_SHASH.
crypto/Kconfig:	select CRYPTO_SHASH
===== GCD.
arch/arm/plat-pxa/include/plat/i2c.h:*  7.  GCD      1 (Disables i2c unit response to general call messages as a slave)
arch/mips/Kconfig:	select GCD
drivers/i2c/busses/i2c-pxa.c:	PXA_BIT(ICR_GCD,    "GCD",	NULL),
fs/jffs2/background.c:		/* Problem - immediately after bootup, the GCD spends a lot
fs/jffs2/background.c:		 * doesn't help, either (presumably because userspace and GCD
fs/jffs2/background.c:		 * This forces the GCD to slow the hell down.   Pulling an
===== GENERIC_HAS_IOMAP.
arch/score/Kconfig:	select GENERIC_HAS_IOMAP
arch/score/Kconfig:	select GENERIC_HAS_IOMAP
arch/score/Kconfig:	select GENERIC_HAS_IOMAP
===== HAVE_FTRACE_SYSCALLS.
arch/sh/Kconfig:	select HAVE_FTRACE_SYSCALLS
Documentation/trace/ftrace-design.txt:HAVE_FTRACE_SYSCALLS
===== HAVE_READQ.
arch/x86/Kconfig:	select HAVE_READQ
===== HAVE_WRITEQ.
arch/x86/Kconfig:	select HAVE_WRITEQ
===== MACH_NEO1973.
arch/arm/mach-s3c2442/Kconfig:	select MACH_NEO1973
===== MPC5121_ADS_CPLD.
arch/powerpc/platforms/512x/Kconfig:	select MPC5121_ADS_CPLD
===== S3C2410_PWM.
arch/arm/mach-s3c2442/Kconfig:	select S3C2410_PWM
===== S3C_DEVICE_NAND.
arch/arm/plat-s3c24xx/Kconfig:	select S3C_DEVICE_NAND
===== S5PC1XX_SETUP_I2C1.
arch/arm/mach-s5pc100/Kconfig:	select S5PC1XX_SETUP_I2C1
===== SFFSDR_FPGA.
sound/soc/davinci/Kconfig:	select SFFSDR_FPGA
===== SIBYTE_CFE.
arch/mips/sibyte/Kconfig:	select SIBYTE_CFE
===== USB_GADGET_S3C_HSOTG_PIO.
drivers/usb/gadget/Kconfig:	select USB_GADGET_S3C_HSOTG_PIO


rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
