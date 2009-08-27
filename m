Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbZH0RoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbZH0RoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZH0Rn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:43:59 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51769 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZH0Rny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uzr4w4WDqNpoUCjzvFtiV0Spj0cvMlMOf3CztKF+c4pjGm2k4Y8Thqk4eeXTBPEZRv
         V8f4ttzLDTP0vErRHtHFb2NOMIUbSf5tjuPVUjDsLWLsVwxzK3HoXhTmKQxf6GGoXtff
         Lq7Wve+mNvwRdk8gJLh1fMbkMkvq+8vFfsLuY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Josh Stone <jistone@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anwin" <hpa@zytor.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 7/7] tracing: Remove FTRACE_SYSCALL_MAX definitions
Date: Thu, 27 Aug 2009 19:43:35 +0200
Message-Id: <1251395015-6329-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Remove the FTRACE_SYSCALL_MAX definitions now that we have converted the
syscall event tracing code to use NR_syscalls.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <f2240cdc8f0b1ca7617390c8f5ec90ba2bd348cf.1251146513.git.jbaron@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.2.3

