Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZBRAjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZBRAjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZBRAjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:39:36 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:34847 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZBRAjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:39:35 -0500
Date: Wed, 18 Feb 2009 01:41:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/15] [git pull] for tip/tracing/ftrace
Message-ID: <20090218004127.GB30812@uranus.ravnborg.org>
References: <20090217051227.957864159@goodmis.org> <20090217104213.GC6602@elte.hu> <alpine.DEB.1.10.0902170747160.910@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902170747160.910@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 07:49:49AM -0500, Steven Rostedt wrote:
> 
> On Tue, 17 Feb 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > This is a patch series that offers a variety of features.
> > > 
> > > The first is to add:
> > > 
> > >  #### all functions enabled ####
> > > 
> > > to set_ftrace_filter when all functions will be traced when function
> > > tracing is on.
> > > 
> > > The next is to add a :command: interface, and the module command:
> > > 
> > >  echo '*:mod:ext4' > set_ftrace_filter
> > > 
> > > Will select all functions in the ext4 module.
> > > 
> > >  echo '!*write*:mod:ext4' > set_ftrace_filter
> > > 
> > > will remove all functions with the characters 'write' and are
> > > in ext4.
> > 
> > Very nice feature!
> > 
> > I'm wondering, would it be possible to somehow extend this to 
> > built-in drivers too, so that we get symmetry of usage 
> > independently of whether something is built in or a module? I 
> > suspect it needs some extensions to kbuild though ...
> 
> Yeah, that may needs some kbuild magic.

I have not followed this thread.
What kind of magic do you have in mind?

	Sam
