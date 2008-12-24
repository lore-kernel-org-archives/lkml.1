Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYLXEZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYLXEZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 23:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYLXEZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 23:25:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYLXEZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 23:25:00 -0500
Message-Id: <20081224042410.746044949@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 23 Dec 2008 23:24:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 0/3] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series restructures the output functions of trace.c.

Events are now registered and maintaining an event output is
simplified by keeping the output close together.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      ftrace: remove obsolete print continue functionality
      ftrace: set up trace event hash infrastructure
      ftrace: change trace.c to use registered events

----
 kernel/trace/Makefile                |    1 +
 kernel/trace/trace.c                 |  738 ++----------------------------
 kernel/trace/trace.h                 |   15 +-
 kernel/trace/trace_boot.c            |    1 +
 kernel/trace/trace_branch.c          |   53 +++
 kernel/trace/trace_functions_graph.c |    4 +-
 kernel/trace/trace_hw_branches.c     |    1 +
 kernel/trace/trace_mmiotrace.c       |    4 +-
 kernel/trace/trace_output.c          |  832 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.h          |   59 +++
 kernel/trace/trace_power.c           |    1 +
 11 files changed, 990 insertions(+), 719 deletions(-)
-- 
