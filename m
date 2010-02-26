Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689Ab0BZSUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:20:54 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58563 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965631Ab0BZSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tv72qUGLO4NezCASQCaQDcUEzVHO8KON869akPtO+5i/GP9x2EdEj7lujfH1tOTWbd
         yQzYZVKUfUu69MK3Ixpa2sJ7wIBLQ6r3syCKBc/Yong9fz+ZcSc2/rnr55uKZdI8DeJD
         QPDkNKAgkZyy2u0z2JfJUbC9Qdp0UINtUjBI8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL][RESEND] tracing/core updates 
Date: Fri, 26 Feb 2010 19:20:45 +0100
Message-Id: <1267208445-8110-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks,
	Frederic
---

Heiko Carstens (3):
      tracing/kprobes: Make Kconfig dependencies generic
      s390: Add pt_regs register and stack access API
      tracing/kprobes: Add short documentation for HAVE_REGS_AND_STACK_ACCESS_API

Mike Frysinger (1):
      tracing: Unify arch_syscall_addr() implementations


 Documentation/trace/ftrace-design.txt |    5 +--
 arch/Kconfig                          |    8 ++++
 arch/s390/Kconfig                     |    1 +
 arch/s390/include/asm/ptrace.h        |   13 +++++++-
 arch/s390/include/asm/syscall.h       |    7 ++++
 arch/s390/kernel/ftrace.c             |   10 ------
 arch/s390/kernel/ptrace.c             |   58 +++++++++++++++++++++++++++++++++
 arch/sh/include/asm/syscall.h         |    2 +
 arch/sh/kernel/ftrace.c               |    9 -----
 arch/sparc/include/asm/syscall.h      |    7 ++++
 arch/sparc/kernel/ftrace.c            |   11 ------
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/syscall.h        |    2 +
 arch/x86/kernel/ftrace.c              |   10 ------
 include/linux/ftrace.h                |    6 +++
 kernel/trace/Kconfig                  |    2 +-
 kernel/trace/trace_syscalls.c         |    5 +++
 17 files changed, 112 insertions(+), 45 deletions(-)
