Return-Path: <linux-kernel-owner+w=401wt.eu-S966979AbYCSWuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966979AbYCSWuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbYCSVT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:19:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759AbYCSVT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:19:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 3/8] ia64 ptrace: forced_successful_syscall_return()
In-Reply-To: Roland McGrath's message of  Wednesday, 19 March 2008 14:17:14 -0700 <20080319211714.8B14226F995@magilla.localdomain>
References: <20080319211714.8B14226F995@magilla.localdomain>
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20080319211914.AFE0E26F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:19:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the forced_successful_syscall_return() macro to
pair with our force_successful_syscall_return() definition.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-ia64/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-ia64/ptrace.h b/include/asm-ia64/ptrace.h
index 4b2a8d4..5e82915 100644
--- a/include/asm-ia64/ptrace.h
+++ b/include/asm-ia64/ptrace.h
@@ -276,6 +276,7 @@ struct switch_stack {
    * On ia64, we can clear the user's pt_regs->r8 to force a successful syscall.
    */
 # define force_successful_syscall_return()	(task_pt_regs(current)->r8 = 0)
+# define forced_successful_syscall_return()	(task_pt_regs(current)->r8 == 0)
 
   struct task_struct;			/* forward decl */
   struct unw_frame_info;		/* forward decl */
