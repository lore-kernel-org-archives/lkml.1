Return-Path: <linux-kernel-owner+w=401wt.eu-S934513AbZKYEjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513AbZKYEjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 23:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934500AbZKYEjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 23:39:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739AbZKYEjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 23:39:06 -0500
Message-Id: <20091125043811.603607335@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 Nov 2009 23:38:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/3] [GIT PULL] tracing: rebase of TRACE_EVENT_TEMPLATE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is the rebase to resolve the conflicts with perf.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (3):
      tracing: Create new TRACE_EVENT_TEMPLATE
      tracing: Create new DEFINE_EVENT_PRINT
      tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT

----
 include/linux/tracepoint.h   |    6 +
 include/trace/define_trace.h |   11 ++
 include/trace/events/sched.h |  170 ++++++++-------------------
 include/trace/ftrace.h       |  266 +++++++++++++++++++++++++++++++++++-------
 4 files changed, 292 insertions(+), 161 deletions(-)

