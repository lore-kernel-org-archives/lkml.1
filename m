Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZIMDGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZIMDGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZIMDGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:06:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbZIMDGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:06:14 -0400
Message-Id: <20090913030543.204871396@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:05:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/4] [GIT PULL] tracing: more fixes for v2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This patch set is based off of tip/tracing/core.

This also includes Li's fix for the perf counter module race.

Please pull the latest tip/tracing/core2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core2


Jiri Olsa (1):
      tracing/function-graph: x86_64 stack allocation cleanup

John Reiser (1):
      ftrace: __start_mcount_loc should be .init.rodata

Li Zefan (1):
      tracing/profile: fix profile_disable vs module_unload

Tom Zanussi (1):
      tracing/filters: add filter Documentation

----
 Documentation/trace/events.txt     |  184 +++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/entry_64.S         |    6 +-
 include/asm-generic/vmlinux.lds.h  |    5 +-
 kernel/trace/trace_event_profile.c |    5 +-
 4 files changed, 193 insertions(+), 7 deletions(-)
-- 
