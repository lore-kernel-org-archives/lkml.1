Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZADKsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZADKsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZADKsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:48:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZADKsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:48:31 -0500
Subject: [PATCH -tip] x86: apic.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:16:25 +0530
Message-Id: <1231065985.27852.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
WARNING: Use #include <linux/nmi.h> instead of <asm/nmi.h>
WARNING: Use #include <linux/timex.h> instead of <asm/timex.h>
WARNING: line over 80 characters
ERROR: else should follow close brace '}'

total: 2 errors, 4 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 329b201..d2d17b8 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -31,10 +31,12 @@
 #include <linux/dmi.h>
 #include <linux/dmar.h>
 #include <linux/ftrace.h>
+#include <linux/smp.h>
+#include <linux/nmi.h>
+#include <linux/timex.h>
 
 #include <asm/perf_counter.h>
 #include <asm/atomic.h>
-#include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/desc.h>
@@ -42,10 +44,8 @@
 #include <asm/hpet.h>
 #include <asm/pgalloc.h>
 #include <asm/i8253.h>
-#include <asm/nmi.h>
 #include <asm/idle.h>
 #include <asm/proto.h>
-#include <asm/timex.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
 
@@ -688,7 +688,7 @@ static int __init calibrate_APIC_clock(void)
 		local_irq_enable();
 
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
-		pr_warning("APIC timer disabled due to verification failure.\n");
+		pr_warning("APIC timer disabled due to verification failure\n");
 			return -1;
 	}
 
@@ -2089,14 +2089,12 @@ __cpuinit int apic_is_clustered_box(void)
 		/* are we being called early in kernel startup? */
 		if (bios_cpu_apicid) {
 			id = bios_cpu_apicid[i];
-		}
-		else if (i < nr_cpu_ids) {
+		} else if (i < nr_cpu_ids) {
 			if (cpu_present(i))
 				id = per_cpu(x86_bios_cpu_apicid, i);
 			else
 				continue;
-		}
-		else
+		} else
 			break;
 
 		if (id != BAD_APICID)
-- 
1.5.5.1



