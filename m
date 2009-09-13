Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZIMBuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZIMBuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 21:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZIMBuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 21:50:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbZIMBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 21:50:21 -0400
Message-Id: <20090913014906.407896305@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 21:49:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Carsten Emde <Carsten.Emde@osadl.org>
Subject: [PATCH 0/3] [GIT PULL] tracing: fixes for 2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Carsten Emde (3):
      tracing: prevent NULL pointer dereference in ftrace_raw_event_block_bio_bounce
      tracing: remove unused local variables in tracer probe functions
      tracing: do not update tracing_max_latency when tracer is stopped

----
 include/trace/events/block.h      |    4 +++-
 kernel/trace/trace.c              |    5 +++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |   16 ++++------------
 kernel/trace/trace_sched_wakeup.c |   16 ++++------------
 5 files changed, 17 insertions(+), 25 deletions(-)
-- 
