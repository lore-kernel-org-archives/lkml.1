Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXCAPZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXCAPZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965279AbXCAPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:25:00 -0500
Received: from www.osadl.org ([213.239.205.134]:46311 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965275AbXCAPY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:24:59 -0500
Subject: [PATCH 2.6.21-rc2] AT91SAM9261: Enable second and third UART
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: andrew@sanpeople.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 01 Mar 2007 16:24:53 +0100
Message-Id: <1172762693.13036.5.camel@bender.tec.linutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Enable ttyS1 and ttyS2 for the AT91SAM9261EK

Signed-off-by: Jan Altenberg <jan@linutronix.de>

---
 arch/arm/mach-at91/board-sam9261ek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/arm/mach-at91/board-sam9261ek.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/board-sam9261ek.c
+++ linux-2.6/arch/arm/mach-at91/board-sam9261ek.c
@@ -50,8 +50,8 @@
  */
 static struct at91_uart_config __initdata ek_uart_config = {
 	.console_tty	= 0,				/* ttyS0 */
-	.nr_tty		= 1,
-	.tty_map	= { 3, -1, -1, -1 }		/* ttyS0, ..., ttyS3 */
+	.nr_tty		= 3,
+	.tty_map	= { 3, 0, 1, -1 }		/* ttyS0, ..., ttyS3 */
 };
 
 static void __init ek_map_io(void)


