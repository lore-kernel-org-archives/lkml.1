Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbXFAOfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbXFAOfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbXFAOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:35:09 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:60548 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759480AbXFAOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:35:07 -0400
Date: Fri, 1 Jun 2007 07:34:29 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: Stephane Eranian <eranian@hpl.hp.com>, ak@suse.de,
       akpm@linux-foundation.org
Subject: [PATCH] i386 add cpu_has_arch_perfmon macro
Message-ID: <20070601143429.GH24898@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following patch for i386 adds a macro to test for X86_FEATURE_ARCH_PERFMON.
An equivalent patch will follow for x86-64.

changelog:
	- add cpu_has_arch_perfmon macro to test for X86_FEATURE_ARCH_PERFMON

signed-off-by: stephane eranian <eranian@hpl.hp.com>

diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-i386/cpufeature.h linux-2.6.22.base/include/asm-i386/cpufeature.h
--- linux-2.6.22.orig/include/asm-i386/cpufeature.h	2007-05-30 04:02:26.000000000 -0700
+++ linux-2.6.22.base/include/asm-i386/cpufeature.h	2007-06-01 07:22:25.000000000 -0700
@@ -150,6 +150,7 @@
 #define cpu_has_pebs 		boot_cpu_has(X86_FEATURE_PEBS)
 #define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
 #define cpu_has_bts 		boot_cpu_has(X86_FEATURE_BTS)
+#define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 
 #endif /* __ASM_I386_CPUFEATURE_H */
 
-- 

-Stephane
