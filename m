Return-Path: <linux-kernel-owner+w=401wt.eu-S1764018AbZAPEyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764018AbZAPEyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZAPEyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:54:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61532 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbZAPEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:54:20 -0500
Message-Id: <20090116045342.748642160@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 23:53:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] ftrace: more updates to tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (6):
      ftrace: move function tracer functions out of trace.c
      trace: add gcc printf check to trace_seq_printf
      trace: clean up format errors in calls to trace_seq_printf
      ftrace: combine stack trace in function call
      ftrace: remove static from function tracer functions
      trace: set max latency variable to zero on default

----
 kernel/trace/kmemtrace.c          |    4 +-
 kernel/trace/trace.c              |   89 +----------------------------
 kernel/trace/trace.h              |   10 ---
 kernel/trace/trace_functions.c    |  115 ++++++++++++++++++++++++++++++++++---
 kernel/trace/trace_irqsoff.c      |    1 +
 kernel/trace/trace_mmiotrace.c    |   13 ++--
 kernel/trace/trace_output.c       |    2 +-
 kernel/trace/trace_output.h       |    3 +-
 kernel/trace/trace_sched_wakeup.c |    1 +
 9 files changed, 122 insertions(+), 116 deletions(-)

-- 
