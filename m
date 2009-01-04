Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZADLIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZADLIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZADLIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:08:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZADLIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:08:39 -0500
Subject: [PATCH -tip] x86: irqinit_64.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:36:25 +0530
Message-Id: <1231067185.27852.39.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems

Fixes style problems:
WARNING: Use #include <linux/acpi.h> instead of <asm/acpi.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: Use #include <linux/delay.h> instead of <asm/delay.h>

total: 0 errors, 3 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irqinit_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index c246841..4dec438 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -11,14 +11,14 @@
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
 #include <asm/hw_irq.h>
 #include <asm/pgtable.h>
-#include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
-- 
1.5.5.1



