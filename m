Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZB1JKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZB1JKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZB1JJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZB1JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:40 -0500
Message-Id: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net
Subject: [PATCH 00/10] [git pull] for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (10):
      tracing: move trace point formats to files in include/trace directory
      tracing: add subsystem level to trace events
      tracing: make the set_event and available_events subsystem aware
      tracing: add subsystem irq for irq events
      tracing: add subsystem sched for sched events
      tracing: add interface to write into current tracer buffer
      tracing: add raw trace point recording infrastructure
      tracing: add raw fast tracing interface for trace events
      tracing: create the C style tracing for the sched subsystem
      tracing: create the C style tracing for the irq subsystem

----
 include/linux/tracepoint.h          |    3 +
 include/trace/irq_event_types.h     |   24 +++-
 include/trace/sched_event_types.h   |  124 ++++++++++++---
 include/trace/trace_event_types.h   |    4 +
 include/trace/trace_events.h        |    4 +
 kernel/trace/events.c               |   20 ++-
 kernel/trace/trace.c                |   14 ++
 kernel/trace/trace.h                |   32 ++++
 kernel/trace/trace_events.c         |  294 +++++++++++++++++++++++++++++++----
 kernel/trace/trace_events.h         |   55 -------
 kernel/trace/trace_events_stage_1.h |   34 ++++
 kernel/trace/trace_events_stage_2.h |   72 +++++++++
 kernel/trace/trace_events_stage_3.h |  219 ++++++++++++++++++++++++++
 13 files changed, 776 insertions(+), 123 deletions(-)
-- 
