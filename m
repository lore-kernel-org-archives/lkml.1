Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZHFNrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZHFNrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZHFNri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:47:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZHFNri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:47:38 -0400
Date: Thu, 6 Aug 2009 09:47:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       acme <acme@redhat.com>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: malloc() tracing in perf?
In-Reply-To: <1249563574.32113.358.camel@twins>
Message-ID: <alpine.DEB.2.00.0908060945050.9870@gandalf.stny.rr.com>
References: <4A7A8ADD.4080208@cs.helsinki.fi>  <1249546610.32113.35.camel@twins> <20090806112059.GD18768@redhat.com>  <1249558094.32113.242.camel@twins>  <20090806115527.GE18768@redhat.com> <1249563574.32113.358.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Aug 2009, Peter Zijlstra wrote:

> On Thu, 2009-08-06 at 07:55 -0400, Frank Ch. Eigler wrote:
> > Hi -
> > 
> > On Thu, Aug 06, 2009 at 01:28:14PM +0200, Peter Zijlstra wrote:
> > > [...]
> > > > That work is ongoing, and being discussed on utrace-devel@redhat.com,
> > > > since it is a prerequisite. 
> > > 
> > > Still hiding the discussion and the design never helped anybody.
> > 
> > I guess "hiding" is a matter of opinion.
> 
> Yeah in plain sight where nobody looks, really I thought the idea was to
> get utrace upstream, this means posting to linux-kernel. Going on LKML
> posts I'd say the utrace project was dead. Same goes for uprobe.
> 
> I've told this before and I'll say it again, post to LKML.

I second this. _Any_ kernel development that is new must be discussed on 
LKML. Sure, you can do the initial prototypes on a smaller mailing list, 
but once you have that prototype ready, it should go to LKML. This was the 
problem with Xen. The -rt patch was developed on LKML and even though 
there's a lot more to get in, a lot already has. The reason is that all 
development was done on the kernel mailing list.

-- Steve
