Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYKHDsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYKHDsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYKHDrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYKHDru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:50 -0500
Message-Id: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/10] ftrace: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Matt Fleming (1):
      ftrace: Align __mcount_loc sections

Steven Rostedt (9):
      ftrace: fix set_ftrace_filter
      ftrace: fix boot trace sched startup
      ftrace: fix sched_switch API
      ftrace: irqsoff tracer incorrect reset
      ftrace: enable trace_printk by default
      ftrace: remove ctrl_update method
      ftrace: remove trace array ctrl
      ftrace: force pass of preemptoff selftest
      ftrace: display start of CPU buffer in trace output

----
 kernel/trace/ftrace.c             |    3 +
 kernel/trace/trace.c              |   43 +++++++++++--------
 kernel/trace/trace.h              |    8 ++-
 kernel/trace/trace_boot.c         |   22 ++++------
 kernel/trace/trace_functions.c    |   15 +------
 kernel/trace/trace_irqsoff.c      |   19 +--------
 kernel/trace/trace_mmiotrace.c    |   22 ++++------
 kernel/trace/trace_nop.c          |   16 +------
 kernel/trace/trace_sched_switch.c |   77 ++++++++++++++++++++++++----------
 kernel/trace/trace_sched_wakeup.c |   21 ++--------
 kernel/trace/trace_selftest.c     |   82 +++++++++++++++++++++++-------------
 kernel/trace/trace_sysprof.c      |   16 +------
 scripts/recordmcount.pl           |    4 ++
 13 files changed, 172 insertions(+), 176 deletions(-)
