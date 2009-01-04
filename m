Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbZADK5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbZADK5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZADK5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:57:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:45733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZADK5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:57:36 -0500
Subject: [PATCH -tip] x86: irq_64.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:25:19 +0530
Message-Id: <1231066519.27852.17.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
ERROR: code indent should use tabs where possible

total: 9 errors, 2 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irq_64.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 6383d50..63c88e6 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -14,10 +14,10 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/ftrace.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
+#include <linux/smp.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
-#include <asm/smp.h>
 
 /*
  * Probabilistic stack overflow check:
@@ -142,18 +142,18 @@ extern void call_softirq(void);
 
 asmlinkage void do_softirq(void)
 {
- 	__u32 pending;
- 	unsigned long flags;
+	__u32 pending;
+	unsigned long flags;
 
- 	if (in_interrupt())
- 		return;
+	if (in_interrupt())
+		return;
 
- 	local_irq_save(flags);
- 	pending = local_softirq_pending();
- 	/* Switch to interrupt stack */
- 	if (pending) {
+	local_irq_save(flags);
+	pending = local_softirq_pending();
+	/* Switch to interrupt stack */
+	if (pending) {
 		call_softirq();
 		WARN_ON_ONCE(softirq_count());
 	}
- 	local_irq_restore(flags);
+	local_irq_restore(flags);
 }
-- 
1.5.5.1



