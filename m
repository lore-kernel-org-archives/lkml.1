Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab0BRLNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:13:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56669 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0BRLNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=G3zASPE8QMaX2r6H+F6r5gRDqW7gdUSGuvwFzbxiho8BxT1pTYMQT8+B2g37i6BEvJ
         1nV2yeuBzmLV4CnkkRrC2w4nukKPapWjTcAeEJaVTZtcLS16xIjlOX0OREYqNMtmpGjG
         nbTsN8QB0ZwPd9l3Lb9FqBmD3YjiBddXoHDYw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier@gentoo.org>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing updates
Date: Thu, 18 Feb 2010 12:13:33 +0100
Message-Id: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
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

Heiko Carstens (2):
      tracing/kprobes: Make Kconfig dependencies generic
      s390: Add pt_regs register and stack access API

Mike Frysinger (1):
      tracing: Unify arch_syscall_addr() implementations


 Documentation/trace/ftrace-design.txt |    5 +--
 arch/Kconfig                          |    3 ++
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
 17 files changed, 107 insertions(+), 45 deletions(-)
