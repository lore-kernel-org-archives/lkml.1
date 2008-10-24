Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYJXPDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYJXPDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbYJXPC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:02:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41984 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYJXPCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:02:55 -0400
Date: Fri, 24 Oct 2008 11:02:39 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock tracer
Message-ID: <20081024150239.GB20768@redhat.com>
References: <48F10B0B.406@gmail.com> <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com> <y0mmygv18le.fsf@ton.toronto.redhat.com> <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com> <20081024143744.GA20768@redhat.com> <alpine.DEB.1.10.0810241046300.3882@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810241046300.3882@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Oct 24, 2008 at 10:47:36AM -0400, Steven Rostedt wrote:
> [...]
> > > I would rather prefer to use an API that provides functions/objects
> > > for most common scripting languages.
> > 
> > That is an interesting idea.  One possible problem is that the final
> > complete script "program" needs to be translated to something that can
> > run quickly and safely inside the kernel.  Full python or perl runtime
> > + libraries would have been almost certainly unbearable.
>
> Why can't the userspace application convert the script to something
> easy that the kernel can handle?

That's what we do with the systemtap script, where kernel "handling"
consists of "running the machine code".

> But have the user application interface be very simple, and perhaps
> even use perl or python.

perl and python are pretty big procedural languages, and are not
easily compiled down to compact & quickly executed machine code.  (I
take it no one is suggesting including a perl or python VM in the
kernel.)  Plus, debugger-flavoured event-handling programming style
would not look nearly as compact in perl/python as in systemtap, which
is small and domain-specific.

- FChE
