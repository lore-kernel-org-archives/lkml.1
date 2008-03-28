Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYC1RhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYC1RhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYC1RhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:37:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41444 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbYC1Rg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:36:59 -0400
Date: Fri, 28 Mar 2008 19:36:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Message-ID: <20080328173642.GG32200@cs181133002.pp.htv.fi>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <200803281710.44576.rjw@sisk.pl> <alpine.LFD.1.00.0803280938430.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803280938430.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 09:47:47AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 28 Mar 2008, Rafael J. Wysocki wrote:
> > > 
> > > Also, Rafael - do these reminder emails also go to the people who are 
> > > mentioned in the regressions (especially people who are set up as being 
> > > "handled-by" or having patches for the problem)? 
> > 
> > No, they don't.  I need to do some scriptwork to make that happen.
> 
> It would be good. Right now I know for a fact that a lot of people read 
> LKML with various filters in place (or just very spottily), so I have a 
> feeling that while people try to track regressions, many people are 
> probably less aware of these things than they should be. And sometimes the 
> "handled-by" ends up being inaccurate (maybe somebody replied to the 
> original problem, but it became obvious that it was somewhere else, and 
> they remain "handled-by" even though the person doesn't actually handle 
> it).
> 
> It would probably also make sense to add some of the bigger subsystem 
> maintainers to the Cc (and/or with a mailing list for regressions?)
>...

When I tracked regressions I also Cc'ed all submitters, maintainers of 
all affected subsystems, and the people who said they'd handle the 
reports.

The problem I ran into was vger dropping emails with >= 30 recipients, 
which meant that I had to split the regression list into half a dozen 
emails (splitted by the area of the regressions) when I tracked at about
30 regressions.

But that was one year ago when we had only half as many regressions per 
release as they do now, with 2.6.25 we had a peak of 66 pending 
regressions...

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

