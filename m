Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZDXEbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZDXEbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZDXEbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:31:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZDXEbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:31:11 -0400
Message-Id: <20090424043005.338878133@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 24 Apr 2009 00:30:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] [GIT PULL] x86,ring_buffer,tracing: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Chris Wright (1):
      x86: use native register access for native tlb flushing

Lai Jiangshan (1):
      ring_buffer: compressed event header

Steven Rostedt (4):
      tracing/wakeup: move access to wakeup_cpu into spinlock
      tracing: increase size of number of possible events
      tracing: add size checks for exported ftrace internal structures
      tracing: fix cut and paste macro error

----
 arch/x86/include/asm/tlbflush.h   |    8 ++--
 include/linux/ftrace_event.h      |    5 ++-
 include/linux/ring_buffer.h       |   16 ++++---
 include/trace/define_trace.h      |    8 ++--
 kernel/trace/ring_buffer.c        |   83 ++++++++++++++++++-------------------
 kernel/trace/trace_events.c       |    5 ++-
 kernel/trace/trace_export.c       |    4 ++
 kernel/trace/trace_output.c       |    2 +
 kernel/trace/trace_sched_wakeup.c |    6 +-
 9 files changed, 75 insertions(+), 62 deletions(-)
-- 
