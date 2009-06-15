Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbZFOPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbZFOPoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZFOPoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZFOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:09 -0400
Message-Id: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL] updates for 2.6.31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This patch series are fixes that should get into 2.6.31 (maybe some of
them even into stable?).

Please pull the latest tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tracing/ftrace


Li Zefan (4):
      tracing: fix a typo in tracing_cpumask_write()
      tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
      tracing/filters: operand can be negative
      tracing/filters: strloc should be unsigned short

Rusty Russell (1):
      cpumask: use new operators in kernel/trace

Steven Rostedt (1):
      ring-buffer: prevent adding write in discarded area

Wu Zhangjin (1):
      tracing: fix undeclared 'PAGE_SIZE' in include/linux/trace_seq.h

----
 include/linux/trace_seq.h          |    2 +
 kernel/trace/kmemtrace.c           |    2 +-
 kernel/trace/ring_buffer.c         |   72 +++++++++++++++++++++++++++++-------
 kernel/trace/trace.c               |    8 ++--
 kernel/trace/trace_events_filter.c |    9 +++-
 5 files changed, 72 insertions(+), 21 deletions(-)
-- 
