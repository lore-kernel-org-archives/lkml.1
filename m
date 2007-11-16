Return-Path: <linux-kernel-owner+w=401wt.eu-S1763712AbXKPSUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763712AbXKPSUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXKPSUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:20:21 -0500
Received: from iabervon.org ([66.92.72.58]:55523 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761875AbXKPSUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:20:18 -0500
Date: Fri, 16 Nov 2007 13:20:16 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Romano Giannetti <romanol@upcomillas.es>
cc: Theodore Tso <tytso@mit.edu>, Benoit Boissinot <bboissin@gmail.com>,
       Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <1195201202.13688.10.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711161303440.12193@iabervon.org>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> 
 <20071113.033946.114918709.davem@davemloft.net> 
 <20071113034916.2556edd7.akpm@linux-foundation.org> 
 <20071113.035824.40509981.davem@davemloft.net>  <20071113041259.79c9a8c5.akpm@linux-foundation.org>
  <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> 
 <40f323d00711130752k19cab8eauc3456721274b3267@mail.gmail.com> 
 <20071113171356.GA25824@thunk.org>  <Pine.LNX.4.64.0711141810110.12193@iabervon.org>
  <20071115153057.GE17180@thunk.org>  <Pine.LNX.4.64.0711151034340.12193@iabervon.org>
 <1195201202.13688.10.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Romano Giannetti wrote:

> 
> (Cc: trimmed a bit).
> 
> On Thu, 2007-11-15 at 11:19 -0500, Daniel Barkalow wrote:
> > On Thu, 15 Nov 2007, Theodore Tso wrote:
> [...]
> > > A full kernel build with everything selected can take good 30 minutes or 
> > > more, and that's on a fast dual-core machine with 4gigs of memory and 
> > > 7200rpm disk drives. On a slower, memory limited laptop, doing a single 
> > > kernel build can take more time than the user has patiences; multiply 
> > > that by 7 or 8 build and test boots, and it starts to get tiresome.
> > 
> > None of this is going to take as long, 
> 
> Well, the compile phase can. Especially if the first time you try to
> compile the kernel with EXTRAVERSION=`git describe` which force almost a
> full rebuild every time...

Compared to getting useful suggestions from a mailing list, especially 
before you've gotten anybody's attention? Hours or overnight isn't 
particularly long, and doesn't take up much of your time if you've got a 
working kernel to use while it's working.

> But the worst problem is that a full recompile, with a distro .config,
> will take hours on my 2.66GHz/CoreDuo/1G ram. Trimming down .config is
> fundamental to be able to bisect effectively, but it's not an easy thing
> to do for an unexperienced user (and a painful one for all the rest of
> us). 
> 
> What would be an invaluable help would be a tool that generates
> a .config with all the modules and subsystems I am using *now*. Should
> be possible in principle by parsing KConfig and Makefiles and using as
> input the current .config and lsmod... is it possible to map the kernel
> object name to the option enabling it?

I don't think there's anything set up for that, aside from the actual 
build system generating it, and I don't know how hard that would be to 
repurpose for generating a configuration.

	-Daniel
*This .sig left intentionally blank*
