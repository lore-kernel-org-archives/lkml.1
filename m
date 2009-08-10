Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbZHJUxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbZHJUxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZHJUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:53:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60937 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbZHJUxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:53:42 -0400
Date: Mon, 10 Aug 2009 16:52:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com>
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update FTRACE_SYSCALL_MAX to the current number of syscalls

Signed-off-by: Jason Baron <jbaron@redhat.com>

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
1.6.2.5

