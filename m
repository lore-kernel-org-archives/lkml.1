Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZCFDTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZCFDTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZCFDTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:19:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZCFDTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:19:43 -0500
Message-Id: <20090306031857.686507907@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 22:18:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (3):
      tracing: make all file_operations const
      tracing: move print of event format to separate file
      tracing: add format files for ftrace default entries

----
 kernel/trace/Makefile               |    1 +
 kernel/trace/ftrace.c               |   10 +-
 kernel/trace/ring_buffer.c          |    2 +-
 kernel/trace/trace.c                |   24 +++---
 kernel/trace/trace_event_types.h    |  165 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.c         |   12 ++-
 kernel/trace/trace_events_stage_2.h |   53 +-----------
 kernel/trace/trace_export.c         |   81 +++++++++++++++++
 kernel/trace/trace_format.h         |   55 ++++++++++++
 kernel/trace/trace_sysprof.c        |    2 +-
 10 files changed, 329 insertions(+), 76 deletions(-)
-- 
