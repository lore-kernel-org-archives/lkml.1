Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZFWSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZFWSbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZFWSbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:31:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38030 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZFWSbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:31:00 -0400
Date: Tue, 23 Jun 2009 14:29:10 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com, lizf@cn.fujitsu.com
Message-Id: <4ad00d330cce7b026185153913e0971a1bbb4dee.1245770664.git.jbaron@redhat.com>
In-Reply-To: <cover.1245770664.git.jbaron@redhat.com>
References: <cover.1245770664.git.jbaron@redhat.com>
Subject: [PATCH 5/7] V2 add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update FTRACE_SYSCALL_MAX to the current number of syscalls


Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

---
 arch/x86/include/asm/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index bd2c651..d16d195 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -30,9 +30,9 @@
 
 /* FIXME: I don't want to stay hardcoded */
 #ifdef CONFIG_X86_64
-# define FTRACE_SYSCALL_MAX     296
+# define FTRACE_SYSCALL_MAX     298
 #else
-# define FTRACE_SYSCALL_MAX     333
+# define FTRACE_SYSCALL_MAX     336
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
-- 
1.6.0.6

