Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbXCNFOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbXCNFOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933847AbXCNFMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:40 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:48695 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933845AbXCNFMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:12 -0400
Message-Id: <20070314051048.747878250@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 07/18] mv kernel/cpu/cpufreq/speedstep-lib.c
Content-Disposition: inline; filename=cpu-freq-mv-speedstep-lib.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move kernel/cpu/cpufreq/speedstep-lib.c to the common hold.

Also has the slight change to reference speedstep-lib.h that is being moved
to include/asm-i386.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/speedstep-lib.c
rename to arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
index d59277c..ff4482b 100644
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 
 #include <asm/msr.h>
-#include "speedstep-lib.h"
+#include <asm-i386/speedstep-lib.h>
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-lib", msg)
 

--
