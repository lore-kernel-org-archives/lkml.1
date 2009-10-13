Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbZJMUgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbZJMUgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbZJMUgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:36:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760904AbZJMUgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:36:22 -0400
Message-Id: <20091013203349.814936710@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 16:33:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL][2.6.33] tracing: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Jiri Olsa (2):
      tracing: enable records during the module load
      tracing: enabling "__cold" functions

Steven Rostedt (2):
      function-graph/x86: replace unbalanced ret with jmp
      tracing: export symbols for kernel lock tracepoints

jolsa@redhat.com (1):
      tracing: support multiple pids in set_pid_ftrace file

----
 arch/x86/kernel/entry_32.S |    7 +-
 arch/x86/kernel/entry_64.S |    6 +-
 kernel/trace/ftrace.c      |  272 +++++++++++++++++++++++++++++++-------------
 kernel/trace/trace.h       |    4 +-
 lib/kernel_lock.c          |    2 +
 scripts/recordmcount.pl    |    1 +
 6 files changed, 205 insertions(+), 87 deletions(-)
