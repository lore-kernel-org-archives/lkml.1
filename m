Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZISFjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZISFjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 01:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZISFjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 01:39:19 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53950 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZISFjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 01:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MY7XGeXKv7c36afGBcwEQHhb99wYi9WpBfzCr+Sp8PN49U+em6XKYciG9GvrfDsX5U
         Qyznf2RXeYOwXBDUY8qQ1LtMOeDbm8uNpB/9RZfjhgiy3fKGo+AtogsLxIXHtj4QUb41
         0NI6Yt6z4ZZ+b0k0RPgl89wEw+ZsA1yCgqT/A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [GIT PULL] tracing/syscalls: Arch code shrinks, easier arch integration
Date: Sat, 19 Sep 2009 07:39:15 +0200
Message-Id: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This patchset moves most of the arch syscalls tracing code to core,
since most of it has become pretty generic since the latest changes.

Note: I haven't tested the s390 changes.

Please pull from the tracing/syscalls branch which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/syscalls

Thanks,
Frederic.

Frederic Weisbecker (2):
      tracing: Move syscalls metadata handling from arch to core
      tracing: Document HAVE_FTRACE_SYSCALLS needs

 Documentation/trace/ftrace-design.txt |   11 ++++-
 arch/s390/kernel/ftrace.c             |   67 +--------------------------
 arch/x86/kernel/ftrace.c              |   76 +------------------------------
 include/trace/syscall.h               |    2 +-
 kernel/trace/trace_syscalls.c         |   80 +++++++++++++++++++++++++++++++++
 5 files changed, 95 insertions(+), 141 deletions(-)
