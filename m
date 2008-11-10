Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYKJHwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYKJHwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYKJHwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:52:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58447 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYKJHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:52:12 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20081110909.153463053@firstfloor.org>
In-Reply-To: <20081110909.153463053@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] Fix warning with !CONFIG_X86_RESERVE_LOW_64K
Message-Id: <20081110080939.544E63E660F@basil.firstfloor.org>
Date: Mon, 10 Nov 2008 09:09:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.28-rc4-test/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.28-rc4-test.orig/arch/x86/kernel/setup.c	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-rc4-test/arch/x86/kernel/setup.c	2008-11-10 09:06:00.000000000 +0100
@@ -738,6 +738,7 @@
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -749,6 +750,7 @@
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
