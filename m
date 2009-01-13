Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbZAMGMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbZAMGMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZAMGLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:11:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZAMGLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:11:48 -0500
Message-Id: <20090113061110.856268617@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Jan 2009 01:11:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       u.kleine-koenig@pengutronix.de
Subject: [PATCH 0/9] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Frederic Weisbecker (2):
      tracing/ftrace: separate events tracing and stats tracing engine
      tracing: add a new workqueue tracer

Shaohua Li (6):
      ftrace, ia64: make recordmcount destinct module compile
      ftrace, ia64: explictly ignore a file in recordmcount.pl
      ftrace, ia64: Add macro for ftrace_caller
      ftrace, ia64: Add recordmcount for ia64
      ftrace, ia64: IA64 static ftrace support
      ftrace, ia64: IA64 dynamic ftrace support

Uwe Kleine-K?nig (1):
      ftrace, trivial: fix typo "resgister" -> "register"

----
 arch/ia64/Kconfig              |    3 +
 arch/ia64/include/asm/ftrace.h |   28 ++++
 arch/ia64/kernel/Makefile      |    5 +
 arch/ia64/kernel/entry.S       |  100 ++++++++++++++
 arch/ia64/kernel/ftrace.c      |  206 ++++++++++++++++++++++++++++
 arch/ia64/kernel/ia64_ksyms.c  |    6 +
 include/linux/ftrace.h         |    4 +
 include/trace/workqueue.h      |   25 ++++
 kernel/trace/Kconfig           |   11 ++
 kernel/trace/Makefile          |    1 +
 kernel/trace/ftrace.c          |   14 +--
 kernel/trace/trace.c           |    2 -
 kernel/trace/trace.h           |   20 ---
 kernel/trace/trace_branch.c    |  108 +++++++++-------
 kernel/trace/trace_stat.c      |  191 +++++++++++---------------
 kernel/trace/trace_stat.h      |   31 +++++
 kernel/trace/trace_workqueue.c |  287 ++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c             |   16 ++-
 scripts/Makefile.build         |   13 +-
 scripts/recordmcount.pl        |   18 ++-
 20 files changed, 888 insertions(+), 201 deletions(-)
-- 
