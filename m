Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbZDTRlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbZDTRlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZDTRkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:40:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZDTRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:40:19 -0400
Message-Id: <20090420173819.957332585@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:38:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The first patch is a fix to a change to late_initcall that was somehow
dropped. Probably due to the issues that the patch was causing and
it may have conflicted with your temporary disabling of the selftests.

The next patch is a compile fix for all tracing disabled.

The last two are recursive testing fixes.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (4):
      tracing/events: call the correct event trace selftest init function
      tracing: remove dangling semicolon
      tracing: fix recursive test level calculation
      tracing: remove recursive test from ring_buffer_event_discard

----
 include/linux/trace_seq.h   |    2 +-
 kernel/trace/ring_buffer.c  |    5 +++--
 kernel/trace/trace_events.c |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)
-- 
