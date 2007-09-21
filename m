Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXIUWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXIUWlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762720AbXIUWcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762069AbXIUWc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:26 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: rostedt@goodmis.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [25/50] x86_64: Add parenthesis to IRQ vector macros
Message-Id: <20070921223224.7BA6C13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Steven Rostedt <rostedt@goodmis.org>
It is not good taste to have macros with additions that do not have
parenthesis's around them.  This patch parethesizes the IRQ vector
macros for x86_64 arch.

Note, this caused me a bit of heart-ache debugging lguest64.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/hw_irq.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux/include/asm-x86_64/hw_irq.h
===================================================================
--- linux.orig/include/asm-x86_64/hw_irq.h
+++ linux/include/asm-x86_64/hw_irq.h
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
