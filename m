Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZFJFnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZFJFnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZFJFmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZFJFmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:51 -0400
Message-Id: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 00/11] [GIT PULL] more updates for the tag format
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/event-print-format tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/event-print-format


Li Zefan (1):
      tracing/events: convert block trace points to TRACE_EVENT(), fix

Steven Rostedt (10):
      tracing: add nsec2sec print formats
      tracing: convert lockdep lock_acquired trace point to use nsec2usec tag
      tracing: add major and minor tags for print format
      tracing: use << to print < instead of \<
      tracing: convert the block trace points to use the new tag format
      tracing: add test for strings in event tag format
      tracing: add func and symfunc to tag format
      tracing: check full name for field
      tracing: update sample code with new tag format
      tracing: move '>' to out of macros and into print statement

----
 include/linux/blktrace_api.h               |    4 +-
 include/linux/ftrace_event.h               |    3 +-
 include/trace/events/block.h               |  101 +++------
 include/trace/events/irq.h                 |    8 +-
 include/trace/events/kmem.h                |   12 +-
 include/trace/events/lockdep.h             |    8 +-
 include/trace/ftrace.h                     |    2 +-
 kernel/trace/trace_output.c                |    2 +-
 kernel/trace/trace_output.h                |    4 +
 kernel/trace/trace_read_binary.c           |  304 +++++++++++++++++++++++-----
 samples/trace_events/trace-events-sample.c |   21 ++-
 samples/trace_events/trace-events-sample.h |   66 ++++++
 12 files changed, 399 insertions(+), 136 deletions(-)
-- 
