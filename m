Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZCBUcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZCBUcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZCBUad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65513 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZCBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:27 -0500
Message-Id: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/7] [GIT PULL] trace event updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (7):
      tracing: add TRACE_FIELD_SPECIAL to record complex entries
      tracing: add protection around modify trace event fields
      tracing: make trace_seq_reset global and rename to trace_seq_init
      tracing: add format file to describe event struct fields
      tracing: add ftrace headers to event format files
      tracing: add trace name and id to event formats
      tracing: add print format to event trace format files

----
 include/trace/sched_event_types.h   |    7 ++-
 kernel/trace/trace.c                |   17 ++-----
 kernel/trace/trace.h                |    9 +++
 kernel/trace/trace_events.c         |   94 ++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_events_stage_1.h |    2 +
 kernel/trace/trace_events_stage_2.h |   58 +++++++++++++++++++++
 kernel/trace/trace_events_stage_3.h |   16 ++++++
 7 files changed, 188 insertions(+), 15 deletions(-)
-- 
