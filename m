Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZIKTcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZIKTcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbZIKTcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:32:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbZIKTcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:32:32 -0400
Message-Id: <20090911193153.444303577@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:31:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] [GIT PULL] tracing: more updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core3


Steven Rostedt (3):
      tracing: move tgid out of generic entry and into userstack
      tracing: add lock depth to entries
      tracing: consolidate code between trace_output.c and trace_function_graph.c

jolsa@redhat.com (3):
      tracing: create generic trace parser
      tracing: trace parser support for set_event
      tracing: trace parser support for function and graph

----
 include/linux/ftrace_event.h         |    2 +-
 kernel/trace/ftrace.c                |  150 +++++++++-------------------------
 kernel/trace/trace.c                 |  117 +++++++++++++++++++++++++-
 kernel/trace/trace.h                 |   36 ++++++++
 kernel/trace/trace_events.c          |   64 ++++-----------
 kernel/trace/trace_functions_graph.c |   26 ++-----
 kernel/trace/trace_output.c          |   42 ++++++++--
 kernel/trace/trace_output.h          |    2 +
 8 files changed, 246 insertions(+), 193 deletions(-)
-- 
