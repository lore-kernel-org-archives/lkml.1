Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZCXN4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZCXN4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZCXN4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:56:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50162 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZCXN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:56:12 -0400
Message-Id: <20090324135422.026619569@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 09:54:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] updates for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased off of your latest tree. I'm still making some updates to the
function profiler. In doing so, I came across some changes that need to
be made in the function graph tracer. To keep those changes separate
from the function profiler, I'm posting these first.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (3):
      function-graph: moved the timestamp from arch to generic code
      function-graph: prevent more than one tracer registering
      function-graph: ignore times across schedule

----
 arch/x86/kernel/ftrace.c             |    6 +----
 include/linux/ftrace.h               |    3 +-
 include/linux/sched.h                |    2 +
 kernel/trace/ftrace.c                |   42 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace_functions_graph.c |    8 ++++--
 5 files changed, 51 insertions(+), 10 deletions(-)
-- 
