Return-Path: <linux-kernel-owner+w=401wt.eu-S1762473AbZANNRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473AbZANNRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZANNQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:16:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50369 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZANNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:16:53 -0500
Date: Wed, 14 Jan 2009 08:16:50 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Joe Perches <joe@perches.com>
cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] MAINTAINERS - Add FTRACE git
In-Reply-To: <1231913987.30095.11.camel@localhost>
Message-ID: <alpine.DEB.1.10.0901140811530.6759@gandalf.stny.rr.com>
References: <1231878498-25171-1-git-send-email-joe@perches.com>  <1231878498-25171-9-git-send-email-joe@perches.com>  <20090114055954.GA7039@linux-sh.org> <1231913987.30095.11.camel@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 13 Jan 2009, Joe Perches wrote:

> On Wed, 2009-01-14 at 14:59 +0900, Paul Mundt wrote:
> > On Tue, Jan 13, 2009 at 12:28:16PM -0800, Joe Perches wrote:
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > >  MAINTAINERS |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index ceeeb8c..6e051c3 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -2189,6 +2189,7 @@ F:	fs/freevxfs/
> > >  FTRACE
> > >  P:	Steven Rostedt
> > >  M:	rostedt@goodmis.org
> > > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
> > >  S:	Maintained
> > >  F:	Documentation/ftrace.txt
> > >  F:	arch/*/*/*/ftrace.h
> > 
> > This sort of thing only makes sense if you include the topic branch for
> > the tree in question. While it is true that ftrace development happens in
> > this tree, people looking at ftrace may not want to sort through the
> > hundreds of unrelated topic branches in the process. I say this as
> > someone that does not want to sort through hundreds of unrelated topic
> > branches in search of ftrace code ;-)
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=heads
> 
> Is the correct topic branch for ftrace auto-ftrace-next?

That is just a location that Ingo places changes that are ready to go to 
linux-next. Not where development is.

> 
> maybe:
> 
> T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git auto-ftrace-next
> 
> No idea what's right here.  I had some private emails
> with Steven Rostedt about a git tree.  He suggested
> to use tip.
> 
> Steven?  Suggestions?

Ingo usually pulls ftrace related patches into the tracing/ftrace 
branch. That is for core ftrace. Since ftrace has a bunch of pluggins, 
they may have their own branches.

But to answer Paul's question, I would suggest tracing/ftrace for 
seeing latest core ftrace changes.

Should we add another topic in MAINTAINERS? The "TRACE RING BUFFER"? or 
just call it ring_buffer? This is separate from ftrace, although ftrace 
uses it for on the fly tracing. I maintain it and it is located in the tip 
git repo under tracing/ring-buffer.

-- Steve

