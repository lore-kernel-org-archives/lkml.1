Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZH2XdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZH2XdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZH2XdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:33:09 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:52664 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZH2XdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TDfzf+qHhfVYJfWV43kIsUP+Vz2tBQWKwF2WYkLtz4JhzpcepODyIRMGjv4OQ+JgcD
         TnKSHJE/22LarQhOJpvNT9LHxc/Ijqonh4nx/jBjFd+JyTgAE3E4EA8sqD2Jvm2lADU9
         VoZ/NriYwym1dBpMUMtumXa2DlQG7LkBmbbuQ=
Date: Sun, 30 Aug 2009 01:33:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] tracing/syscalls: The next bunch
Message-ID: <20090829233304.GA6101@nowhere>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com> <20090829104334.GA17156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090829104334.GA17156@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 12:43:34PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Here is another bunch of syscalls tracing patches.
> 
> i have tested them, and something in this batch, when merged into 
> tip/master:
> 
> 0dd7b74: tracing: Fix double CPP substitution in TRACE_EVENT_FN
> 66c6e29: Merge branch 'tracing/core' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing into tracing/core
> 117226d: tracing: Remove FTRACE_SYSCALL_MAX definitions
> 57421db: tracing: Convert event tracing code to use NR_syscalls
> a5a2f8e: tracing: Define NR_syscalls for x86_64
> dd86dda: tracing: Define NR_syscalls for x86 (32)
> cc3b13c: tracing: Don't trace kernel thread syscalls
> cd0980f: tracing: Check invalid syscall nr while tracing syscalls
> 7515bf5: tracing: Add syscall tracepoints - s390 arch update


Argh, I've just tested a merge of tip:tracing/core into tip:master
and I can't reproduce the hang, neither in x86-64 SMP nor in a
pentium III :-(

