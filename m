Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYJ2X53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYJ2X53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYJ2X5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:57:20 -0400
Received: from kroah.org ([198.145.64.141]:41062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753676AbYJ2X5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:57:19 -0400
Date: Wed, 29 Oct 2008 16:53:24 -0700
From: Greg KH <greg@kroah.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-ID: <20081029235324.GB23101@kroah.com>
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au> <20081025143715.GB30900@uranus.ravnborg.org> <20081025211651.GA32027@kroah.com> <20081025215245.GA27572@uranus.ravnborg.org> <20081025221015.GA32568@kroah.com> <20081028053435.GA3473@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028053435.GA3473@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 11:04:35AM +0530, Ananth N Mavinakayanahalli wrote:
> > Ok, that's great, but the current tree is just the in-kernel tests so
> > far, right?
> 
> Right

Ok, that makes more sense why it isn't going anywhere.

> > > Having a set of tests to run when introducing a new syscall
> > > would make it much easier for an arch maintainer to verify
> > > that the implemented syscall works as expected.
> > > 
> > > And forcing the developer to use the interface from user-space
> > > will hopefully catch a few issues earlier.
> > 
> > I totally agree that this is a good thing to have.
> > 
> > But I don't necessarily think that moving the in-kernel tests to this
> > directory makes that much sense here, wouldn't the in-kernel tests work
> > out better living next to the code they are testing, like they are right
> > now?   Or do you and others think that moving them would help things
> > out?
> 
> I guess at the time, the consensus was to collate all such tests (except
> the arch specific ones) to under tests/. But yes, there isn't too much
> difference in it living next to the actual code itself. The other neat
> thing this would do is to have one config sub-menu for all the in-kernel
> tests, which can still be done with a new Kconfig in lib/ or something.
> 
> > And are there any proposed userspace tests in this tree right now?
> 
> No, it is currently limited to kernel code.

Ok, I really don't care about moving files around.

What I do care about is the goal of having userspace tests, or tests
that people can run to test out the kernel in some kind of way, like
mentioned earlier in this thread.

If someone wants to start collecting them, I'll glady host that tree and
work to push that to mainline.

thanks,

greg k-h
