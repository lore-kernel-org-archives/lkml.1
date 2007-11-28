Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbXK1FJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbXK1FJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXK1FJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:09:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXK1FJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:09:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] x86: eflags enum
In-Reply-To: Roland McGrath's message of  Tuesday, 27 November 2007 21:07:45 -0800 <20071128050745.357E826F8E7@magilla.localdomain>
References: <20071128050745.357E826F8E7@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071128050912.7F31126F8E7@magilla.localdomain>
Date: Tue, 27 Nov 2007 21:09:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes the EF_* enum from <asm/ptrace.h>.  It is no longer used,
and duplicates the X86_EFLAGS_* constants from <asm/processor-flags.h>.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-x86/ptrace.h |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 04204f3..5d73bfc 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -116,28 +116,6 @@ extern int ptrace_set_debugreg(struct task_struct *child, int n, unsigned long);
 extern unsigned long
 convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
-enum {
-	EF_CF   = 0x00000001,
-	EF_PF   = 0x00000004,
-	EF_AF   = 0x00000010,
-	EF_ZF   = 0x00000040,
-	EF_SF   = 0x00000080,
-	EF_TF   = 0x00000100,
-	EF_IE   = 0x00000200,
-	EF_DF   = 0x00000400,
-	EF_OF   = 0x00000800,
-	EF_IOPL = 0x00003000,
-	EF_IOPL_RING0 = 0x00000000,
-	EF_IOPL_RING1 = 0x00001000,
-	EF_IOPL_RING2 = 0x00002000,
-	EF_NT   = 0x00004000,   /* nested task */
-	EF_RF   = 0x00010000,   /* resume */
-	EF_VM   = 0x00020000,   /* virtual mode */
-	EF_AC   = 0x00040000,   /* alignment */
-	EF_VIF  = 0x00080000,   /* virtual interrupt */
-	EF_VIP  = 0x00100000,   /* virtual interrupt pending */
-	EF_ID   = 0x00200000,   /* id */
-};
 #endif /* __KERNEL__ */
 #endif /* !__i386__ */
 
