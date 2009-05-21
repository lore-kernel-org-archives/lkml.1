Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZEUOTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZEUOTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZEUOTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:19:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49542 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZEUOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:19:14 -0400
Message-Id: <20090521141813.123165156@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 21 May 2009 10:18:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing/events: show task comms
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is on top of the changes that I posted yesterday (ftrace-1), but
in its own branch.

Please pull the latest tip/tracing/ftrace-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-2


Zhaolei (2):
      ftrace: Add task_comm support for trace_event
      ftrace: clean up of using ftrace_event_enable_disable()

----
 kernel/trace/trace_events.c |   42 ++++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 26 deletions(-)
-- 
