Return-Path: <linux-kernel-owner+w=401wt.eu-S934480AbZJMWZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480AbZJMWZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934452AbZJMWZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:25:50 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54743 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934418AbZJMWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eBdha7tQTdPlgJx/GKYbfCA/m6NB5ipFN7FPubjHB6jW1yYG+mZEI1knBPIXS4tE4O
         HpvT+sr8nDkFtVg5bXKM6bKDew+O3xYzVk2K772YczibBdl1Bks2WvQzVNPoKykk8Cxz
         fE153b/5HMMXRrIR8XTFZgTFofRUF83fDahOo=
Date: Wed, 14 Oct 2009 00:25:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [GIT PULL v2] tracing/syscalls: Arch code shrinks, easier arch
	integration
Message-ID: <20091013222506.GA4952@nowhere>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com> <1253351338-5301-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253351338-5301-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 11:08:56AM +0200, Frederic Weisbecker wrote:
> Ingo, Heiko,
> 
> I've updated the patches following your reviews.
> Please tell me if you see another troubles.
> 
> The new tree can be pulled from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/syscalls-v2
> 
> Thanks,
> 	Frederic.


Ingo,

I wonder if you have forgotten this pull request, or if there is a
problem with it.

It's still cleanly mergeable into tip:/tracing/core.

Thanks.



 
> Frederic Weisbecker (2):
>       tracing: Move syscalls metadata handling from arch to core
>       tracing: Document HAVE_SYSCALL_TRACEPOINTS needs
> 
>  Documentation/trace/ftrace-design.txt |   13 ++++-
>  arch/s390/kernel/ftrace.c             |   67 +-------------------------
>  arch/x86/kernel/ftrace.c              |   76 +----------------------------
>  include/trace/syscall.h               |    2 +-
>  kernel/trace/trace_syscalls.c         |   86 +++++++++++++++++++++++++++++++++
>  5 files changed, 102 insertions(+), 142 deletions(-)

