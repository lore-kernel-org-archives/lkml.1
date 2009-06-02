Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZFBEns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZFBEns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZFBEni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41665 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZFBEni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:38 -0400
Message-Id: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/10] [GIT PULL] tracing: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-2


Li Zefan (3):
      tracing/events: fix a typo in __string() format output
      tracing/events: put TP_fast_assign into braces
      tracing/events: introduce __dynamic_array()

Steven Rostedt (6):
      ftrace: add kernel command line function filtering
      tracing: fix config options to not show when automatically selected
      tracing: combine the default tracers into one config
      tracing: remove redundant SOFTIRQ from softirq event traces
      tracing: make trace pipe recognize latency format flag
      ftrace: do not profile functions when disabled

Steven Whitehouse (1):
      tracing: add exports to use __print_symbolic and __print_flags from a module

----
 Documentation/kernel-parameters.txt |   17 ++++-
 include/linux/ftrace_event.h        |    2 +-
 include/trace/events/irq.h          |   24 +++---
 include/trace/ftrace.h              |  126 +++++++++++++++++++++++++----------
 kernel/trace/Kconfig                |   60 ++++++++--------
 kernel/trace/ftrace.c               |   50 +++++++++++++-
 kernel/trace/trace.c                |    3 +
 kernel/trace/trace_events_filter.c  |    6 +-
 kernel/trace/trace_output.c         |    3 +
 9 files changed, 205 insertions(+), 86 deletions(-)
-- 
