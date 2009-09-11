Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZIKN4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZIKN4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZIKN4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:56:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZIKN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:56:23 -0400
Message-Id: <20090911135452.866274568@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 09:54:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/3] [GIT PULL] tracing: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Note, this is bassed off of my last pull request of tip/tracing/core.

Please pull the latest tip/tracing/core2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core2


Steven Rostedt (3):
      x86/tracing: comment need for atomic nop
      tracing/profile: add ref count for registering profile events
      tracing: add latency format to function_graph tracer

----
 arch/x86/include/asm/nops.h          |    2 +
 include/trace/ftrace.h               |   22 +++++++++-
 kernel/trace/trace_functions_graph.c |   74 +++++++++++++++++++++++++++++++---
 3 files changed, 90 insertions(+), 8 deletions(-)
-- 
