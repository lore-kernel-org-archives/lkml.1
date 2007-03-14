Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbXCNFP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbXCNFP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbXCNFMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:38 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:51756 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847AbXCNFMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:13 -0400
Message-Id: <20070314051048.919247301@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 08/18] create x86/kernel/cpu/Makefile
Content-Disposition: inline; filename=cpu-makefile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create the Makefile in the common hold and adjust the i386 and
x86_64 code accordingly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
new file mode 100644
index 0000000..bf4ae59
--- /dev/null
+++ b/arch/x86/kernel/cpu/Makefile
@@ -0,0 +1,5 @@
+
+obj-$(CONFIG_MTRR)	+= 	mtrr/
+obj-y				+= intel_cacheinfo.o
+obj-$(CONFIG_X86_MCE)	+=	mcheck/
+obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/
diff --git a/arch/i386/kernel/cpu/Makefile b/arch/i386/kernel/cpu/Makefile
index 010aecf..e484d74 100644
--- a/arch/i386/kernel/cpu/Makefile
+++ b/arch/i386/kernel/cpu/Makefile
@@ -8,12 +8,11 @@ obj-y	+=	amd.o
 obj-y	+=	cyrix.o
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
-obj-y	+=	intel.o intel_cacheinfo.o
+obj-y	+=	intel.o
 obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
 
 obj-$(CONFIG_X86_MCE)	+=	mcheck/
 
-obj-$(CONFIG_MTRR)	+= 	mtrr/
 obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/

--
