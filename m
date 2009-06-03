Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZFCPSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZFCPSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZFCPSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:18:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53988 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbZFCPSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:18:20 -0400
Message-Id: <20090603151724.144915858@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 11:17:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIP PULL] tracing/events/trace_stack: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-4 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-4


Steven Rostedt (1):
      tracing: add annotation to what type of stack trace is recorded

Steven Whitehouse (1):
      tracing: fix multiple use of __print_flags and __print_symbolic

walimis (3):
      tracing/trace_stack: fix the number of entries in the header
      tracing/events: fix output format of kernel stack
      tracing/events: fix output format of user stack

----
 include/trace/ftrace.h      |    2 ++
 kernel/trace/trace_output.c |   35 ++++++++++++++++++-----------------
 kernel/trace/trace_stack.c  |    2 +-
 3 files changed, 21 insertions(+), 18 deletions(-)
-- 
