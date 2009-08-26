Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbZHZI4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbZHZI4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZHZI4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:56:35 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:36800 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZHZI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:56:34 -0400
Date: Wed, 26 Aug 2009 10:56:09 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [GIT PULL] tracing/syscall for 2.6.32
Message-ID: <20090826085609.GA31202@osiris.boeblingen.de.ibm.com>
References: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
 <20090826063436.GB13577@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826063436.GB13577@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 08:34:36AM +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Hi Ingo,
> > 
> > Please pull the latest syscall tracing patches from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> > 	tracing/core
> > 
> > The tree gathers fixes, renamings and adds a new pair of tracepoints
> > for generic sysenter/sysexit tracing.
> > 
> > Some other patches are pending, beeing discussed. So there are probably
> > more to come soon.
> > 
> > Josh Stone (4):
> >       tracing: Rename FTRACE_SYSCALLS for tracepoints
> >       tracing: Make syscall tracepoints conditional
> >       tracing: Move tracepoint callbacks from declaration to definition
> >       tracing: Create generic syscall TRACE_EVENTs
> > 
> >  arch/s390/Kconfig                   |    2 +-
> >  arch/s390/defconfig                 |    2 +-
> >  arch/s390/include/asm/thread_info.h |    4 +-
> >  arch/s390/kernel/entry.S            |    2 +-
> >  arch/s390/kernel/entry64.S          |    2 +-
> >  arch/s390/kernel/ptrace.c           |   12 +++---
> >  arch/x86/Kconfig                    |    2 +-
> >  arch/x86/configs/i386_defconfig     |    2 +-
> >  arch/x86/configs/x86_64_defconfig   |    2 +-
> >  arch/x86/include/asm/thread_info.h  |   13 +++---
> >  arch/x86/kernel/ptrace.c            |   16 +++----
> >  include/linux/tracepoint.h          |   46 +++++++++--------------
> >  include/trace/define_trace.h        |    5 ++
> >  include/trace/events/syscalls.h     |   70 +++++++++++++++++++++++++++++++++++
> >  include/trace/ftrace.h              |    9 ++++
> >  include/trace/syscall.h             |   17 --------
> >  kernel/trace/Kconfig                |    4 +-
> >  kernel/trace/trace_syscalls.c       |   17 ++++----
> >  kernel/tracepoint.c                 |   20 ++++++----
> >  19 files changed, 154 insertions(+), 93 deletions(-)
> >  create mode 100644 include/trace/events/syscalls.h
> 
> Pulled, thanks!
> 
> Heiko, Martin, do the S390 bits look good to you? I have build 
> tested the S390 defconfig - it built fine beyond to pre-existing 
> warnings:

Yes, looks ok to me.

Thanks!
