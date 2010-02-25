Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab0BYTpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:45:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab0BYTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:45:29 -0500
X-Authority-Analysis: v=1.0 c=1 a=KAD9THW9RI0A:10 a=VwQbUJbxAAAA:8 a=RuenoSQ9nF2BnTSVx9YA:9 a=XP2ZCdQiUgB17BTRsaIA:7 a=w2wibAyVhOhF_zAcwH5G780d6soA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225194355.707261669@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:43:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7][GIT PULL] tracing: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Jeff Mahoney (1):
      tracing: Fix ftrace_event_call alignment for use with gcc 4.5

Li Zefan (1):
      tracing: Remove CONFIG_TRACE_POWER from kernel config

Steven Rostedt (1):
      ftrace: Remove memory barriers from NMI code when not needed

Wenji Huang (4):
      tracing: Fix typo in prof_sysexit_enable()
      tracing: Fix typo of info text in trace_kprobe.c
      tracing: Remove unnecessary variable in print_graph_return
      tracing: Simplify memory recycle of trace_define_field

----
 arch/x86/kernel/ftrace.c             |   26 ++++++++++++++++++++++++++
 include/linux/syscalls.h             |    6 ++++--
 include/trace/ftrace.h               |    3 ++-
 kernel/trace/Kconfig                 |    9 ---------
 kernel/trace/trace.h                 |    3 ++-
 kernel/trace/trace_events.c          |    4 +---
 kernel/trace/trace_functions_graph.c |    1 -
 kernel/trace/trace_kprobe.c          |    4 ++--
 kernel/trace/trace_syscalls.c        |    2 +-
 9 files changed, 38 insertions(+), 20 deletions(-)

