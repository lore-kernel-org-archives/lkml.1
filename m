Return-Path: <linux-kernel-owner+w=401wt.eu-S1761407AbZEGDPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761407AbZEGDPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbZEGDOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZEGDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:34 -0400
Message-Id: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/7] [GIT PULL] tracing/ring-buffer: more updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (7):
      ring-buffer: remove unneeded conditional in rb_reserve_next
      ring-buffer: check for failed allocation in ring buffer benchmark
      ring-buffer: make moving the tail page a separate function
      ring-buffer: change test to be more latency friendly
      tracing: update sample with TRACE_INCLUDE_FILE
      tracing: reset ring buffer when removing modules with events
      tracing: add hierarchical enabling of events

----
 kernel/trace/ring_buffer.c                 |   97 ++++++++++---------
 kernel/trace/ring_buffer_benchmark.c       |   34 +++++++
 kernel/trace/trace.c                       |   10 ++
 kernel/trace/trace.h                       |    2 +
 kernel/trace/trace_events.c                |  149 ++++++++++++++++++++++++++++
 samples/trace_events/trace-events-sample.h |    7 +-
 6 files changed, 253 insertions(+), 46 deletions(-)
-- 
