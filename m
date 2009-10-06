Return-Path: <linux-kernel-owner+w=401wt.eu-S933724AbZJFWoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbZJFWoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933449AbZJFWoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:44:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:31103 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354AbZJFWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h1Rz7l+tHtXixSD1W/1tAh72vUfm2Rf7oteYqN/nrzJRaDw04uUkwGMg8RLnSL2o6s
         f+11SRkEpBJPHgdyC35Q697xcEutXGFBzK2aDBAPw/sU589pfo8iUABOAmFdiWXP6G9n
         ZEpmJ6O6jS2NC13R/IrCDYyJMkK5Ns66BRrkA=
Date: Wed, 7 Oct 2009 00:42:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
Message-ID: <20091006224250.GB11007@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <4ACA25D5.10703@redhat.com> <20091005192609.GB6071@nowhere> <1254787973.13160.195.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254787973.13160.195.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 08:12:53PM -0400, Steven Rostedt wrote:
> On Mon, 2009-10-05 at 21:26 +0200, Frederic Weisbecker wrote:
> > On Mon, Oct 05, 2009 at 12:59:01PM -0400, Masami Hiramatsu wrote:
> > > As far as I can see in arch/*/include/asm/ptrace.h, all registers start with
> > > alphabets :-). So, I'd like to suggest renaming sp-vars to '_sp-vars'.
> > >
> > > Then, we will have;
> > > - $local-vars
> > 
> > 
> > There is a risk of bash collision.
> 
> I actually prefer the "$" notation. As for bash collision, it is common
> for shell script writers to be able to distinguish a variable from bash.
> Yes we can backslash it, or quote it. But when I see a $var it sticks
> out to me that it is a variable. It's not hard to get around. For
> example, type:
> 
> $ echo "hello $DISPLAY"' or $DISPLAY'
> 
> and see what you get.
> 
> Makefiles and Perl use '$' for variables those that need to handle it
> with bash can easily cope with it.
> 
> So my vote is to keep the '$'. It is the most intuitive to what it
> means.


Hrrmm...

I fear about future complains, but I may be somehow biased in
that my usual usecases of bash don't involve '$' characters to
protect, so it's not something I'm used to.

Whatever choice we make, there are either downsides in the prefix
self meaning, the collisions or the shell intrpretation.

Now you are two who prefer that, let's pick this one :)


