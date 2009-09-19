Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZISJJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZISJJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbZISJI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:08:59 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54606 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZISJI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UB3oqele4JqjkODOpIxNJz8W1w0so81pPrSGv1THqKOTWb38iwd7LPQjWrSFDq9UCm
         IDlqL720qt7TCuyOYbfwJm+jvuK8nHg04o2IDXC0pvxAr7gTYAudW7Ia+1dQXqALFwsj
         sH1cE1UES07B/rCo0hxRrLCKTZzsYOpGU1Gho=
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
Subject: [GIT PULL v2] tracing/syscalls: Arch code shrinks, easier arch integration
Date: Sat, 19 Sep 2009 11:08:56 +0200
Message-Id: <1253351338-5301-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Heiko,

I've updated the patches following your reviews.
Please tell me if you see another troubles.

The new tree can be pulled from:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/syscalls-v2

Thanks,
	Frederic.

Frederic Weisbecker (2):
      tracing: Move syscalls metadata handling from arch to core
      tracing: Document HAVE_SYSCALL_TRACEPOINTS needs

 Documentation/trace/ftrace-design.txt |   13 ++++-
 arch/s390/kernel/ftrace.c             |   67 +-------------------------
 arch/x86/kernel/ftrace.c              |   76 +----------------------------
 include/trace/syscall.h               |    2 +-
 kernel/trace/trace_syscalls.c         |   86 +++++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 142 deletions(-)
