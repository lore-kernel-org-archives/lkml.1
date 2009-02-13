Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZBMFaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZBMFaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZBMFaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:30:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60557 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZBMFaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:30:05 -0500
Message-Id: <20090213052358.524970112@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Feb 2009 00:23:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [PATCH 0/7] [git pull] powerpc function graph tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Benjamin,

I figured you can run it through your test boxes.

Please pull the latest ppc/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
ppc/ftrace


Steven Rostedt (7):
      tracing/function-graph-tracer: make arch generic push pop functions
      powerpc64: port of the function graph tracer
      powerpc64, tracing: add function graph tracer with dynamic tracing
      powerpc64, ftrace: save toc only on modules for function graph
      powerpc32, ftrace: save and restore mcount regs with macro
      powerpc32, ftrace: port function graph tracer to ppc32, static only
      powerpc32, ftrace: dynamic function graph tracer

----
 arch/powerpc/Kconfig                 |    1 +
 arch/powerpc/include/asm/ftrace.h    |   39 ++++++++++-
 arch/powerpc/kernel/Makefile         |    9 +-
 arch/powerpc/kernel/entry_32.S       |  115 ++++++++++++++---------------
 arch/powerpc/kernel/entry_64.S       |   89 +++++++++++++++++++++-
 arch/powerpc/kernel/ftrace.c         |  135 ++++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/process.c        |   16 ++++
 arch/powerpc/kernel/vmlinux.lds.S    |    1 +
 arch/x86/include/asm/ftrace.h        |   25 ------
 arch/x86/kernel/ftrace.c             |   75 +------------------
 include/linux/ftrace.h               |   24 ++++++
 kernel/trace/trace_functions_graph.c |   75 +++++++++++++++++++
 12 files changed, 428 insertions(+), 176 deletions(-)
-- 
