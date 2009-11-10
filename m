Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZKJKZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZKJKZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZKJKZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:25:54 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62696 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZKJKZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dE42uZnAcnYjo1E0vmH6w88YJXhguzLYzfEDPe9VMfpflcg8CMNPZ4UhJ27fUkyDX6
         v5cgm7EmeKqsdoWPbOJa1NGBLjoR4ZsXWIJGQY0Abp4rPISUw6EkeLqX28Rq9/i3TRcu
         lBZD2nWhb7OKi+NPKosiiRCHmiBePmn57obuE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [GIT PULL] hw-breakpoints: Various fixes
Date: Tue, 10 Nov 2009 11:25:56 +0100
Message-Id: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/hw-breakpoints branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/hw-breakpoints

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      hw-breakpoints: Fix broken a.out format dump
      hw-breakpoints: Fix broken hw-breakpoint sample module
      hw-breakpoints: Wrap in the KVM breakpoint active state check

Paul Mundt (1):
      ksym_tracer: Support read accesses independent of read/write.


 arch/x86/include/asm/a.out-core.h       |   10 +------
 arch/x86/include/asm/debugreg.h         |    7 +++++
 arch/x86/kernel/hw_breakpoint.c         |   35 +++++++++++++++++++++++++
 arch/x86/kvm/x86.c                      |    2 +-
 kernel/hw_breakpoint.c                  |    3 +-
 kernel/kallsyms.c                       |    1 +
 kernel/trace/trace_ksym.c               |   11 +++++++-
 samples/hw_breakpoint/data_breakpoint.c |   43 +++++++++++++++++-------------
 8 files changed, 82 insertions(+), 30 deletions(-)
