Return-Path: <linux-kernel-owner+w=401wt.eu-S966401AbXJSDvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966401AbXJSDvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763907AbXJSDvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:51:17 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58754 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762259AbXJSDvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:51:17 -0400
Date: Fri, 19 Oct 2007 13:51:03 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190351.l9J3p3U9004618@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove use of undefined symbol CONFIG_DISKtel
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove use of undefined symbol CONFIG_DISKtel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/mcfuart.h linux-2.6.23-uc0/include/asm-m68knommu/mcfuart.h
--- linux-2.6.23/include/asm-m68knommu/mcfuart.h	2007-10-19 10:21:30.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/mcfuart.h	2007-10-19 10:32:26.000000000 +1000
@@ -12,7 +12,6 @@
 #define	mcfuart_h
 /****************************************************************************/
 
-
 /*
  *	Define the base address of the UARTS within the MBAR address
  *	space.
@@ -33,7 +32,7 @@
 #define MCFUART_BASE2		0x240           /* Base address of UART2 */
 #define MCFUART_BASE3		0x280           /* Base address of UART3 */
 #elif defined(CONFIG_M5249) || defined(CONFIG_M5307) || defined(CONFIG_M5407)
-#if defined(CONFIG_NETtel) || defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3)
+#if defined(CONFIG_NETtel) || defined(CONFIG_SECUREEDGEMP3)
 #define MCFUART_BASE1		0x200           /* Base address of UART1 */
 #define MCFUART_BASE2		0x1c0           /* Base address of UART2 */
 #else
