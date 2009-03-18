Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZCRDdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZCRDdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZCRDcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:32:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZCRDcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:32:51 -0400
Message-Id: <20090318031423.981603258@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 23:14:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (4):
      ring-buffer: add api to allow a tracer to change clock source
      tracing: add global-clock option to provide cross CPU clock to traces
      tracing: make sched_switch stop/start light weight
      tracing: make power tracer start/stop methods lighter weight

Witold Baryluk (1):
      tracing: optimization of branch tracer

----
 include/linux/compiler.h          |    6 +--
 include/linux/ring_buffer.h       |    7 +++-
 kernel/trace/ring_buffer.c        |   65 +++++++++++++++++++++---------------
 kernel/trace/trace.c              |   55 +++++++++++++++++++++++++------
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_power.c        |    8 +++-
 kernel/trace/trace_sched_switch.c |    9 +++--
 7 files changed, 101 insertions(+), 50 deletions(-)
-- 
