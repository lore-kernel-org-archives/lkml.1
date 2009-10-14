Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZJNTqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZJNTqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbZJNTqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:46:45 -0400
Received: from [71.74.56.125] ([71.74.56.125]:56434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754427AbZJNTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:44 -0400
Message-Id: <20091014194330.980165492@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 00/13] [GIT PULL] perf tools: updates to parsing events
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
perf/core


Steven Rostedt (13):
      perf tools: handle print concatinations in event format file
      perf tools: fix backslash processing on trace print formats
      perf tools: handle trace parsing of '<' and '>'
      perf tools: handle arrays in print fields for trace parsing
      perf tools: handle '*' as typecast in trace parsing
      perf tools: handle newlines in trace parsing better
      perf tools: handle the case with and without the "signed" trace field
      perf tools: still continue on failed parsing of an event
      perf tools: fix bprintk reading in trace output
      perf tools: handle both versions of ftrace output
      perf tools: add latency format to trace output
      perf tools: handle '-' and '+' in parsing trace print format
      perf tools: remove all char * typecasts and use const in prototype

----
 tools/perf/Makefile                 |    2 +-
 tools/perf/builtin-trace.c          |    2 +
 tools/perf/util/trace-event-parse.c |  533 +++++++++++++++++++++++++----------
 tools/perf/util/trace-event.h       |   25 ++-
 4 files changed, 405 insertions(+), 157 deletions(-)
