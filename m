Return-Path: <linux-kernel-owner+w=401wt.eu-S932616Ab0AFXRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab0AFXRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586Ab0AFXPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:15:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab0AFXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:33 -0500
X-Authority-Analysis: v=1.0 c=1 a=2cYC_04S-KYA:10 a=VwQbUJbxAAAA:8 a=gb9q6YNK7kpmIwtcgvUA:9 a=AKOdQ8j0mDctA75dOssA:7 a=RFQCYQsTbr3Sw7aC7rwZAfHdxnQA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231349.107649729@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:13:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/11][GIT PULL] tracing: various updates for 2.6.34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Lai Jiangshan (7):
      tracing: Have __dynamic_array() define a field
      tracing: Add print_fmt field
      tracing/syscalls: Init print_fmt for syscall events
      tracing/kprobes: Init print_fmt for kprobe events
      tracing: Use defined fields and print_fmt to print formats
      tracing: Remove show_format and related macros from TRACE_EVENT
      tracing: Consolidate protection of reader access to the ring buffer

Steven Rostedt (2):
      tracing: Have syscall tracing call its own init function
      tracing: Add stack dump to trace_printk if stacktrace option is set

Wolfram Sang (2):
      tracing: optimize recordmcount.pl for offsets-handling
      tracing: Use appropriate perl constructs in recordmcount.pl

----
 include/linux/ftrace_event.h  |    3 +-
 include/linux/syscalls.h      |    6 +-
 include/trace/ftrace.h        |  161 +++++++++--------------------------------
 include/trace/syscall.h       |    4 -
 kernel/trace/trace.c          |  144 ++++++++++++++++++++++++++-----------
 kernel/trace/trace_events.c   |   77 +++++++++++---------
 kernel/trace/trace_export.c   |   87 ++++-------------------
 kernel/trace/trace_kprobe.c   |  104 +++++++++++---------------
 kernel/trace/trace_syscalls.c |  106 ++++++++++++++--------------
 scripts/recordmcount.pl       |   47 +++++-------
 10 files changed, 310 insertions(+), 429 deletions(-)
