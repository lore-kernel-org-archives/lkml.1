Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZGUBqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZGUBqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZGUBqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:46:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbZGUBqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:46:10 -0400
Message-Id: <20090721014528.716901277@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Jul 2009 21:45:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL] tracing: various updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Lai Jiangshan (1):
      tracing/events: add missing type info of dynamic arrays

Li Zefan (2):
      tracing/events: record the size of dynamic arrays
      tracing/filters: improve subsystem filter

Xiao Guangrong (1):
      tracing: cleanup for tracing_trace_options_read()

----
 include/linux/ftrace_event.h       |    4 +-
 include/trace/ftrace.h             |   18 +++--
 kernel/trace/trace.c               |    6 +-
 kernel/trace/trace.h               |    3 +-
 kernel/trace/trace_events_filter.c |  130 ++++++++++++++++++++++++------------
 5 files changed, 104 insertions(+), 57 deletions(-)
-- 
