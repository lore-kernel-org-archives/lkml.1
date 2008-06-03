Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbYFCUGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbYFCUGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYFCUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:06:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15951 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYFCUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:06:11 -0400
Message-ID: <4845A42F.5050505@ct.jp.nec.com>
Date: Tue, 03 Jun 2008 13:06:07 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: move bugs_64.c to cpu/bugs_64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

It looks good to move bugs_64.c to cpu/bugs_64.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/Makefile            |    1 -
 arch/x86/kernel/cpu/Makefile        |    1 +
 arch/x86/kernel/{ => cpu}/bugs_64.c |    0 
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/x86/kernel/{ => cpu}/bugs_64.c (100%)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index afaed81..d288187 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
 obj-y			+= bootflag.o e820_$(BITS).o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
-obj-$(CONFIG_X86_64)	+= bugs_64.o
 obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index c77a1c5..65b1be5 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -6,6 +6,7 @@ obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o feature_names.o
 
 obj-$(CONFIG_X86_32)	+= common.o bugs.o
+obj-$(CONFIG_X86_64)	+= bugs_64.o
 obj-$(CONFIG_X86_32)	+= amd.o
 obj-$(CONFIG_X86_64)	+= amd_64.o
 obj-$(CONFIG_X86_32)	+= cyrix.o
diff --git a/arch/x86/kernel/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
similarity index 100%
rename from arch/x86/kernel/bugs_64.c
rename to arch/x86/kernel/cpu/bugs_64.c
-- 
1.5.4.1

