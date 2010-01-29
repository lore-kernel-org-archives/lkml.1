Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609Ab0A2CIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0A2CIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047Ab0A2CHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:07:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:56222 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0A2CHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:07:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SkrDWlVjMJUZtLt9NN3P9fOJlXrO1LDh3rymKIJfk8+82njn8UXTRcGPM1oeRe27f4
         uXkRA1jkTdLARm/by84XMJiYfgast5F9lYbgDWdwKv0kXX8elFw9N/C1JJXksylJRU0H
         L8Byw6v+WbMMIk8Y0pV1r/N8BMOHwHbIjXkls=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>
Subject: [GIT PULL] perf events updates
Date: Fri, 29 Jan 2010 03:07:04 +0100
Message-Id: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

K.Prasad (2):
      x86/debug: Clear reserved bits of DR6 in do_debug()
      x86/hw-breakpoints: Optimize return code from notifier chain in hw_breakpoint_handler

Xiao Guangrong (2):
      perf: Factorize trace events raw sample buffer operations
      tracing/kprobe: Cleanup unused return value of tracing functions

Anton Blanchard (1):
      perf: Fix inconsistency between IP and callchain sampling


 arch/powerpc/kernel/perf_callchain.c |    3 -
 arch/sh/kernel/perf_callchain.c      |    3 -
 arch/x86/include/asm/debugreg.h      |    3 +
 arch/x86/kernel/cpu/perf_event.c     |    3 -
 arch/x86/kernel/hw_breakpoint.c      |   10 ++-
 arch/x86/kernel/traps.c              |    3 +
 include/linux/ftrace_event.h         |   18 +++++-
 include/trace/ftrace.h               |   48 ++-------------
 kernel/trace/trace_event_profile.c   |   52 +++++++++++++++--
 kernel/trace/trace_kprobe.c          |  109 ++++++----------------------------
 kernel/trace/trace_syscalls.c        |   71 +++-------------------
 11 files changed, 109 insertions(+), 214 deletions(-)
