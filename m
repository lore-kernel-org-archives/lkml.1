Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbZBJRga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbZBJRga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZBJRgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZBJRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:19 -0500
Message-Id: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] git pull request for tip/tracing/ftace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following is based off of tip/tracing/ftrace.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/tracing/ftrace


Lai Jiangshan (2):
      ring_buffer: fix typing mistake
      ring_buffer: fix ring_buffer_read_page()

Steven Rostedt (1):
      tracing, x86: fix constraint for parent variable

Tobias Klauser (1):
      tracing: storage class should be before const qualifier

Wenji Huang (3):
      tracing: remove unneeded variable
      tracing: provide correct return value after outputting the event
      tracing: fix typos in comments

----
 arch/x86/kernel/ftrace.c             |    9 +++---
 include/linux/ring_buffer.h          |    2 +-
 kernel/trace/ring_buffer.c           |   46 +++++++++++++++++++--------------
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace_branch.c          |    4 +--
 kernel/trace/trace_functions_graph.c |   14 +++++-----
 kernel/trace/trace_hw_branches.c     |    2 +-
 kernel/trace/trace_sysprof.c         |    2 +-
 8 files changed, 42 insertions(+), 39 deletions(-)

-- 
