Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZJNH3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZJNH3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZJNH27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:28:59 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:35189 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbZJNH26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:28:58 -0400
Date: Wed, 14 Oct 2009 09:28:20 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [GIT PULL v2] tracing/syscalls: Arch code shrinks, easier arch
 integration
Message-ID: <20091014072820.GA13388@osiris.boeblingen.de.ibm.com>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com>
 <1253351338-5301-1-git-send-email-fweisbec@gmail.com>
 <20091013222506.GA4952@nowhere>
 <20091014061840.GC784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014061840.GC784@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 08:18:40AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sat, Sep 19, 2009 at 11:08:56AM +0200, Frederic Weisbecker wrote:
> > > Ingo, Heiko,
> > > 
> > > I've updated the patches following your reviews.
> > > Please tell me if you see another troubles.
> > > 
> > > The new tree can be pulled from:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	tracing/syscalls-v2
> > Ingo,
> > 
> > I wonder if you have forgotten this pull request, or if there is a
> > problem with it.
> > 
> > It's still cleanly mergeable into tip:/tracing/core.
> > > Frederic Weisbecker (2):
> > >       tracing: Move syscalls metadata handling from arch to core
> > >       tracing: Document HAVE_SYSCALL_TRACEPOINTS needs
> > > 
> > >  Documentation/trace/ftrace-design.txt |   13 ++++-
> > >  arch/s390/kernel/ftrace.c             |   67 +-------------------------
> 
> I skipped it because the s390 bit needs the ack of at least one of these 
> gents:
> 
>  S390
>  M:      Martin Schwidefsky <schwidefsky@de.ibm.com>
>  M:      Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
