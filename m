Return-Path: <linux-kernel-owner+w=401wt.eu-S933849AbXCNFOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbXCNFOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933847AbXCNFOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:14:11 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:48938 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933870AbXCNFMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:45 -0400
Message-Id: <20070314051048.391547801@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 05/18] mv kernel/cpu/cpufreq/p4-clockmod.c
Content-Disposition: inline; filename=cpu-freq-mv-p4-clockmod.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move kernel/cpu/cpufreq/p4-clockmod.c to the common hold.

Also has the slight change to reference speedstep-lib.h that is being moved
to include/asm-i386.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>


diff --git a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
similarity index 100%
rename from arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
rename to arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 4786fed..ac5d5a1 100644
--- a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -33,7 +33,7 @@
 #include <asm/msr.h>
 #include <asm/timex.h>
 
-#include "speedstep-lib.h"
+#include <asm-i386/speedstep-lib.h>
 
 #define PFX	"p4-clockmod: "
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "p4-clockmod", msg)

--
