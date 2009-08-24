Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZHXVoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZHXVoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZHXVn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbZHXVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:43:57 -0400
Date: Mon, 24 Aug 2009 17:40:26 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: lethal@linux-sh.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Message-Id: <f2240cdc8f0b1ca7617390c8f5ec90ba2bd348cf.1251146513.git.jbaron@redhat.com>
In-Reply-To: <cover.1251146512.git.jbaron@redhat.com>
References: <cover.1251146512.git.jbaron@redhat.com>
Subject: [PATCH 4/4] remove FTRACE_SYSCALL_MAX definitions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the FTRACE_SYSCALL_MAX definitions now that we have converted the
syscall event tracing code to use NR_syscalls.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 arch/x86/include/asm/ftrace.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 7113654..db24c22 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -28,13 +28,6 @@
 
 #endif
 
-/* FIXME: I don't want to stay hardcoded */
-#ifdef CONFIG_X86_64
-# define FTRACE_SYSCALL_MAX     299
-#else
-# define FTRACE_SYSCALL_MAX     337
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
-- 
1.6.2.5

