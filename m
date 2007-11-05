Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbXKEPGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbXKEPGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXKEPFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:05:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXKEPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:05:53 -0500
Date: Mon, 5 Nov 2007 16:05:39 +0100
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: dirk.behme@de.bosch.com, marek.vasut@gmail.com,
       Andre Haupt <andre@bitwigglers.org>
Subject: [patch 1/1] remove double includes
Message-ID: <20071105150539.GA29892@ahaupt-debian-vm.localdomain>
References: <20071105150409.926195727@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=omap1_fix_includes
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX1+KUdGDoMC1/bYAjgpa32OVBCrfjtihAXWaEpt
 gXDi27jwFWwGFK9mZjMOiKJRp0wy+AqbOcJ0QrLnHDPvQkYjsU
 kbJvx3wpr+kg+QE2gOKXhSmu507zBrN3sQGpEJLAt4=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>

---
 arch/arm/mach-omap1/board-nokia770.c |    1 -
 arch/arm/mach-omap1/board-osk.c      |    1 -
 arch/arm/mach-omap1/board-palmtt.c   |    1 -
 arch/arm/mach-omap1/board-palmz71.c  |    1 -
 4 files changed, 4 deletions(-)

Index: linus/arch/arm/mach-omap1/board-nokia770.c
===================================================================
--- linus.orig/arch/arm/mach-omap1/board-nokia770.c	2007-11-05 15:57:27.000000000 +0100
+++ linus/arch/arm/mach-omap1/board-nokia770.c	2007-11-05 15:58:08.000000000 +0100
@@ -32,7 +32,6 @@
 #include <asm/arch/common.h>
 #include <asm/arch/dsp_common.h>
 #include <asm/arch/aic23.h>
-#include <asm/arch/gpio.h>
 #include <asm/arch/omapfb.h>
 #include <asm/arch/lcd_mipid.h>
 
Index: linus/arch/arm/mach-omap1/board-osk.c
===================================================================
--- linus.orig/arch/arm/mach-omap1/board-osk.c	2007-11-05 15:58:30.000000000 +0100
+++ linus/arch/arm/mach-omap1/board-osk.c	2007-11-05 15:59:12.000000000 +0100
@@ -31,7 +31,6 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/interrupt.h>
 #include <linux/i2c.h>
 
 #include <linux/mtd/mtd.h>
Index: linus/arch/arm/mach-omap1/board-palmtt.c
===================================================================
--- linus.orig/arch/arm/mach-omap1/board-palmtt.c	2007-11-05 15:59:31.000000000 +0100
+++ linus/arch/arm/mach-omap1/board-palmtt.c	2007-11-05 16:00:31.000000000 +0100
@@ -42,7 +42,6 @@
 #include <asm/arch/common.h>
 #include <asm/arch/omap-alsa.h>
 
-#include <linux/input.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 
Index: linus/arch/arm/mach-omap1/board-palmz71.c
===================================================================
--- linus.orig/arch/arm/mach-omap1/board-palmz71.c	2007-11-05 16:00:47.000000000 +0100
+++ linus/arch/arm/mach-omap1/board-palmz71.c	2007-11-05 16:01:21.000000000 +0100
@@ -44,7 +44,6 @@
 #include <asm/arch/common.h>
 #include <asm/arch/omap-alsa.h>
 
-#include <linux/input.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 

--
