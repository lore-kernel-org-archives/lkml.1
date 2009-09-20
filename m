Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZITS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZITS3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZITS33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:29:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:56238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZITS32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:29:28 -0400
Date: Sun, 20 Sep 2009 18:28:56 GMT
From: tip-bot for Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, wei.chong.tan@intel.com, vegardno@ifi.uio.no,
       akpm@linux-foundation.org, ming.m.lin@intel.com, tglx@linutronix.de,
       felipe.contreras@gmail.com, akataria@vmware.com, mingo@elte.hu,
       robert.moore@intel.com, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, wei.chong.tan@intel.com, vegardno@ifi.uio.no,
       akpm@linux-foundation.org, ming.m.lin@intel.com, akataria@vmware.com,
       tglx@linutronix.de, felipe.contreras@gmail.com, len.brown@intel.com,
       robert.moore@intel.com, mingo@elte.hu
In-Reply-To: <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
References: <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Trivial whitespace cleanups
Message-ID: <tip-878f4f533e5b4498215e67e0f886b0fc81417f5e@git.kernel.org>
Git-Commit-ID: 878f4f533e5b4498215e67e0f886b0fc81417f5e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:28:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  878f4f533e5b4498215e67e0f886b0fc81417f5e
Gitweb:     http://git.kernel.org/tip/878f4f533e5b4498215e67e0f886b0fc81417f5e
Author:     Felipe Contreras <felipe.contreras@gmail.com>
AuthorDate: Thu, 17 Sep 2009 00:38:38 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:18:57 +0200

x86: Trivial whitespace cleanups

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alok N Kataria <akataria@vmware.com>
Cc: "Tan Wei Chong" <wei.chong.tan@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
LKML-Reference: <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
