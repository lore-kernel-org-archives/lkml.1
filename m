Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbXH3UHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbXH3UHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbXH3UG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:06:56 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:54850 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbXH3UGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:06:55 -0400
Subject: [PATCH] Add parenthesis to IRQ vector macros
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 16:06:34 -0400
Message-Id: <1188504394.912.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is not good taste to have macros with additions that do not have
parenthesis's around them.  This patch parethesizes the IRQ vector
macros for x86_64 arch.

Note, this caused me a bit of heart-ache debugging lguest64.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/asm-x86_64/hw_irq.h b/include/asm-x86_64/hw_irq.h
index 09dfc18..9f00f69 100644
--- a/include/asm-x86_64/hw_irq.h
+++ b/include/asm-x86_64/hw_irq.h
@@ -40,22 +40,22 @@
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
  */
-#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR + 0x10
-#define IRQ1_VECTOR		IRQ0_VECTOR + 1
-#define IRQ2_VECTOR		IRQ0_VECTOR + 2
-#define IRQ3_VECTOR		IRQ0_VECTOR + 3
-#define IRQ4_VECTOR		IRQ0_VECTOR + 4
-#define IRQ5_VECTOR		IRQ0_VECTOR + 5 
-#define IRQ6_VECTOR		IRQ0_VECTOR + 6
-#define IRQ7_VECTOR		IRQ0_VECTOR + 7
-#define IRQ8_VECTOR		IRQ0_VECTOR + 8
-#define IRQ9_VECTOR		IRQ0_VECTOR + 9
-#define IRQ10_VECTOR		IRQ0_VECTOR + 10
-#define IRQ11_VECTOR		IRQ0_VECTOR + 11
-#define IRQ12_VECTOR		IRQ0_VECTOR + 12
-#define IRQ13_VECTOR		IRQ0_VECTOR + 13
-#define IRQ14_VECTOR		IRQ0_VECTOR + 14
-#define IRQ15_VECTOR		IRQ0_VECTOR + 15
+#define IRQ0_VECTOR		(FIRST_EXTERNAL_VECTOR + 0x10)
+#define IRQ1_VECTOR		(IRQ0_VECTOR + 1)
+#define IRQ2_VECTOR		(IRQ0_VECTOR + 2)
+#define IRQ3_VECTOR		(IRQ0_VECTOR + 3)
+#define IRQ4_VECTOR		(IRQ0_VECTOR + 4)
+#define IRQ5_VECTOR		(IRQ0_VECTOR + 5)
+#define IRQ6_VECTOR		(IRQ0_VECTOR + 6)
+#define IRQ7_VECTOR		(IRQ0_VECTOR + 7)
+#define IRQ8_VECTOR		(IRQ0_VECTOR + 8)
+#define IRQ9_VECTOR		(IRQ0_VECTOR + 9)
+#define IRQ10_VECTOR		(IRQ0_VECTOR + 10)
+#define IRQ11_VECTOR		(IRQ0_VECTOR + 11)
+#define IRQ12_VECTOR		(IRQ0_VECTOR + 12)
+#define IRQ13_VECTOR		(IRQ0_VECTOR + 13)
+#define IRQ14_VECTOR		(IRQ0_VECTOR + 14)
+#define IRQ15_VECTOR		(IRQ0_VECTOR + 15)
 
 /*
  * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
diff --git a/kernel/fork.c b/kernel/fork.c


