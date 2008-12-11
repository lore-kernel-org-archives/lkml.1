Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbYLKIIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbYLKIIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYLKIIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:08:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbYLKIIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:08:00 -0500
Date: Thu, 11 Dec 2008 00:07:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-Id: <20081211000730.2e0334d0.akpm@linux-foundation.org>
In-Reply-To: <200812111857.36862.nickpiggin@yahoo.com.au>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	<200812111857.36862.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 18:57:36 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Thursday 11 December 2008 12:04, Linus Torvalds wrote:
> > Nothing overly exciting here. Lots of small things, mostly in drivers
> > (with some defconfig updates for m68k and mips making the diffs bigger).
> >
> > There's some uncomfortably big changes to the intel DRI code, but most of
> > that is all about fixes to the new i916 "GEM" code that is only used by
> > development X servers, and is a new feature, so it shouldn't be able to
> > cause regressions.
> >
> > Perhaps more interesting is simply the release scheduling issue. I'm
> > getting slowly ready to do a real 2.6.28, but I don't think anybody really
> > wants the merge window to be around the holidays. So the question is
> > really whether to
> >
> >  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> >
> >      I like this, because alledgely people are debugging things, and we'd
> >      get a more stable 2.6.28.
> 
> I still have one fix for a reported regression (softlink code doesn't
> honour GFP_NOFS, caused by a patch of mine). Posted a couple of weeks
> ago, but it didn't get anywhere.

I don't have a clue what you're talking about.

<greps the tree>

./fs/affs/inode.c:      case ST_SOFTLINK:
./fs/affs/namei.c:      error = affs_add_entry(dir, inode, dentry, ST_SOFTLINK);
./include/linux/amigaffs.h:#define ST_SOFTLINK  3

really?

