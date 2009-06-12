Return-Path: <linux-kernel-owner+w=401wt.eu-S1765481AbZFLV2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765481AbZFLV2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764880AbZFLV1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:27:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764241AbZFLV1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:27:23 -0400
Date: Fri, 12 Jun 2009 17:24:59 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <51b4e9aff767dac4933ebb7835dee7068b158db8.1244837725.git.jbaron@redhat.com>
In-Reply-To: <cover.1244837725.git.jbaron@redhat.com>
References: <cover.1244837725.git.jbaron@redhat.com>
Subject: [PATCH 5/7] add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update FTRACE_SYSCALL_MAX to the current number of syscalls


Signed-off-by: Jason Baron <jbaron@redhat.com>

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

