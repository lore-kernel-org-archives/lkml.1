Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbYDZRg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbYDZRg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYDZRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:36:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbYDZRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:36:21 -0400
Date: Sat, 26 Apr 2008 10:35:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <20080426172748.GP2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804261032150.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org>
 <20080426171604.GN2252@cs181133002.pp.htv.fi> <20080426102024.4c65624d.akpm@linux-foundation.org> <20080426172748.GP2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Adrian Bunk wrote:

> On Sat, Apr 26, 2008 at 10:20:24AM -0700, Andrew Morton wrote:
> > 
> > I expect that means "don't alter stuff after you've sent the pull request".
> > That'd be fairly dumb.
> > 
> > But during the two-month -rcX timeframe the patches in the git and quilt
> > trees get altered, dropped, reordered regularly.  Some of the git trees
> > don't really exist, I believe - their owners assemble them from a
> > quilt-based master tree for external sharing only.
> 
> As far as I understand it, changes in Daves tree would cause problems 
> for people like Jeff Garzik and John Linville who themselves base their 
> work on Daves tree during the two-month -rcX timeframe.

Yes. It really depends on how people use those trees.

For trees that are *only* used for basically throw-away single-use testing 
(ie -mm and -next, both of which will always re-build the whole tree each 
time), changing a published tree doesn't matter at all, or matters very 
little.

But once you get real people, rather than automation, that actually want 
to do development on top of a git tree, then rebuilding that tree is 
really really annoying for those users. 

So the networking tree, where you have other maintainers that are also git 
users, really shouldn't be rebuilt, because that messes with developers. 

Many other git trees are really more of a "private development trees that 
are exposed to -mm and -next to get some wider testing".

				Linus
