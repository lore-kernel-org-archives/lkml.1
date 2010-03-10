Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0CJHvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 02:51:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab0CJHvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 02:51:15 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/4] tracing: function graph output for preempt/irqs-off tracers
Date: Wed, 10 Mar 2010 08:51:06 +0100
Message-Id: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
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

v2 changes:
- keeping the current function graph output format


wbr,
jirka
---
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace.h                 |   15 ++--
 kernel/trace/trace_functions_graph.c |  124 +++++++++++++++++++++----
 kernel/trace/trace_irqsoff.c         |  174 ++++++++++++++++++++++++++++++++--
 4 files changed, 283 insertions(+), 32 deletions(-)
