Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbYJYVxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbYJYVxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYJYVxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:53:42 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33488 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYJYVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:53:41 -0400
X-Greylist: delayed 26256 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 17:53:41 EDT
Date: Sat, 25 Oct 2008 23:52:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-ID: <20081025215245.GA27572@uranus.ravnborg.org>
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au> <20081025143715.GB30900@uranus.ravnborg.org> <20081025211651.GA32027@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025211651.GA32027@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 02:16:51PM -0700, Greg KH wrote:
> On Sat, Oct 25, 2008 at 04:37:15PM +0200, Sam Ravnborg wrote:
> > > tests
> > > 
> > > 	Ananth N Mavinakayanahalli (7):
> > > 	      Add tests/ directory
> > > 	      Move locking selftests to tests/
> > > 	      Move rcutorture to tests/
> > > 	      Move rtmutex tester to tests/
> > > 	      Move lkdtm to tests/
> > > 	      Move kprobes smoke tests to tests/
> > > 	      Move backtrace selftests to tests/
> > 
> > I have almost given up on this.
> > Three merge attemps failed for different reasons,
> > and I will not even have time for my maintainership
> > duties the next months.
> > 
> > Anyone that can bring it forward?
> 
> What are the reasons this is failing?  Is it just moving different files
> around into the tests/ directory?  Or is it new functionality here?
> 
> If just moving stuff, is that really needed?

The incentive was to have a common place to add small tests that
could be used to verify that the kernel works as expected.
>From inkernel modules (like rcutorture) to small userspace
utilities such as something massaging the epoll interface or
similar.

The above was just to get it started.

Having a set of tests to run when introducing a new syscall
would make it much easier for an arch maintainer to verify
that the implemented syscall works as expected.

And forcing the developer to use the interface from user-space
will hopefully catch a few issues earlier.

	Sam
