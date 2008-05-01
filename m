Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYEACRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYEACRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYEACRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:10 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57497 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755415AbYEACRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:09 -0400
Date: Thu, 1 May 2008 12:16:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010216.m412GX8J004099@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: add a missing backslash n in setup code
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

add a missing backslash n in setup code

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/kernel/setup.c linux-2.6.25-uc0/arch/m68knommu/kernel/setup.c
--- linux-2.6.25/arch/m68knommu/kernel/setup.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/kernel/setup.c	2008-04-22 14:48:44.000000000 +1000
@@ -162,7 +162,7 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "DragonEngine II board support by Georges Menie\n");
 #endif
 #ifdef CONFIG_M5235EVB
-	printk(KERN_INFO "Motorola M5235EVB support (C)2005 Syn-tech Systems, Inc. (Jate Sujjavanich)");
+	printk(KERN_INFO "Motorola M5235EVB support (C)2005 Syn-tech Systems, Inc. (Jate Sujjavanich)\n");
 #endif
 
 #ifdef DEBUG
