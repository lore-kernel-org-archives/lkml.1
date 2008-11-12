Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbYKLVWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbYKLVWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYKLVVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:21:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYKLVVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:21:51 -0500
Message-Id: <20081112212127.455979814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 16:21:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (4):
      trace: rename unlikely profiler to branch profiler
      ftrace: rename unlikely iter_ctrl to branch
      ftrace: add tracer called branch
      ftrace: rename trace_unlikely.c file

----
 arch/x86/kernel/vsyscall_64.c     |    2 +-
 arch/x86/vdso/vclock_gettime.c    |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/compiler.h          |   19 ++-
 kernel/trace/Kconfig              |   10 +-
 kernel/trace/Makefile             |    7 +-
 kernel/trace/trace.c              |   16 +-
 kernel/trace/trace.h              |   34 ++--
 kernel/trace/trace_branch.c       |  320 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_selftest.c     |   23 +++
 kernel/trace/trace_unlikely.c     |  278 --------------------------------
 11 files changed, 390 insertions(+), 323 deletions(-)
