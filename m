Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZJNTPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZJNTPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbZJNTPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:15:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:48783 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZJNTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nCE0LEE51kIU9pZbVo5+nCEzwfc/fjQzNbktRkYqr4LPWQ9i/Xm0F5fIu/vK4yzv2R
         +7iw/Iga3kdh7EKYPxt/yJpWEBY9PiE3ABWYS2Z1AHRtq7zplQ+S/RY5ziIqd2n2PQ5n
         P+e1oBplGxUx/+0Vh4oO086m1fyWXXekIs34E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing: Arch syscalls tracing shrinks and fixlets
Date: Wed, 14 Oct 2009 21:13:14 +0200
Message-Id: <1255547598-5294-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/core branch that can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks,
Frederic.

---
Frederic Weisbecker (4):
      tracing: Move syscalls metadata handling from arch to core
      tracing: Document HAVE_SYSCALL_TRACEPOINTS needs
      ftrace: Copy ftrace_graph_filter boot param using strlcpy
      ftrace: Rename set_bootup_ftrace into set_cmdline_ftrace

 Documentation/trace/ftrace-design.txt |   13 ++++-
 arch/s390/kernel/ftrace.c             |   67 +-------------------------
 arch/x86/kernel/ftrace.c              |   76 +----------------------------
 include/trace/syscall.h               |    2 +-
 kernel/trace/ftrace.c                 |    2 +-
 kernel/trace/trace.c                  |    4 +-
 kernel/trace/trace_syscalls.c         |   86 +++++++++++++++++++++++++++++++++
 7 files changed, 105 insertions(+), 145 deletions(-)
