Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZJNGTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZJNGTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZJNGTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:19:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZJNGTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:19:33 -0400
Date: Wed, 14 Oct 2009 08:18:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [GIT PULL v2] tracing/syscalls: Arch code shrinks, easier arch
	integration
Message-ID: <20091014061840.GC784@elte.hu>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com> <1253351338-5301-1-git-send-email-fweisbec@gmail.com> <20091013222506.GA4952@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013222506.GA4952@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sat, Sep 19, 2009 at 11:08:56AM +0200, Frederic Weisbecker wrote:
> > Ingo, Heiko,
> > 
> > I've updated the patches following your reviews.
> > Please tell me if you see another troubles.
> > 
> > The new tree can be pulled from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/syscalls-v2
> > 
> > Thanks,
> > 	Frederic.
> 
> 
> Ingo,
> 
> I wonder if you have forgotten this pull request, or if there is a
> problem with it.
> 
> It's still cleanly mergeable into tip:/tracing/core.
> 
> Thanks.
> 
> 
> 
>  
> > Frederic Weisbecker (2):
> >       tracing: Move syscalls metadata handling from arch to core
> >       tracing: Document HAVE_SYSCALL_TRACEPOINTS needs
> > 
> >  Documentation/trace/ftrace-design.txt |   13 ++++-
> >  arch/s390/kernel/ftrace.c             |   67 +-------------------------

I skipped it because the s390 bit needs the ack of at least one of these 
gents:

 S390
 M:      Martin Schwidefsky <schwidefsky@de.ibm.com>
 M:      Heiko Carstens <heiko.carstens@de.ibm.com>

Thanks,

	Ingo
