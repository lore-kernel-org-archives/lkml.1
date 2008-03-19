Return-Path: <linux-kernel-owner+w=401wt.eu-S965793AbYCSWud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793AbYCSWud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965925AbYCSVTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:19:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965916AbYCSVTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:19:46 -0400
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
Subject: [PATCH 4/8] powerpc ptrace: forced_successful_syscall_return()
In-Reply-To: Roland McGrath's message of  Wednesday, 19 March 2008 14:17:14 -0700 <20080319211714.8B14226F995@magilla.localdomain>
References: <20080319211714.8B14226F995@magilla.localdomain>
X-Zippy-Says: OVER the undertow!  UNDER the overpass!  Around the FUTURE and
    BEYOND REPAIR!!
Message-Id: <20080319211936.28E8B26F9A7@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:19:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the forced_successful_syscall_return() macro to
pair with our force_successful_syscall_return() definition.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-powerpc/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-powerpc/ptrace.h b/include/asm-powerpc/ptrace.h
index 891d689..07dd6fe 100644
--- a/include/asm-powerpc/ptrace.h
+++ b/include/asm-powerpc/ptrace.h
@@ -93,6 +93,7 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 	do { \
 		set_thread_flag(TIF_NOERROR); \
 	} while(0)
+#define forced_successful_syscall_return()   (test_thread_flag(TIF_NOERROR))
 
 struct task_struct;
 extern unsigned long ptrace_get_reg(struct task_struct *task, int regno);
