Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZEHEes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZEHEes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZEHEdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:33:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZEHEdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:33:31 -0400
Message-Id: <20090508043250.372421144@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 00:32:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] [GIT PULL] tracing/ring-buffer: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (4):
      tracing: have menu default enabled when kernel debug is configured
      ring-buffer: only periodically call cond_resched to ring-buffer-benchmark
      ring-buffer: add total count in ring-buffer-benchmark
      ring-buffer: change WARN_ON from checking preempt_count to preemptible

----
 kernel/trace/Kconfig                 |    1 +
 kernel/trace/ring_buffer.c           |    2 +-
 kernel/trace/ring_buffer_benchmark.c |   22 ++++++++++++++++++++--
 3 files changed, 22 insertions(+), 3 deletions(-)
-- 
