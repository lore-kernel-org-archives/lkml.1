Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZBFPd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZBFPd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZBFPds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:33:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:60477 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZBFPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qRM7d60LdDl4KU1fFNqczAEd3dZqTrCaqSqAqAVO7NDHe3K7wFUC/A98nAmFea0dij
         X7glUXNXzZlLwoYlsqdba4kn19CIfMkq8MIsT5pC03aEgZPtYb4MbLrqNYKNyM217+Fq
         QjvYFu49uEEwLe1LWihkAZNmamccgr1cnWtFg=
Date: Fri, 6 Feb 2009 16:33:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
Message-ID: <20090206153340.GA5033@nowhere>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <1233912891.4731.1.camel@laptop> <20090206144609.GB18368@elte.hu> <alpine.DEB.1.10.0902060950250.10059@gandalf.stny.rr.com> <20090206145431.GG18368@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206145431.GG18368@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 03:54:31PM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 6 Feb 2009, Ingo Molnar wrote:
> > 
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Fri, 2009-02-06 at 01:53 -0500, Steven Rostedt wrote:
> > > > 
> > > > > This code adds an in_nmi() macro that uses the current tasks preempt count
> > > > > to track when it is in NMI context. Other parts of the kernel can
> > > > > use this to determine if the context is in NMI context or not.
> > > > > 
> > > > > This code was inspired by the -rt patch in_nmi version that was
> > > > > written by Peter Zijlstra.
> > > > 
> > > > Which in turn I borrowed from Mathieu.
> > > 
> > > Steve, could you please fix the attribution?
> > 
> > Is it OK to rebase the branch to do so?
> 
> Sure, that's necessary.
> 
> And note that unless you base your tree against tip:tracing/ftrace i cannot 
> do a straight pull anyway. (your trees are usually based against tip:master 
> - which brings in all other branches)


Oh really? I always base my tracing patches against tip/master, assuming
tracing/ftrace is about always quickly merged into master.
But the opposite is not necessarily true, I guess you don't merge master
into tracing/ftrace so quickly to not break the history right? And I guess
it's better to catch bugs if each individual topics is not too quickly synced
against tip/master.

 
> 	Ingo

