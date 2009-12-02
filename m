Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZLBKqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZLBKqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZLBKql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:46:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:33590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbZLBKqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:46:39 -0500
Date: Wed, 2 Dec 2009 10:44:39 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mahesh@linux.vnet.ibm.com, wenji.huang@oracle.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       roland@redhat.com, oleg@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mahesh@linux.vnet.ibm.com, wenji.huang@oracle.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       roland@redhat.com, tglx@linutronix.de, oleg@redhat.com,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20091201000222.7669.7477.stgit@harusame>
References: <20091201000222.7669.7477.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Fix comments of register/stack access functions
Message-ID: <tip-e859cf8656043f158b4004ccc8cbbf1ba4f97177@git.kernel.org>
Git-Commit-ID: e859cf8656043f158b4004ccc8cbbf1ba4f97177
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e859cf8656043f158b4004ccc8cbbf1ba4f97177
Gitweb:     http://git.kernel.org/tip/e859cf8656043f158b4004ccc8cbbf1ba4f97177
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 30 Nov 2009 19:02:22 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:22:22 +0100

x86: Fix comments of register/stack access functions

Fix typos and some redundant comments of register/stack access
functions in asm/ptrace.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Wenji Huang <wenji.huang@oracle.com>
Cc: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
LKML-Reference: <20091201000222.7669.7477.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Suggested-by: Wenji Huang <wenji.huang@oracle.com>
---
 arch/x86/include/asm/ptrace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index a3d49dd..3d11fd0 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -227,8 +227,8 @@ extern const char *regs_query_register_name(unsigned int offset);
  * @regs:	pt_regs from which register value is gotten.
  * @offset:	offset number of the register.
  *
- * regs_get_register returns the value of a register whose offset from @regs
- * is @offset. The @offset is the offset of the register in struct pt_regs.
+ * regs_get_register returns the value of a register. The @offset is the
+ * offset of the register in struct pt_regs address which specified by @regs.
  * If @offset is bigger than MAX_REG_OFFSET, this returns 0.
  */
 static inline unsigned long regs_get_register(struct pt_regs *regs,
@@ -244,7 +244,7 @@ static inline unsigned long regs_get_register(struct pt_regs *regs,
  * @regs:	pt_regs which contains kernel stack pointer.
  * @addr:	address which is checked.
  *
- * regs_within_kenel_stack() checks @addr is within the kernel stack page(s).
+ * regs_within_kernel_stack() checks @addr is within the kernel stack page(s).
  * If @addr is within the kernel stack, it returns true. If not, returns false.
  */
 static inline int regs_within_kernel_stack(struct pt_regs *regs,
@@ -260,7 +260,7 @@ static inline int regs_within_kernel_stack(struct pt_regs *regs,
  * @n:		stack entry number.
  *
  * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
- * is specifined by @regs. If the @n th entry is NOT in the kernel stack,
+ * is specified by @regs. If the @n th entry is NOT in the kernel stack,
  * this returns 0.
  */
 static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
