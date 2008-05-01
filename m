Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbYEACTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbYEACTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbYEACRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:25 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57506 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758877AbYEACRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:24 -0400
Date: Thu, 1 May 2008 12:16:53 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010216.m412GrtL004118@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: fix 5206e UART init function naming
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ColdFire 5206e platform UART init function naming.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/platform/5206e/config.c linux-2.6.25-uc0/arch/m68knommu/platform/5206e/config.c
--- linux-2.6.25/arch/m68knommu/platform/5206e/config.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/platform/5206e/config.c	2008-02-01 15:37:56.000000000 +1000
@@ -48,7 +48,7 @@ static struct platform_device *m5206e_de
 
 /***************************************************************************/
 
-static void __init m5206_uart_init_line(int line, int irq)
+static void __init m5206e_uart_init_line(int line, int irq)
 {
 	if (line == 0) {
 		writel(MCFSIM_ICR_LEVEL6 | MCFSIM_ICR_PRI1, MCF_MBAR + MCFSIM_UART1ICR);
