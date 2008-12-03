Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYLCEuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYLCEuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYLCEuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:50:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYLCEup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:50:45 -0500
Message-Id: <20081203045001.367443457@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 23:50:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Most of thes patches are improvements to function graph. I'm
working on making a way to pick a function to trace, which the
patch function entry patch is needed.

The one ring buffer patch converts all variables called 'page' to
'bpage' as per Andrew's request.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (5):
      ftrace: add ftrace_graph_stop
      ring-buffer: change page variables to bpage
      ftrace: print real return in dumpstack for function graph
      ftrace: function graph return for function entry
      ftrace: add checks on ret stack in function graph

----
 arch/x86/kernel/dumpstack.c    |   34 ++++++++++-
 arch/x86/kernel/dumpstack.h    |    2 +-
 arch/x86/kernel/dumpstack_32.c |    5 +-
 arch/x86/kernel/dumpstack_64.c |    7 +-
 arch/x86/kernel/entry_32.S     |    3 +
 arch/x86/kernel/entry_64.S     |    3 +
 arch/x86/kernel/ftrace.c       |   34 +++++++++--
 include/linux/ftrace.h         |    4 +-
 kernel/trace/ftrace.c          |   15 ++++-
 kernel/trace/ring_buffer.c     |  130 ++++++++++++++++++++--------------------
 kernel/trace/trace.c           |    4 +-
 kernel/trace/trace.h           |    2 +-
 12 files changed, 161 insertions(+), 82 deletions(-)

-- 
