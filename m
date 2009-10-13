Return-Path: <linux-kernel-owner+w=401wt.eu-S934358AbZJMVWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358AbZJMVWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZJMVWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:22:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZJMVWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:22:16 -0400
Message-Id: <20091013211934.941504044@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 17:19:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PUSH][v2.6.33] tracing: various updates (take 2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

As Frederic pointed out, one of the patches is no longer needed.
I dropped it and rebased.

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Jiri Olsa (2):
      tracing: enable records during the module load
      tracing: enabling "__cold" functions

Steven Rostedt (1):
      function-graph/x86: replace unbalanced ret with jmp

jolsa@redhat.com (1):
      tracing: support multiple pids in set_pid_ftrace file

----
 arch/x86/kernel/entry_32.S |    7 +-
 arch/x86/kernel/entry_64.S |    6 +-
 kernel/trace/ftrace.c      |  272 +++++++++++++++++++++++++++++++-------------
 kernel/trace/trace.h       |    4 +-
 scripts/recordmcount.pl    |    1 +
 5 files changed, 203 insertions(+), 87 deletions(-)

