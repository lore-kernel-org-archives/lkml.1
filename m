Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbZDBFff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbZDBFff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZDBFfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:35:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43710 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZDBFfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:35:24 -0400
Message-Id: <20090402052721.013878388@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 01:27:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL] for tip/tracing/filters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/filters tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/filters


Steven Rostedt (2):
      ring-buffer: add ring_buffer_discard_commit
      tracing/filters: use ring_buffer_discard_commit for discarded events

Tom Zanussi (2):
      tracing/filters: add run-time field descriptions to TRACE_EVENT_FORMAT events
      tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event macro

----
 include/linux/ring_buffer.h         |   29 ++++++++
 kernel/trace/kmemtrace.c            |    6 ++
 kernel/trace/ring_buffer.c          |  125 +++++++++++++++++++++++++++++------
 kernel/trace/trace.c                |   32 ++++++++-
 kernel/trace/trace.h                |   23 +++++++
 kernel/trace/trace_branch.c         |    3 +
 kernel/trace/trace_event_types.h    |    8 ++-
 kernel/trace/trace_events.c         |    7 ++
 kernel/trace/trace_events_filter.c  |    4 +-
 kernel/trace/trace_events_stage_2.h |    7 --
 kernel/trace/trace_events_stage_3.h |    6 +-
 kernel/trace/trace_export.c         |   90 ++++++++++++++++++++++++-
 kernel/trace/trace_hw_branches.c    |    2 +
 kernel/trace/trace_power.c          |    4 +
 14 files changed, 305 insertions(+), 41 deletions(-)
-- 
-- 
