Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYIDLrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYIDLrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYIDLrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:47:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37186 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbYIDLrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:47:39 -0400
Date: Thu, 4 Sep 2008 13:47:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Capitalize function call interrupts consistently
Message-ID: <20080904114738.GA29738@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Capitalize function call interrupts consistently

All other descriptions in /proc/interrupts are capitalized except
for "function call interrupts". Capitalize it too for consistency.

While that's technically a published ABI I think the risk of anyone
relying on that text to stay the same is negligible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6.27-rc4-misc/arch/x86/kernel/irq_32.c
@@ -325,7 +325,7 @@ skip:
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).irq_call_count);
-		seq_printf(p, "  function call interrupts\n");
+		seq_printf(p, "  Function call interrupts\n");
 		seq_printf(p, "TLB: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
Index: linux-2.6.27-rc4-misc/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6.27-rc4-misc/arch/x86/kernel/irq_64.c
@@ -129,7 +129,7 @@ skip:
 		seq_printf(p, "CAL: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_call_count);
-		seq_printf(p, "  function call interrupts\n");
+		seq_printf(p, "  Function call interrupts\n");
 		seq_printf(p, "TLB: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_tlb_count);
