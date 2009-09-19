Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZISPwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZISPwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZISPwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:52:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39626 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZISPwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:52:44 -0400
Message-Id: <20090919155203.005861436@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 19 Sep 2009 11:52:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing: cleanups for 2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Li Zefan (3):
      function-graph: use ftrace_graph_funcs directly
      tracing: remove max_tracer_type_len
      tracing/events: use list_for_entry_continue

----
 kernel/trace/ftrace.c       |   23 +++----------------
 kernel/trace/trace.c        |   49 ++++++++++++++-----------------------------
 kernel/trace/trace_events.c |   49 +++++++++++++-----------------------------
 3 files changed, 35 insertions(+), 86 deletions(-)
