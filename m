Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZHZFAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZHZFAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZHZFAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZHZFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:50 -0400
Message-Id: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8] [GIT PULL] tracing: updates for 2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Josh Triplett (1):
      tracing: Add vim script to enable folding for function_graph traces

Li Zefan (3):
      tracing/filters: Add filter_type to struct ftrace_event_field
      tracing/filters: Add __field_ext() to TRACE_EVENT
      tracing/filters: Support filtering for char * strings

Steven Rostedt (2):
      tracing/sched: show CPU task wakes up on in trace event
      tracing: add comments to explain TRACE_EVENT out of protection

Xiao Guangrong (1):
      tracing/events: fix the include file dependencies

Zhaolei (1):
      ftrace: Move setting of clock-source out of options

----
 Documentation/trace/function-graph-fold.vim |   42 ++++++++++++
 include/linux/ftrace_event.h                |   10 +++-
 include/linux/tracepoint.h                  |   12 +++-
 include/trace/define_trace.h                |    1 +
 include/trace/events/sched.h                |   12 +++-
 include/trace/ftrace.h                      |   31 +++++++--
 kernel/trace/trace.c                        |   92 ++++++++++++++++++++++-----
 kernel/trace/trace.h                        |    9 ++-
 kernel/trace/trace_events.c                 |   11 +++-
 kernel/trace/trace_events_filter.c          |   47 ++++++++++----
 kernel/trace/trace_export.c                 |    8 ++-
 kernel/trace/trace_syscalls.c               |    6 +-
 12 files changed, 226 insertions(+), 55 deletions(-)

-- 
