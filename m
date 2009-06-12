Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbZFLNdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbZFLNdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763527AbZFLN0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:07 -0400
Received: from ozlabs.org ([203.10.76.45]:55003 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763396AbZFLN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:26:00 -0400
CC: linux-kernel@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 9/17] cpumask: remove unused mask field from struct irqaction.
Message-Id: <20090612132602.882F3DDDD4@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This one snuck in after the patch which removed all the others.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/setup.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1081,7 +1081,6 @@ void __init x86_quirk_time_init(void)
 			return;
 	}
 
-	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 #endif /* CONFIG_X86_32 */

