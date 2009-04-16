Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZDPCTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZDPCTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZDPCT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:19:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDPCT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:19:29 -0400
Message-Id: <20090416021830.556671772@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 15 Apr 2009 22:18:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Avadh Patel (1):
      tracing: add saved_cmdlines file to show cached task comms

Steven Rostedt (4):
      ftrace: use module notifier for function tracer
      tracing/events: add startup tests for events
      tracing/events: add rcu locking around trace event prints
      tracing/events/ring-buffer: expose format of ring buffer headers to users

----
 include/linux/ftrace.h      |    7 --
 include/linux/module.h      |    4 +
 include/linux/ring_buffer.h |    5 +
 include/trace/ftrace.h      |    4 +
 kernel/module.c             |   19 ++---
 kernel/trace/ftrace.c       |   90 +++++++++++++-----
 kernel/trace/ring_buffer.c  |   44 +++++++++
 kernel/trace/trace.c        |   53 +++++++++++
 kernel/trace/trace_events.c |  214 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 395 insertions(+), 45 deletions(-)
-- 
