Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZEUDSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZEUDSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZEUDRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:17:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64961 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbZEUDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:17:49 -0400
Message-Id: <20090521031711.494593605@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 23:17:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/5] [GIT PULL] tracing: print event flags and symbols
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (5):
      tracing: add __print_flags for events
      tracing: add previous task state info to sched switch event
      tracing: add flag output for kmem events
      tracing: add __print_symbolic to trace events
      tracing: convert irq events to use __print_symbolic

----
 include/linux/ftrace_event.h |   16 ++++++++++-
 include/trace/events/irq.h   |   23 +++++++++++----
 include/trace/events/kmem.h  |   53 ++++++++++++++++++++++++++++++-----
 include/trace/events/sched.h |    9 +++++-
 include/trace/ftrace.h       |   22 ++++++++++++++
 kernel/trace/trace_output.c  |   63 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 170 insertions(+), 16 deletions(-)
-- 
