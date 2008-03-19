Return-Path: <linux-kernel-owner+w=401wt.eu-S1162499AbYCSWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162499AbYCSWtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965798AbYCSVSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:18:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965793AbYCSVSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:18:51 -0400
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
Subject: [PATCH 2/8] alpha ptrace: forced_successful_syscall_return()
In-Reply-To: Roland McGrath's message of  Wednesday, 19 March 2008 14:17:14 -0700 <20080319211714.8B14226F995@magilla.localdomain>
References: <20080319211714.8B14226F995@magilla.localdomain>
X-Zippy-Says: I'm mentally OVERDRAWN!  What's that SIGNPOST up ahead?  Where's
    ROD STERLING when you really need him?
Message-Id: <20080319211841.253E126F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:18:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the forced_successful_syscall_return() macro to
pair with our force_successful_syscall_return() definition.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-alpha/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-alpha/ptrace.h b/include/asm-alpha/ptrace.h
index 32c7a5c..1cc330b 100644
--- a/include/asm-alpha/ptrace.h
+++ b/include/asm-alpha/ptrace.h
@@ -77,6 +77,7 @@ extern void show_regs(struct pt_regs *);
   ((struct pt_regs *) (task_stack_page(task) + 2*PAGE_SIZE) - 1)
 
 #define force_successful_syscall_return() (task_pt_regs(current)->r0 = 0)
+#define forced_successful_syscall_return() (task_pt_regs(current)->r0 == 0)
 
 #endif
 
