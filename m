Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZHMKDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZHMKDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZHMKBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:01:48 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:45523 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753960AbZHMKBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:01:47 -0400
Message-Id: <20090813100638.799449205@fluff.org>
References: <20090813100602.545180197@fluff.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:06:06 +0100
From: Ben Dooks <ben@simtec.co.uk>
To: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.ne
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 4/7] spi_s3c24xx: fix header includes
Content-Disposition: inline; filename=spi-fix-includes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver includes <asm/io.h> where it should be including <linux/io.h>
and also includes <mach/hardware.h> and <asm/dma.h> without using anything
from these.

Signed-off-by; Ben Dooks <ben@simtec.co.uk>
---
 drivers/spi/spi_s3c24xx.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: b/drivers/spi/spi_s3c24xx.c
===================================================================
--- a/drivers/spi/spi_s3c24xx.c	2009-07-28 15:19:28.000000000 +0100
+++ b/drivers/spi/spi_s3c24xx.c	2009-07-28 15:20:16.000000000 +0100
@@ -20,14 +20,11 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/io.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
 
-#include <asm/io.h>
-#include <asm/dma.h>
-#include <mach/hardware.h>
-
 #include <plat/regs-spi.h>
 #include <mach/spi.h>
 

-- 
