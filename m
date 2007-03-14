Return-Path: <linux-kernel-owner+w=401wt.eu-S933851AbXCNFP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbXCNFP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933850AbXCNFMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:36 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:48725 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbXCNFMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:16 -0400
Message-Id: <20070314051050.688415057@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 18/18] Straight file moves
Content-Disposition: inline; filename=rename.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a list of files that were moved from either i386 or x86_64 over
to the arch/x86 directory.  Since I now used the git-diff -M option
(thanks Linus!), and to spare LKML with a lot of patches, I put all
the renames that were unmodified (strictly renamed) into this file,
with one exception.  I put the moving of the speedstep-lib.h file
in it's own file to allow for discussion on that, (ok Chris).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/i386/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
similarity index 100%
rename from arch/i386/kernel/acpi/boot.c
rename to arch/x86/kernel/acpi/boot.c
diff --git a/arch/i386/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
similarity index 100%
rename from arch/i386/kernel/acpi/cstate.c
rename to arch/x86/kernel/acpi/cstate.c
diff --git a/arch/i386/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
similarity index 100%
rename from arch/i386/kernel/acpi/processor.c
rename to arch/x86/kernel/acpi/processor.c
diff --git a/arch/i386/kernel/alternative.c b/arch/x86/kernel/alternative.c
similarity index 100%
rename from arch/i386/kernel/alternative.c
rename to arch/x86/kernel/alternative.c
diff --git a/arch/i386/kernel/bootflag.c b/arch/x86/kernel/bootflag.c
similarity index 100%
rename from arch/i386/kernel/bootflag.c
rename to arch/x86/kernel/bootflag.c
diff --git a/arch/i386/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
similarity index 100%
rename from arch/i386/kernel/cpu/intel_cacheinfo.c
rename to arch/x86/kernel/cpu/intel_cacheinfo.c
diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
similarity index 100%
rename from arch/i386/kernel/cpu/mcheck/therm_throt.c
rename to arch/x86/kernel/cpu/mcheck/therm_throt.c
diff --git a/arch/i386/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/Makefile
rename to arch/x86/kernel/cpu/mtrr/Makefile
diff --git a/arch/i386/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/amd.c
rename to arch/x86/kernel/cpu/mtrr/amd.c
diff --git a/arch/i386/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/centaur.c
rename to arch/x86/kernel/cpu/mtrr/centaur.c
diff --git a/arch/i386/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/cyrix.c
rename to arch/x86/kernel/cpu/mtrr/cyrix.c
diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/generic.c
rename to arch/x86/kernel/cpu/mtrr/generic.c
diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/if.c
rename to arch/x86/kernel/cpu/mtrr/if.c
diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/main.c
rename to arch/x86/kernel/cpu/mtrr/main.c
diff --git a/arch/i386/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/mtrr.h
rename to arch/x86/kernel/cpu/mtrr/mtrr.h
diff --git a/arch/i386/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
similarity index 100%
rename from arch/i386/kernel/cpu/mtrr/state.c
rename to arch/x86/kernel/cpu/mtrr/state.c
diff --git a/arch/i386/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
similarity index 100%
rename from arch/i386/kernel/cpuid.c
rename to arch/x86/kernel/cpuid.c
diff --git a/arch/x86_64/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
similarity index 100%
rename from arch/x86_64/kernel/early_printk.c
rename to arch/x86/kernel/early_printk.c
diff --git a/arch/i386/kernel/i8237.c b/arch/x86/kernel/i8237.c
similarity index 100%
rename from arch/i386/kernel/i8237.c
rename to arch/x86/kernel/i8237.c
diff --git a/arch/x86_64/kernel/k8.c b/arch/x86/kernel/k8.c
similarity index 100%
rename from arch/x86_64/kernel/k8.c
rename to arch/x86/kernel/k8.c
diff --git a/arch/i386/kernel/microcode.c b/arch/x86/kernel/microcode.c
similarity index 100%
rename from arch/i386/kernel/microcode.c
rename to arch/x86/kernel/microcode.c
diff --git a/arch/i386/kernel/msr.c b/arch/x86/kernel/msr.c
similarity index 100%
rename from arch/i386/kernel/msr.c
rename to arch/x86/kernel/msr.c
diff --git a/arch/i386/kernel/pcspeaker.c b/arch/x86/kernel/pcspeaker.c
similarity index 100%
rename from arch/i386/kernel/pcspeaker.c
rename to arch/x86/kernel/pcspeaker.c
diff --git a/arch/i386/kernel/quirks.c b/arch/x86/kernel/quirks.c
similarity index 100%
rename from arch/i386/kernel/quirks.c
rename to arch/x86/kernel/quirks.c
diff --git a/arch/x86_64/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
similarity index 100%
rename from arch/x86_64/kernel/stacktrace.c
rename to arch/x86/kernel/stacktrace.c
diff --git a/arch/i386/kernel/topology.c b/arch/x86/kernel/topology.c
similarity index 100%
rename from arch/i386/kernel/topology.c
rename to arch/x86/kernel/topology.c
diff --git a/arch/x86_64/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
similarity index 100%
rename from arch/x86_64/kernel/tsc_sync.c
rename to arch/x86/kernel/tsc_sync.c
diff --git a/arch/i386/lib/msr-on-cpu.c b/arch/x86/lib/msr-on-cpu.c
similarity index 100%
rename from arch/i386/lib/msr-on-cpu.c
rename to arch/x86/lib/msr-on-cpu.c
diff --git a/arch/i386/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
similarity index 100%
rename from arch/i386/mm/hugetlbpage.c
rename to arch/x86/mm/hugetlbpage.c
diff --git a/arch/i386/oprofile/Kconfig b/arch/x86/oprofile/Kconfig
similarity index 100%
rename from arch/i386/oprofile/Kconfig
rename to arch/x86/oprofile/Kconfig
diff --git a/arch/i386/oprofile/Makefile b/arch/x86/oprofile/Makefile
similarity index 100%
rename from arch/i386/oprofile/Makefile
rename to arch/x86/oprofile/Makefile
diff --git a/arch/i386/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
similarity index 100%
rename from arch/i386/oprofile/backtrace.c
rename to arch/x86/oprofile/backtrace.c
diff --git a/arch/i386/oprofile/init.c b/arch/x86/oprofile/init.c
similarity index 100%
rename from arch/i386/oprofile/init.c
rename to arch/x86/oprofile/init.c
diff --git a/arch/i386/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
similarity index 100%
rename from arch/i386/oprofile/nmi_int.c
rename to arch/x86/oprofile/nmi_int.c
diff --git a/arch/i386/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
similarity index 100%
rename from arch/i386/oprofile/nmi_timer_int.c
rename to arch/x86/oprofile/nmi_timer_int.c
diff --git a/arch/i386/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
similarity index 100%
rename from arch/i386/oprofile/op_counter.h
rename to arch/x86/oprofile/op_counter.h
diff --git a/arch/i386/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
similarity index 100%
rename from arch/i386/oprofile/op_model_athlon.c
rename to arch/x86/oprofile/op_model_athlon.c
diff --git a/arch/i386/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
similarity index 100%
rename from arch/i386/oprofile/op_model_p4.c
rename to arch/x86/oprofile/op_model_p4.c
diff --git a/arch/i386/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
similarity index 100%
rename from arch/i386/oprofile/op_model_ppro.c
rename to arch/x86/oprofile/op_model_ppro.c
diff --git a/arch/i386/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
similarity index 100%
rename from arch/i386/oprofile/op_x86_model.h
rename to arch/x86/oprofile/op_x86_model.h
diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
rename to arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/powernow-k8.c
rename to arch/x86/kernel/cpu/cpufreq/powernow-k8.c
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/powernow-k8.h
rename to arch/x86/kernel/cpu/cpufreq/powernow-k8.h
diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
rename to arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c

--
