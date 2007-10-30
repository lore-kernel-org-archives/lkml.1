Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbXJ3Eng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbXJ3Eng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbXJ3Em2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:28 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37125 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846AbXJ3Em1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:27 -0400
Date: Tue, 30 Oct 2007 14:41:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fQCZ032213@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use ARRAY_SIZE in ColdFire serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use ARRAY_SIZE macroto get maximum ports in ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-rc1/drivers/serial/mcf.c linux-2.6.23-rc1.platform/drivers/serial/mcf.c
--- linux-2.6.23-rc1/drivers/serial/mcf.c	2007-10-25 10:49:13.000000000 +1000
+++ linux-2.6.23-rc1.platform/drivers/serial/mcf.c	2007-10-30 11:18:30.000000000 +1000
@@ -434,7 +434,7 @@ static struct uart_ops mcf_uart_ops = {
 
 static struct mcf_uart mcf_ports[3];
 
-#define	MCF_MAXPORTS	(sizeof(mcf_ports) / sizeof(struct mcf_uart))
+#define	MCF_MAXPORTS	ARRAY_SIZE(mcf_ports)
 
 /****************************************************************************/
 #if defined(CONFIG_SERIAL_MCF_CONSOLE)
