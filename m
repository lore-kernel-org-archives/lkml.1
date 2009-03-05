Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZCED11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZCED11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZCED1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40181 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZCED1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:15 -0500
Message-Id: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/7] [GIT PULL] for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (7):
      ring-buffer: fix timestamp in partial ring_buffer_page_read
      tracing: do not return EFAULT if read copied anything
      tracing: fix seq read from trace files
      tracing: add latency output format option
      tracing: remove extra latency_trace method from trace structure
      tracing: consolidate print_lat_fmt and print_trace_fmt
      tracing: have latency tracers set the latency format

----
 kernel/trace/blktrace.c           |    1 -
 kernel/trace/ring_buffer.c        |    6 ++-
 kernel/trace/trace.c              |   81 ++++++++++--------------------------
 kernel/trace/trace.h              |    3 +-
 kernel/trace/trace_branch.c       |    1 -
 kernel/trace/trace_irqsoff.c      |    8 ++++
 kernel/trace/trace_output.c       |   32 --------------
 kernel/trace/trace_output.h       |    1 -
 kernel/trace/trace_sched_wakeup.c |    8 ++++
 9 files changed, 46 insertions(+), 95 deletions(-)
-- 
