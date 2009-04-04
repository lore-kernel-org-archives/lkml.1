Return-Path: <linux-kernel-owner+w=401wt.eu-S937375AbZDDAbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937375AbZDDAbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936627AbZDDA2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936630AbZDDA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:11 -0400
Message-Id: <20090404002703.627460459@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 20:27:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/10] [GIT PULL] updates for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Frederic Weisbecker (2):
      tracing/ftrace: fix missing include string.h
      tracing/ftrace: factorize the tracing files creation

Huang Weiyi (1):
      tracing, x86: remove duplicated #include

Lai Jiangshan (1):
      tracing: fix incorrect return type of ns2usecs() V2

Li Zefan (1):
      tracing: use macros to denote usec and nsec per second

Steven Rostedt (3):
      tracing: remove CALLER_ADDR2 from wakeup tracer
      function-graph: add proper initialization for init task
      function-graph: use int instead of atomic for ftrace_graph_active

Zhaolei (2):
      ftrace: Add check of sched_stopped for probe_sched_wakeup
      ftrace: Clean up enable logic for sched_switch

----
 arch/x86/kernel/ftrace.c           |    1 -
 include/linux/ftrace.h             |    8 ++-
 include/linux/init_task.h          |    2 +
 kernel/trace/ftrace.c              |   59 +++++---------
 kernel/trace/ring_buffer.c         |    7 +-
 kernel/trace/trace.c               |  163 ++++++++++++++----------------------
 kernel/trace/trace.h               |    8 ++-
 kernel/trace/trace_boot.c          |    5 +-
 kernel/trace/trace_event_profile.c |    3 +-
 kernel/trace/trace_mmiotrace.c     |    6 +-
 kernel/trace/trace_output.c        |    2 +-
 kernel/trace/trace_printk.c        |    6 +-
 kernel/trace/trace_sched_switch.c  |   11 ++-
 kernel/trace/trace_sched_wakeup.c  |    8 ++-
 kernel/trace/trace_stack.c         |   13 +--
 kernel/trace/trace_sysprof.c       |    6 +-
 16 files changed, 131 insertions(+), 177 deletions(-)
-- 
