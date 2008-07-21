Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYGUA3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYGUA3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYGUA3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:29:14 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62731 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755446AbYGUA3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:29:13 -0400
Date: Mon, 21 Jul 2008 01:28:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix up a comment in ack_APIC_irq()
Message-ID: <Pine.LNX.4.55.0807210125341.24038@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Adjust a comment in ack_APIC_irq() according to the recent removal of 
CONFIG_X86_GOOD_APIC.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-next-2.6.26-rc9-20080711-apic-write-ack-0
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h	2008-07-16 17:07:56.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h	2008-07-16 23:59:10.000000000 +0000
@@ -78,9 +78,7 @@ extern int get_physical_broadcast(void);
 static inline void ack_APIC_irq(void)
 {
 	/*
-	 * ack_APIC_irq() actually gets compiled as a single instruction:
-	 * - a single rmw on Pentium/82489DX
-	 * - a single write on P6+ cores (CONFIG_X86_GOOD_APIC)
+	 * ack_APIC_irq() actually gets compiled as a single instruction
 	 * ... yummie.
 	 */
 
