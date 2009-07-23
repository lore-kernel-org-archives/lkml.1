Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZGWVCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZGWVCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZGWVCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:02:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbZGWVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:02:22 -0400
Message-Id: <20090723210047.294710482@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 17:00:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL][2.6.31] tracing: more fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo and Thomas,

Here are 4 more fixes that should be in 31. They are minor and small, but
still should be made.

Please pull the latest tip/tracing/urgent-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent-1


Matt Fleming (2):
      ftrace: Fix the conditional that updates $ref_func
      ftrace: Only update $offset when we update $ref_func

Steven Rostedt (2):
      tracing: show proper address for trace-printk format
      tracing: only truncate ftrace files when O_TRUNC is set

----
 kernel/trace/ftrace.c       |    4 ++--
 kernel/trace/trace.c        |    2 +-
 kernel/trace/trace_events.c |    2 +-
 kernel/trace/trace_printk.c |    2 +-
 scripts/recordmcount.pl     |    5 +++--
 5 files changed, 8 insertions(+), 7 deletions(-)
-- 
