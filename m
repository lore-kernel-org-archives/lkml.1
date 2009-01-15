Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbZAOAEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbZAOAEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbZAOADg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:03:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbZAOADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:03:34 -0500
Message-Id: <20090115000254.519563275@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 19:02:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/4] ftrace: updates to tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Frederic Weisbecker (1):
      tracing/function-graph-tracer: fix a regression while suspend to disk

Lai Jiangshan (1):
      ring_buffer: reset write when reserve buffer fail

Steven Rostedt (2):
      trace: print ftrace_dump at KERN_EMERG log level
      trace: stop all recording to ring buffer on ftrace_dump

----
 kernel/trace/ftrace.c      |   27 +++++++++++++++++++++++++++
 kernel/trace/ring_buffer.c |   10 +++++-----
 kernel/trace/trace.c       |    3 ++-
 3 files changed, 34 insertions(+), 6 deletions(-)
-- 
