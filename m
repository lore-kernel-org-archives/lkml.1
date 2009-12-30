Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbZL3Q0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbZL3Q0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZL3Q0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:26:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33389 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZL3Q0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:26:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=xI7w3v66v04A:10 a=VwQbUJbxAAAA:8 a=TA1ItC4VfpKqP0Q5T6UA:9 a=CLYS_mrrqAkbgJlTHYNWcJFgQioA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091230162303.088852290@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 30 Dec 2009 11:23:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/3][GIT PULL][v2.6.33] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The previous pull request was a bit too much for 33-rc. I pulled out
the three patches that are fixes that should definitely be in 33,
and I'll save the conversion to print_fmt for 34.

When these changes are in 33-rc, I'll send out another pull request
based on that 33-rc with the rest of the changes. That pull request
will be for 34.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Lai Jiangshan (3):
      tracing/kprobe: Show sign of fields in trace_kprobe format files
      tracing/syscalls: Fix typo in SYSCALL_DEFINE0
      tracing: Fix sign fields in ftrace_define_fields_##call()

----
 include/linux/syscalls.h    |    2 +-
 include/trace/ftrace.h      |    7 ++++---
 kernel/trace/trace_export.c |    7 ++++---
 kernel/trace/trace_kprobe.c |    7 ++++---
 4 files changed, 13 insertions(+), 10 deletions(-)
