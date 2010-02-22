Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0BVM5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:57:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0BVM5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:57:15 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] tracing: function graph output for preempt/irqs-off tracers
Date: Mon, 22 Feb 2010 13:56:58 +0100
Message-Id: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm sending reworked version of the graph output support for
preemptirqsoff/preemptoff/irqsoff tracers.

I made the graph output as an output event, so it could be shared
within tracers - patch 1/4.

I also added raw trace output for graph tracer. I have this one around
for long time and it was quite handy for investigating graph tracer issues.
(patch 4/4)


attached patches:
- 1/4 adding ftrace events for graph tracer
- 2/4 graph output support for irqsoff tracer
- 3/4 graph output support for preemptirqsoff/preemptoff tracers
- 4/4 raw output for graph tracer

wbr,
jirka
---
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace.h                 |   11 ++-
 kernel/trace/trace_functions_graph.c |  117 +++++++++++++++++++----
 kernel/trace/trace_irqsoff.c         |  174 ++++++++++++++++++++++++++++++++--
 4 files changed, 277 insertions(+), 27 deletions(-)
