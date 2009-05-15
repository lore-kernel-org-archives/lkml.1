Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZEOVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZEOVIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZEOVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:07:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbZEOVHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:07:18 -0400
Message-Id: <20090515210342.488025506@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 17:03:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 0/3] tracing/events: enumerating flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I'm not really publishing this as a pull request. I would like one last
comment from people since the last patch modifies the kmem trace to
print out the actual names of the flags instead of a flags value. If
this is unwanted, then I can strip it out in my next series.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/ftrace-1


Steven Rostedt (3):
      tracing: add __print_flags for events
      tracing: add previous task state info to sched switch event
      tracing: add flag output for kmem events

----
 include/linux/ftrace_event.h |    6 ++++-
 include/trace/events/kmem.h  |   43 ++++++++++++++++++++++++++++++++++-------
 include/trace/events/sched.h |    8 ++++++-
 include/trace/ftrace.h       |   10 +++++++++
 kernel/trace/trace_output.c  |   38 +++++++++++++++++++++++++++++++++++++
 5 files changed, 95 insertions(+), 10 deletions(-)

-- 
