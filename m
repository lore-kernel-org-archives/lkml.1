Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZBYC6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZBYC6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbZBYC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:57:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZBYC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:57:56 -0500
Message-Id: <20090225025608.956691460@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Feb 2009 21:56:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/4] [git pull] tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Updates since the RFC:

 - Renamed DECLARE_TRACE_FMT to DEFINE_TRACE_FMT as commented by
   Andrew Morton.

 - Used TPFMT macro as suggested by Peter Zijlstra

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (4):
      tracing: add DEFINE_TRACE_FMT to tracepoint.h
      tracing: add event trace infrastructure
      tracing: add schedule events to event trace
      tracing: make event directory structure

----
 include/asm-generic/vmlinux.lds.h |   11 +-
 include/linux/tracepoint.h        |    3 +
 include/trace/sched.h             |   49 +-----
 include/trace/sched_event_types.h |   72 +++++++
 kernel/trace/Kconfig              |    9 +
 kernel/trace/Makefile             |    2 +
 kernel/trace/events.c             |   13 ++
 kernel/trace/trace_events.c       |  407 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.h       |   55 +++++
 9 files changed, 572 insertions(+), 49 deletions(-)

-- 
