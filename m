Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXLQTj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXLQTj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbXLQTbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:48 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2979 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761024AbXLQTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:42 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] arch/x86/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:24 -0800
Message-Id: <1197919875-5288-25-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/apic_32.c    |    2 +-
 arch/x86/kernel/mpparse_32.c |    2 +-
 arch/x86/kernel/vm86_32.c    |    2 +-
 arch/x86/mm/srat_64.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 96986b4..22346c7 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -110,7 +110,7 @@ static inline int lapic_get_version(void)
 }
 
 /*
- * Check, if the APIC is integrated or a seperate chip
+ * Check, if the APIC is integrated or a separate chip
  */
 static inline int lapic_is_integrated(void)
 {
diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
index 7a05a7f..e12d54e 100644
--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -1049,7 +1049,7 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 	int idx, bit = 0;
 	static int pci_irq = 16;
 	/*
-	 * Mapping between Global System Interrups, which
+	 * Mapping between Global System Interrupts, which
 	 * represent all possible interrupts, and IRQs
 	 * assigned to actual devices.
 	 */
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 157e4be..839619a 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -385,7 +385,7 @@ static inline void clear_AC(struct kernel_vm86_regs * regs)
  * functions. However someone forgot to call clear_IF(regs)
  * in the opposite case.
  * After the command sequence CLI PUSHF STI POPF you should
- * end up with interrups disabled, but you ended up with
+ * end up with interrupts disabled, but you ended up with
  * interrupts enabled.
  *  ( I was testing my own changes, but the only bug I
  *    could find was in a function I had not changed. )
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index ea85172..cd455f9 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -217,7 +217,7 @@ static inline int save_add_info(void) {return 0;}
 #endif
 /*
  * Update nodes_add and decide if to include add are in the zone.
- * Both SPARSE and RESERVE need nodes_add infomation.
+ * Both SPARSE and RESERVE need nodes_add information.
  * This code supports one contiguous hot add area per node.
  */
 static int reserve_hotadd(int node, unsigned long start, unsigned long end)
-- 
1.5.3.7.949.g2221a6

