Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYLLDkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYLLDkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYLLDj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:39:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbYLLDjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:39:55 -0500
Date: Thu, 11 Dec 2008 19:39:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-Id: <20081211193927.2aa5ca83.akpm@linux-foundation.org>
In-Reply-To: <200812121407.02599.nickpiggin@yahoo.com.au>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	<200812111945.53399.nickpiggin@yahoo.com.au>
	<20081211190225.0de48422.akpm@linux-foundation.org>
	<200812121407.02599.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 13:07:02 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Friday 12 December 2008 14:02, Andrew Morton wrote:
> > On Thu, 11 Dec 2008 19:45:53 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
> > > > > I still have one fix for a reported regression (softlink code doesn't
> > > > > honour GFP_NOFS, caused by a patch of mine). Posted a couple of weeks
> > > > > ago, but it didn't get anywhere.
> > > >
> > > > I don't have a clue what you're talking about.
> > > >
> > > > <greps the tree>
> > > >
> > > > ./fs/affs/inode.c:      case ST_SOFTLINK:
> > > > ./fs/affs/namei.c:      error = affs_add_entry(dir, inode, dentry,
> > > > ST_SOFTLINK); ./include/linux/amigaffs.h:#define ST_SOFTLINK  3
> > > >
> > > > really?
> > >
> > > Oh, I thought I cc'ed you...
> > >
> > > http://marc.info/?l=linux-fsdevel&m=122777850302085&w=2
> > > http://marc.info/?l=linux-fsdevel&m=122777852502093&w=2
> >
> > yes, but that stuff went round and round in circles and ended up all in
> > the air.
> 
> Hmm, OK. I think we ended up agreeing after some review and things
> fixed since my original posting.
> 
> But it was an honest question -- is this too late to go in 2.6.28,
> given that it has been present in earlier releases too? Maybe if the
> release date is pushed to after Christmas, then there is enough time.
> Otherwise, perhaps it should go upstream afterwards, then filter into
> -stable?

Well we could do either.

But it's not completely obvious what the actual bug is.  Deadlock? 
Suboptimal memory allocation mode?  Arbitrary stack windup?  Other?

> Anyway, I'll repost them, in case you'd care to put them in -mm in
> the meantime.

Sure..
