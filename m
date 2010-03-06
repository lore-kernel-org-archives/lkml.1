Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0CFCWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 21:22:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0CFCWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 21:22:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=vpcBPqZSyogA:10 a=VwQbUJbxAAAA:8 a=Og6RQVrphs0t1ay90HMA:9 a=94lbaSumNrp7hBCRFEd3k3gbMYIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100306022140.320536991@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Mar 2010 21:21:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4][GIT PULL] tracing: updates and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Arnaldo Carvalho de Melo (1):
      tracing: Update the comm field in the right variable in update_max_tr

Steven Rostedt (2):
      function-graph: Fix unused reference to ftrace_set_func()
      function-graph: Use comment notation for func names of dangling '}'

Tim Bird (1):
      function-graph: Add tracing_thresh support to function_graph tracer

----
 kernel/trace/ftrace.c                |    6 ++----
 kernel/trace/trace.c                 |   24 ++++++++++++++++++++----
 kernel/trace/trace.h                 |    3 ++-
 kernel/trace/trace_functions_graph.c |   27 ++++++++++++++++++++++++---
 4 files changed, 48 insertions(+), 12 deletions(-)

