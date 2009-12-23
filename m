Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbZLWLhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbZLWLhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 06:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZLWLhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 06:37:05 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:43938 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZLWLhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 06:37:02 -0500
Date: Wed, 23 Dec 2009 06:36:33 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: short list of bad Kconfig "select" directives
Message-ID: <alpine.LFD.2.00.0912230634460.21971@localhost>
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


  from the latest "git pull," a fairly short list of Kconfig "select"
directives that refer to apparently non-existent Kconfig variables,
each accompanied by a treewide scan to see anything that matches that
string.

  if you want to delete something, feel free.


===== CRYPTO_SHASH
crypto/Kconfig:308:	select CRYPTO_SHASH
crypto/Kconfig:446:	select CRYPTO_SHASH
===== GCD
arch/arm/plat-pxa/include/plat/i2c.h:39:*  7.  GCD      1 (Disables i2c unit response to general call messages as a slave)
arch/mips/Kconfig:45:	select GCD
drivers/i2c/busses/i2c-pxa.c:184:	PXA_BIT(ICR_GCD,    "GCD",	NULL),
fs/jffs2/background.c:99:		/* Problem - immediately after bootup, the GCD spends a lot
fs/jffs2/background.c:103:		 * doesn't help, either (presumably because userspace and GCD
fs/jffs2/background.c:106:		 * This forces the GCD to slow the hell down.   Pulling an
===== GENERIC_HAS_IOMAP
arch/score/Kconfig:16:	select GENERIC_HAS_IOMAP
arch/score/Kconfig:22:	select GENERIC_HAS_IOMAP
arch/score/Kconfig:28:	select GENERIC_HAS_IOMAP
===== HAVE_READQ
arch/x86/Kconfig:22:	select HAVE_READQ
===== HAVE_WRITEQ
arch/x86/Kconfig:23:	select HAVE_WRITEQ
===== MACH_NEO1973
arch/arm/mach-s3c2442/Kconfig:32:	select MACH_NEO1973
===== MPC5121_ADS_CPLD
arch/powerpc/platforms/512x/Kconfig:18:	select MPC5121_ADS_CPLD
===== PPC_FSL_BOOK3E
arch/powerpc/platforms/85xx/Kconfig:151:	select PPC_FSL_BOOK3E
===== S3C2410_PWM
arch/arm/mach-s3c2442/Kconfig:33:	select S3C2410_PWM
===== S3C_DEVICE_NAND
arch/arm/plat-s3c24xx/Kconfig:11:	select S3C_DEVICE_NAND
===== SFFSDR_FPGA
sound/soc/davinci/Kconfig:40:	select SFFSDR_FPGA
===== SIBYTE_CFE
arch/mips/sibyte/Kconfig:74:	select SIBYTE_CFE
===== SPI_MASTER_OF
drivers/spi/Kconfig:139:	select SPI_MASTER_OF
===== USB_GADGET_S3C_HSOTG_PIO
drivers/usb/gadget/Kconfig:297:	select USB_GADGET_S3C_HSOTG_PIO
===== XEN_XENBUS_FRONTEND
drivers/input/Kconfig:168:	select XEN_XENBUS_FRONTEND
drivers/video/Kconfig:2084:	select XEN_XENBUS_FRONTEND


rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
