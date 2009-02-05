Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZBEGPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZBEGPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZBEGOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:14:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZBEGON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:14:13 -0500
Message-Id: <20090205061335.917484162@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Feb 2009 01:13:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Arnaldo was nice enough to do something that was on my todo list
for quite some time.

I also included the change you asked for.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Arnaldo Carvalho de Melo (2):
      trace_branch: Remove unused function
      trace: Remove unused trace_array_cpu parameter

Steven Rostedt (1):
      trace: code style clean up

----
 block/blktrace.c                  |    2 +-
 kernel/trace/trace.c              |   76 ++++++++++++++++---------------------
 kernel/trace/trace.h              |    4 --
 kernel/trace/trace_branch.c       |   17 --------
 kernel/trace/trace_functions.c    |    8 ++--
 kernel/trace/trace_irqsoff.c      |   10 ++--
 kernel/trace/trace_sched_switch.c |    4 +-
 kernel/trace/trace_sched_wakeup.c |   12 ++---
 8 files changed, 50 insertions(+), 83 deletions(-)
-- 
