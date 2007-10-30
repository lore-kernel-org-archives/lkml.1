Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbXJ3Enw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbXJ3Enw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXJ3Emg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:36 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37129 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754044AbXJ3Emf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:35 -0400
Date: Tue, 30 Oct 2007 14:41:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fhit032219@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH]: add build support for new ColdFire serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add build support for the new style ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-rc1/drivers/serial/Makefile linux-2.6.23-rc1.platform/drivers/serial/Makefile
--- linux-2.6.23-rc1/drivers/serial/Makefile	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23-rc1.platform/drivers/serial/Makefile	2007-10-30 11:19:06.000000000 +1000
@@ -39,6 +39,7 @@ obj-$(CONFIG_SERIAL_MUX) += mux.o
 obj-$(CONFIG_SERIAL_68328) += 68328serial.o
 obj-$(CONFIG_SERIAL_68360) += 68360serial.o
 obj-$(CONFIG_SERIAL_COLDFIRE) += mcfserial.o
+obj-$(CONFIG_SERIAL_MCF) += mcf.o
 obj-$(CONFIG_V850E_UART) += v850e_uart.o
 obj-$(CONFIG_SERIAL_PMACZILOG) += pmac_zilog.o
 obj-$(CONFIG_SERIAL_LH7A40X) += serial_lh7a40x.o
