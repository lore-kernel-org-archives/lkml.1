Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbXH3ORx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbXH3ORx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbXH3ORq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:17:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42690 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756921AbXH3ORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:17:46 -0400
Date: Thu, 30 Aug 2007 16:17:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Designers and Builders (was: Who wants to maintain KR list for
	stable releases?)
Message-ID: <20070830141746.GC9260@stusta.de>
References: <200708300731.24413.a1426z@gawab.com> <20070830073226.GA9260@stusta.de> <200708301654.24516.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200708301654.24516.a1426z@gawab.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 04:54:24PM +0300, Al Boldi wrote:
> Adrian Bunk wrote:
> > On Thu, Aug 30, 2007 at 07:31:24AM +0300, Al Boldi wrote:
> > > Adrian Bunk wrote
> > >
> > > > Tracking feature or implementation suggestions wouldn't make sense.
> > > > Consider e.g. that there are several people on linux-kernel who often
> > > > write what they think the kernel should do but who never write a
> > > > single line of code themselves. There's no value in tracking such
> > > > stuff.
> > >
> > > There are designers, and there are builders.
> > >
> > > Can you tell me who is more important?
> >
> > That's a distinction that doesn't exist in practice:
> >
> > Designing kernel features requires good knowledge of the area of the
> > kernel that should be changed.
> >
> > IOW: If you don't have the skills to implement it yourself you don't
> > have the skills to do any good design.
> 
> I might agree with you on this wrt hacking around the kernel, but when it 
> comes to introducing new subsystems, then we have a two fold situation:
> 
>   1.  Designing the internals of the new subsystem
>   2.  Interfacing it with the rest of the kernel
> 
> Part 1 is completely independent of the implementation, it's part 2 that 
> needs intricate implementation knowledge.

That's a perfect approach that works NOT.

Your subsystem needs to interact with the VFS or the block layer or 
whatever else parts of the kernel.

If you had ever written kernel code you would have known that your 
statement wasn't true.

> We recently had an example of this:  kexec based hibernation
> 
> So, what's wrong with tapping into people's design suggestions, and allowing 
> others to implement it?

People soon realize that you are making a fool of yourself when your 
suggestions show that you don't have a clue what you are talking about.

There's nothing wrong if this is the desired effect...

> Thanks!
> Al

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

