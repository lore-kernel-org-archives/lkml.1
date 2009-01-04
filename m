Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZADLGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZADLGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZADLF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:05:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZADLF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:05:58 -0500
Subject: [PATCH -tip] x86: i8259.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:33:52 +0530
Message-Id: <1231067032.27852.34.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/acpi.h> instead of <asm/acpi.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: Use #include <linux/delay.h> instead of <asm/delay.h>
ERROR: code indent should use tabs where possible

total: 1 errors, 3 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/i8259.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 4b8a53d..11d5093 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -11,15 +11,15 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/delay.h>
 
-#include <asm/acpi.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
 #include <asm/pgtable.h>
-#include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/arch_hooks.h>
@@ -323,7 +323,7 @@ void init_8259A(int auto_eoi)
 	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
 
 	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
-	                       to 0x20-0x27 on i386 */
+	   to 0x20-0x27 on i386 */
 	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
 
 	/* 8259A-1 (the master) has a slave on IR2 */
-- 
1.5.5.1



