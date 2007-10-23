Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXJWElt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXJWElt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXJWEjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:39:23 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58888 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752840AbXJWEjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:39:21 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bsmY001782@goober>
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
diff -Naurp linux-2.6.23/include/asm-m68knommu/system.h linux-2.6.23-uc0/include/asm-m68knommu/system.h
--- linux-2.6.23/include/asm-m68knommu/system.h	2007-10-19 10:21:31.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/system.h	2007-10-19 10:32:28.000000000 +1000
@@ -253,8 +253,7 @@ cmpxchg(volatile int *p, int old, int ne
         ");				\
 })
 #elif defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
-      defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3) || \
-      defined(CONFIG_CLEOPATRA)
+      defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 #define HARD_RESET_NOW() ({		\
         asm("				\
 	movew #0x2700, %sr;		\
