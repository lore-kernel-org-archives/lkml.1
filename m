Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYISMxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYISMxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYISMw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:52:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:35642 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbYISMw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,429,1217833200"; 
   d="scan'208";a="338203469"
Date: Fri, 19 Sep 2008 14:52:50 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: mingo@elte.hu
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch] x86, ptrace: void dopiness
Message-ID: <20080919145250.A6000@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove void cast to explicitly ignore the return value.


Signed-off-by: markus.t.metzger@intel.com

---
Index: gits.x86/arch/x86/kernel/ptrace.c
===================================================================
--- gits.x86.orig/arch/x86/kernel/ptrace.c	2008-06-30 13:21:07.%N +0200
+++ gits.x86/arch/x86/kernel/ptrace.c	2008-09-19 13:53:02.%N +0200
@@ -738,7 +738,7 @@
 		unsigned int sig = 0;
 
 		/* we ignore the error in case we were not tracing child */
-		(void)ds_release_bts(child);
+		ds_release_bts(child);
 
 		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
 			if (!cfg.signal)
@@ -947,7 +947,7 @@
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
 #ifdef CONFIG_X86_PTRACE_BTS
-	(void)ds_release_bts(child);
+	ds_release_bts(child);
 
 	child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
 	if (!child->thread.debugctlmsr)
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

