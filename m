Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZHKStX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZHKStX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbZHKStV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:21 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42538 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbZHKStS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BW6GF6PVMLYnpizsvN7NNY0erdTl89pQz9d1iuXQxRa0Rg2bo4b6usKZb+nJ97YgSY
         9aqw5Qvylu+1GQ3WRHLoZDPs1X57R276DrNso+3n6JJKzUE2eTTlii37zfLifkvRbaZX
         5WwG5K6eDeYptt9TOX0/jp19OVY393sLpsWKU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/16] tracing: Update FTRACE_SYSCALL_MAX
Date: Tue, 11 Aug 2009 20:48:55 +0200
Message-Id: <1250016545-6601-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

update FTRACE_SYSCALL_MAX to the current number of syscalls

FTRACE_SYSCALL_MAX is a temporary solution to get the number of
syscalls supported by the arch until we find a more dynamic way
to get this number.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index bd2c651..7113654 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -30,9 +30,9 @@
 
 /* FIXME: I don't want to stay hardcoded */
 #ifdef CONFIG_X86_64
-# define FTRACE_SYSCALL_MAX     296
+# define FTRACE_SYSCALL_MAX     299
 #else
-# define FTRACE_SYSCALL_MAX     333
+# define FTRACE_SYSCALL_MAX     337
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
-- 
1.6.2.3

