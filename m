Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZIMTjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZIMTjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZIMTi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:38:59 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52544 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZIMTi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W7xylX/FCGcv6Bb59Y/4Xju2OAe3XJfJhyqN49v8NBYHgcW7MxaHSOGJKBEjJeth2E
         8prTWklLyZKGT/X/NOTN+tc3JxjOC5iqR0Wc/xsSuc0LbUSKu+z/TLAWrkC9lvfTi61/
         ao5Zx2GhVb/vq93BEO0lwE+mvg4kS61qOhtBw=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Vegard Nossum <vegardno@ifi.uio.no>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alok N Kataria <akataria@vmware.com>,
       "Tan, Wei Chong" <wei.chong.tan@intel.com>, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/5] Trivial whitespace cleanups
Date: Sun, 13 Sep 2009 22:38:23 +0300
Message-Id: <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/x86/include/asm/string_32.h |    1 -
 arch/x86/kernel/tsc.c            |    2 +-
 drivers/acpi/acpica/tbfadt.c     |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index c86f452..ae907e6 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -65,7 +65,6 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
 	case 4:
 		*(int *)to = *(int *)from;
 		return to;
-
 	case 3:
 		*(short *)to = *(short *)from;
 		*((char *)to + 2) = *((char *)from + 2);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 71f4368..8a2fc11 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -670,7 +670,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
 			(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
 			(val == CPUFREQ_RESUMECHANGE)) {
-		*lpj = 	cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
+		*lpj = cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
 
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 82b02dc..c016335 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -275,7 +275,6 @@ void acpi_tb_parse_fadt(u32 table_index)
 
 void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
 {
-
 	/*
 	 * Check if the FADT is larger than the largest table that we expect
 	 * (the ACPI 2.0/3.0 version). If so, truncate the table, and issue
-- 
1.6.5.rc1

