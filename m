Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZKSRLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZKSRLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZKSRLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:11:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZKSRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:11:01 -0500
Message-Id: <20091119171003.929771398@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 19 Nov 2009 12:10:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/4] [GIT PULL] tracing: Fix and trace event space savings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Javier Martinez Canillas (1):
      tracing: Fix strstrip usage in set_ftrace_pid

Steven Rostedt (3):
      tracing: Create new TRACE_EVENT_TEMPLATE
      tracing: Create new DEFINE_EVENT_PRINT
      tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT

----
 include/linux/tracepoint.h   |    6 +
 include/trace/define_trace.h |    8 ++
 include/trace/events/sched.h |  170 ++++++++-------------------
 include/trace/ftrace.h       |  266 +++++++++++++++++++++++++++++++++++-------
 kernel/trace/ftrace.c        |    7 +-
 5 files changed, 293 insertions(+), 164 deletions(-)
