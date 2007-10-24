Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbXJXCGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbXJXCGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbXJXCEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:11 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34299 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753793AbXJXCEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:10 -0400
Date: Wed, 24 Oct 2007 12:03:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23uV3016681@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: add platform struct for ColdFire UART driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform support structure for use with new ColdFire UART driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/mcfuart.h linux-2.6.23-uc0/include/asm-m68knommu/mcfuart.h
--- linux-2.6.23/include/asm-m68knommu/mcfuart.h	2007-10-19 10:21:30.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/mcfuart.h	2007-10-19 10:32:26.000000000 +1000
@@ -51,6 +50,16 @@
 #endif
 
 
+#include <linux/serial_core.h>
+#include <linux/platform_device.h>
+
+struct mcf_platform_uart {
+	unsigned long	mapbase;	/* Physical address base */
+	void __iomem	*membase;	/* Virtual address if mapped */
+	unsigned int	irq;		/* Interrupt vector */
+	unsigned int	uartclk;	/* UART clock rate */
+};
+
 /*
  *	Define the ColdFire UART register set addresses.
  */
