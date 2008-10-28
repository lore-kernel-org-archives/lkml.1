Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbYJ1FfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbYJ1FfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYJ1FfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:35:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33610 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYJ1FfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:35:07 -0400
Date: Tue, 28 Oct 2008 11:04:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-ID: <20081028053435.GA3473@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au> <20081025143715.GB30900@uranus.ravnborg.org> <20081025211651.GA32027@kroah.com> <20081025215245.GA27572@uranus.ravnborg.org> <20081025221015.GA32568@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025221015.GA32568@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 03:10:15PM -0700, Greg KH wrote:
> On Sat, Oct 25, 2008 at 11:52:45PM +0200, Sam Ravnborg wrote:
> > On Sat, Oct 25, 2008 at 02:16:51PM -0700, Greg KH wrote:
> > > On Sat, Oct 25, 2008 at 04:37:15PM +0200, Sam Ravnborg wrote:
> > > > > tests
> > > > > 
> > > > > 	Ananth N Mavinakayanahalli (7):
> > > > > 	      Add tests/ directory
> > > > > 	      Move locking selftests to tests/
> > > > > 	      Move rcutorture to tests/
> > > > > 	      Move rtmutex tester to tests/
> > > > > 	      Move lkdtm to tests/
> > > > > 	      Move kprobes smoke tests to tests/
> > > > > 	      Move backtrace selftests to tests/
> > > > 
> > > > I have almost given up on this.
> > > > Three merge attemps failed for different reasons,
> > > > and I will not even have time for my maintainership
> > > > duties the next months.
> > > > 
> > > > Anyone that can bring it forward?
> > > 
> > > What are the reasons this is failing?  Is it just moving different files
> > > around into the tests/ directory?  Or is it new functionality here?
> > > 
> > > If just moving stuff, is that really needed?
> > 
> > The incentive was to have a common place to add small tests that
> > could be used to verify that the kernel works as expected.
> > From inkernel modules (like rcutorture) to small userspace
> > utilities such as something massaging the epoll interface or
> > similar.
> > 
> > The above was just to get it started.
> 
> Ok, that's great, but the current tree is just the in-kernel tests so
> far, right?

Right

> > Having a set of tests to run when introducing a new syscall
> > would make it much easier for an arch maintainer to verify
> > that the implemented syscall works as expected.
> > 
> > And forcing the developer to use the interface from user-space
> > will hopefully catch a few issues earlier.
> 
> I totally agree that this is a good thing to have.
> 
> But I don't necessarily think that moving the in-kernel tests to this
> directory makes that much sense here, wouldn't the in-kernel tests work
> out better living next to the code they are testing, like they are right
> now?   Or do you and others think that moving them would help things
> out?

I guess at the time, the consensus was to collate all such tests (except
the arch specific ones) to under tests/. But yes, there isn't too much
difference in it living next to the actual code itself. The other neat
thing this would do is to have one config sub-menu for all the in-kernel
tests, which can still be done with a new Kconfig in lib/ or something.

> And are there any proposed userspace tests in this tree right now?

No, it is currently limited to kernel code.

Ananth
