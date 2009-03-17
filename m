Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbZCQDtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbZCQDtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZCQDtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:49:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZCQDtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:49:31 -0400
Message-Id: <20090317034820.400357912@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 23:48:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] update for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Frederic Weisbecker (1):
      tracing/ftrace: fix the check on nopped sites

Steven Rostedt (2):
      tracing: protect reader of cmdline output
      tracing: stop comm recording on tracing off

----
 kernel/trace/blktrace.c              |   23 ++++++++++++++++++-----
 kernel/trace/ftrace.c                |    2 +-
 kernel/trace/trace.c                 |   22 +++++++++++++---------
 kernel/trace/trace.h                 |    2 +-
 kernel/trace/trace_functions_graph.c |   12 ++++++------
 kernel/trace/trace_output.c          |   18 ++++++++++++------
 6 files changed, 51 insertions(+), 28 deletions(-)
-- 
