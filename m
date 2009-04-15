Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZDODQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZDODQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZDODQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:16:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZDODQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:16:07 -0400
Message-Id: <20090415031511.128139334@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 23:15:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 0/4] [GIT PULL] more updates for TRACE_EVENTS for modules
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (4):
      tracing/events: fix compile for modules disabled
      tracing/events: fix lockdep system name
      tracing/events: move trace point headers into include/trace/events
      tracing/events: add trace-events-sample

----
 include/linux/kmemtrace.h                  |    2 +-
 include/trace/define_trace.h               |    2 +-
 include/trace/events/irq.h                 |   57 +++++
 include/trace/events/kmem.h                |  194 ++++++++++++++++
 include/trace/events/lockdep.h             |   60 +++++
 include/trace/events/sched.h               |  339 ++++++++++++++++++++++++++++
 include/trace/events/skb.h                 |   40 ++++
 include/trace/irq.h                        |   57 -----
 include/trace/kmem.h                       |  194 ----------------
 include/trace/lockdep.h                    |   60 -----
 include/trace/sched.h                      |  339 ----------------------------
 include/trace/skb.h                        |   40 ----
 kernel/exit.c                              |    2 +-
 kernel/fork.c                              |    3 +-
 kernel/irq/handle.c                        |    2 +-
 kernel/kthread.c                           |    2 +-
 kernel/lockdep.c                           |    2 +-
 kernel/sched.c                             |    2 +-
 kernel/signal.c                            |    2 +-
 kernel/softirq.c                           |    2 +-
 kernel/trace/ftrace.c                      |    2 +-
 kernel/trace/trace_events.c                |   12 +-
 kernel/trace/trace_sched_switch.c          |    2 +-
 kernel/trace/trace_sched_wakeup.c          |    2 +-
 mm/util.c                                  |    2 +-
 net/core/drop_monitor.c                    |    2 +-
 net/core/net-traces.c                      |    2 +-
 net/core/skbuff.c                          |    2 +-
 samples/Kconfig                            |    7 +
 samples/Makefile                           |    2 +-
 samples/trace_events/Makefile              |    8 +
 samples/trace_events/trace-events-sample.c |   56 +++++
 samples/trace_events/trace-events-sample.h |  124 ++++++++++
 33 files changed, 914 insertions(+), 710 deletions(-)
-- 
