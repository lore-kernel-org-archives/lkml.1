Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbZDQOnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbZDQOnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761034AbZDQOnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:43:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbZDQOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:43:32 -0400
Message-Id: <20090417144055.857407604@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 10:40:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/5] [GIT PULL] ftrace,tracing/events rebase updates.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I have already sent these patches once to you. This version updates the
change logs to put the impact lines at the end. It also folds in
you delay.h missing header fix, and adds my fix to the event tests.
The two updates are both done to tracing/events: add startup tests for events

The rest of the patches should be identical.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Avadh Patel (1):
      tracing: add saved_cmdlines file to show cached task comms

Steven Rostedt (4):
      ftrace: use module notifier for function tracer
      tracing/events: add startup tests for events
      tracing/events/ring-buffer: expose format of ring buffer headers to users
      tracing/events: perform function tracing in event selftests

----
 include/linux/ftrace.h      |    7 -
 include/linux/module.h      |    4 +
 include/linux/ring_buffer.h |    5 +
 kernel/module.c             |   19 +--
 kernel/trace/ftrace.c       |   90 ++++++++++----
 kernel/trace/ring_buffer.c  |   44 +++++++
 kernel/trace/trace.c        |   53 ++++++++
 kernel/trace/trace_events.c |  282 +++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 459 insertions(+), 45 deletions(-)
-- 
