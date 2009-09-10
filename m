Return-Path: <linux-kernel-owner+w=401wt.eu-S1750736AbZIJENA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750736AbZIJENA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbZIJEM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:12:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZIJEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:12:58 -0400
Message-Id: <20090910041219.149954890@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Sep 2009 00:12:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] [GIT PULL] tracing/ring-buffer: various fixes and cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Li Zefan (4):
      tracing: remove dead code
      tracing: format clean ups
      tracing: remove stats from struct tracer
      tracing: move PRED macros to trace_events_filter.c

Robert Richter (1):
      ring-buffer: consolidate interface of rb_buffer_peek()

Steven Rostedt (1):
      tracing: do not grab lock in wakeup latency function tracing

----
 kernel/trace/ring_buffer.c         |   11 ++---
 kernel/trace/trace.h               |   86 +++++-------------------------------
 kernel/trace/trace_events_filter.c |   41 +++++++++++++++++
 kernel/trace/trace_sched_wakeup.c  |   36 +++++++++------
 4 files changed, 78 insertions(+), 96 deletions(-)
-- 
