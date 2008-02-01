Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYBAHdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYBAHdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYBAHc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:32:58 -0500
Received: from rex.snapgear.com ([203.143.235.140]:47299 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754555AbYBAHc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:32:57 -0500
Date: Fri, 1 Feb 2008 17:31:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010731.m117VwM4022551@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: build support for new ColdFire serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add build support for new ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

--- linux-2.6.24/drivers/serial/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/drivers/serial/Makefile	2008-01-30 21:33:00.000000000 +1000
@@ -39,6 +39,7 @@
 obj-$(CONFIG_SERIAL_68328) += 68328serial.o
 obj-$(CONFIG_SERIAL_68360) += 68360serial.o
 obj-$(CONFIG_SERIAL_COLDFIRE) += mcfserial.o
+obj-$(CONFIG_SERIAL_MCF) += mcf.o
 obj-$(CONFIG_V850E_UART) += v850e_uart.o
 obj-$(CONFIG_SERIAL_PMACZILOG) += pmac_zilog.o
 obj-$(CONFIG_SERIAL_LH7A40X) += serial_lh7a40x.o
