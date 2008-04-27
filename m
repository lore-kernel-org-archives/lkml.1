Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbYD0MIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbYD0MIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYD0MIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:08:34 -0400
Received: from tim.rpsys.net ([194.106.48.114]:49583 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbYD0MId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:08:33 -0400
Subject: Re: If you want me to quit I will quit
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Bunk <bunk@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080426133049.187e255c.akpm@linux-foundation.org>
References: <1209190455.14173.13.camel@brick>
	 <20080426110044.GB2252@cs181133002.pp.htv.fi>
	 <20080426075132.b0fdbe13.akpm@linux-foundation.org>
	 <20080426152341.GI2252@cs181133002.pp.htv.fi>
	 <20080426084420.8e61c379.akpm@linux-foundation.org>
	 <20080426171604.GN2252@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
	 <481379BB.5050208@s5r6.in-berlin.de>
	 <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org>
	 <20080426133049.187e255c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 13:07:35 +0100
Message-Id: <1209298055.1475.0.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 13:30 -0700, Andrew Morton wrote:
> On Sat, 26 Apr 2008 12:18:34 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > So it's an important part of the process to try to do a good job, and not 
> > publicizing crap - but it's *equally* important to realize that crap 
> > happens, and that it's easily *more* distracting to try to clean it up 
> > after-the-fact than it is to just admit that it happened.
> > 
> 
> Often it takes quite a long time for problems to become apparent.  Across a
> month or two we end up with things like:
> 
> mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
> mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
> mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
> mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
> 
> and
> 
> mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
> mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
> mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
> mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
> 
> that's two patches, each with three followon fixes.  Very common.
> 
> Fact is, this is the way in which developers want to work.  That is their
> workflow, and their tools should follow their workflow.  If a tool's
> behaviour prevents them from implementing their desired workflow, it isn't
> the workflow which should be changed ;)

Its worth realising that these fix patches contain useful information
too, e.g. they might be by different authors and its also interesting in
some senses to see what fixes were applied to the original patch, why
etc. since it is history and that is what the SCM effectively stores.

This is also happens on larger timescales, a commit goes into some tree,
some regression is found, some future commit fixes that regression,
sometimes over a kernel release or two or more.

My point is that this information can actually be useful and trying to
prune it all out the main tree for aesthetic reasons might not
necessarily be the right thing to do. I agree it can be distracting and
perhaps what we need are tools that can show or hide this kind of
information as an option.

Consider that -stable tree and that if commits were somehow marked as
regression fixes for previous commits, you could run some command and
get a list of regression fixes. I'm a realist and appreciate such output
would need careful manual/human consideration but it would have a real
world use.

On the other hand I agree that the patches in -mm often have stupid
typos etc which aren't interesting in the history but where do you draw
the line?

Cheers,

Richard


