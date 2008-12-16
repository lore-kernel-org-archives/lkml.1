Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYLPLfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYLPLfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYLPLfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:35:43 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39325 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYLPLfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:35:43 -0500
Message-Id: <4947A0B3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:36:03 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix compiler warning without
	 CONFIG_X86_RESERVE_LOW_64K
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28-rc8/arch/x86/kernel/setup.c	2008-12-11 14:36:52.000000000 +0100
+++ 2.6.28-rc8-x86-dmi-low-mem/arch/x86/kernel/setup.c	2008-12-15 11:35:43.000000000 +0100
@@ -738,6 +738,7 @@ void start_periodic_check_for_corruption
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -749,6 +750,7 @@ static int __init dmi_low_memory_corrupt
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {



