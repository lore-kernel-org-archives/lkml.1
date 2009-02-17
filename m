Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZBQSVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZBQSVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZBQSV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:21:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZBQSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:27 -0500
Message-Id: <20090217182048.233060814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 13:20:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: [PATCH 0/6] [git pull] updates for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (3):
      ftrace: clean up coding style
      ftrace: rename _hook to _probe
      ftrace: show unlimited when traceon or traceoff has no counter

Wenji Huang (3):
      tracing: use the more proper parameter
      tracing: fix the return value of trace selftest
      tracing: fix typing mistake in hint message and comments

----
 include/linux/ftrace.h            |   12 ++--
 kernel/trace/ftrace.c             |  102 +++++++++++++++++++------------------
 kernel/trace/trace.c              |    2 +-
 kernel/trace/trace_functions.c    |   31 ++++++-----
 kernel/trace/trace_irqsoff.c      |    2 +-
 kernel/trace/trace_sched_switch.c |    2 +-
 kernel/trace/trace_sched_wakeup.c |    2 +-
 kernel/trace/trace_selftest.c     |   16 +++++-
 kernel/trace/trace_stat.c         |    2 +-
 kernel/trace/trace_sysprof.c      |    2 +-
 10 files changed, 93 insertions(+), 80 deletions(-)
-- 
