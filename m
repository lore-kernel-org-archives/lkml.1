Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZCSUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZCSUCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZCSUCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:02:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44532 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZCSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:02:04 -0400
Message-Id: <20090319200122.512803803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 16:01:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/7] [GIT PULL] tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Lai Jiangshan (1):
      ftrace: protect running nmi (V3)

Steven Rostedt (6):
      tracing: give easy way to clear trace buffer
      function-graph: consolidate prologues for output
      tracing: make print_(b)printk_msg_only global
      function-graph: calculate function depth within function graph tracer
      tracing: remove recording function depth from trace_printk
      function-graph: show binary events as comments

----
 arch/x86/kernel/ftrace.c             |   63 ++++++----
 kernel/trace/trace.c                 |   85 ++++++-------
 kernel/trace/trace.h                 |    6 +-
 kernel/trace/trace_event_types.h     |    2 -
 kernel/trace/trace_functions_graph.c |  219 +++++++++++++++++++---------------
 kernel/trace/trace_mmiotrace.c       |    2 +-
 kernel/trace/trace_output.c          |   32 +++++
 kernel/trace/trace_output.h          |    5 +
 kernel/trace/trace_printk.c          |    8 +-
 9 files changed, 243 insertions(+), 179 deletions(-)
-- 
