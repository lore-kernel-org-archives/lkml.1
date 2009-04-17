Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZDQVMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZDQVMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZDQVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:12:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZDQVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:32 -0400
Message-Id: <20090417211135.408179566@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 17:11:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] tracing,lockdep,x86: more updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (5):
      tracing/events: enable code with EVENT_TRACING not EVENT_TRACER
      tracing: add EXPORT_SYMBOL_GPL for trace commits
      tracing: add same level recursion detection
      tracing: protect trace_printk from recursion
      lockdep,x86: account for irqs enabled in paranoid_exit

----
 arch/x86/kernel/entry_64.S   |    3 +++
 include/linux/ftrace.h       |    7 +++++++
 include/linux/init_task.h    |    1 +
 include/linux/sched.h        |    4 +++-
 include/trace/define_trace.h |    2 +-
 kernel/trace/ring_buffer.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c         |   14 +++++++++++---
 7 files changed, 68 insertions(+), 5 deletions(-)
-- 
