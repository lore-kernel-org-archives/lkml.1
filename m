Return-Path: <linux-kernel-owner+w=401wt.eu-S935691AbYBAHqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935691AbYBAHqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935168AbYBAHjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:43 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48082 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934815AbYBAHjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:41 -0500
Date: Fri, 1 Feb 2008 17:38:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010738.m117cQt1022734@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove unused CONFIG_DISKtel symbol
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused CONFIG_DISKtel define.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/include/asm-m68knommu/mcfuart.h linux-2.6.24-uc0/include/asm-m68knommu/mcfuart.h
--- linux-2.6.24/include/asm-m68knommu/mcfuart.h	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/include/asm-m68knommu/mcfuart.h	2007-07-13 11:28:58.000000000 +1000
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
