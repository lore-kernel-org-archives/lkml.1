Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYECO17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYECO17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYECO1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:27:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054AbYECO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:27:48 -0400
Date: Sat, 3 May 2008 07:27:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Requirements and process
Message-Id: <20080503072737.a6d8bb4b.akpm@linux-foundation.org>
In-Reply-To: <20080503174557.faf67525.sfr@canb.auug.org.au>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
	<20080502233519.a988b552.akpm@linux-foundation.org>
	<20080503174557.faf67525.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 17:45:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Fri, 2 May 2008 23:35:19 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Sat, 3 May 2008 15:45:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > The following architectures are not in linux-next (and should be):
> > > 
> > > alpha		cris		frv
> > > h8300		m32r		m68knommu
> > > mips		mn10300		parisc
> > > um		v850		xtensa
> > 
> > mips, m32r, parisc and xtensa do have git trees.  The rest are mastered as
> > discrete patches in -mm.
> 
> So, I was wondering if it would be worth while having subsections to a
> series file like:
> 
> # NEXT_PATCHES_START [<label> [<base>]]
> 
> # NEXT_PATCHES_END
> 
> With <label> sections being logically separate enough that we can talk
> about them/drop them/merge them at different places etc.
> 
> Or am I over engineering? :-)

That sounds good.  I once started to think about how to do this but
accidentally fell asleep.  I was thinking along the lines of the above,
only it drives an akpm script which spits out separate quilt (or git) trees
for linux-next.

The problem is that I then need to "drop" the patches so that I can merge
linux-next.  That's where I fell asleep.  I suppose that putting the
well-baked ones into a git tree and mastering them there solves the
problem.  But juggling 100-odd git branches on top of everything else
doesn't sound fun.

I need to think about this some more - it'll come.

What does "[<base>]" do?

