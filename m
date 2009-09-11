Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZIKPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZIKPRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZIKPRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:17:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZIKPRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:17:15 -0400
Message-Id: <20090911151544.006804282@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 11:15:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/2] [GIT PULL] tracing: comment and function graph latency format
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased the branch to remove the module ref count change. That will
be a separate patch push to make sure everyone agrees with it.

Please pull the latest tip/tracing/core2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core2


Steven Rostedt (2):
      x86/tracing: comment need for atomic nop
      tracing: add latency format to function_graph tracer

----
 arch/x86/include/asm/nops.h          |    2 +
 kernel/trace/trace_functions_graph.c |   74 +++++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 6 deletions(-)
-- 
