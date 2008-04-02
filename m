Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYDBDEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYDBDEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 23:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYDBDEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 23:04:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbYDBDEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 23:04:22 -0400
Date: Tue, 1 Apr 2008 20:03:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
In-Reply-To: <20080402112355.c86d9eda.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.1.00.0804011948010.14670@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org> <20080402112355.c86d9eda.sfr@canb.auug.org.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Stephen Rothwell wrote:
> 
> The downside is that at least some of these were already pending in
> maintainers trees for 2.6.26 (among other changes) and so have now caused
> (unnecessary) merge conflicts.  Is there some reason that these fixes
> can't go through the subsystem trees (especially once we get past rc1 (or
> 2) and people are gearing up for the next merge window)?

I don't think it's necessarily a bad idea to go through subsystem trees, 
but on the other hand I also don't think it should necessarily be a goal 
in itself.

For example, we had a patch-series from Roland McGrath that was apparently 
almost entirely based on the fact that going through (and getting 
sign-off) from all the architecture maintainers for his ptrace changes was 
just painful as hell for him.

At that point, when there is somebody like Roland who knows the rare and 
odd ptrace interfaces, having him jump through hoops just to go through 
"proper channels" is in my opinion just anti-productive (especially since 
I also think the "political" aspect of the problem causes the actual 
technical side of the patches to suffer - because they are more about 
the politics than about the technology).

So at some point, subsystem mainteinance should also be about picking up 
and handling the changes that come the other way. The kernel development 
isn't a strict hierarchy, and shouldn't be - it's more of a network of 
trust.

In other words, there are people I think are generally trusted across most 
maintenance borders. Al, as far as I'm concerned, is one of them.  
Especially sicne he is also one of the few people who clearly not only 
does run sparse but also looks at the code and actually fixes real bugs 
with byte order etc - regardless of where it is (ie he works across 
drivers, filesystems, an arch-specific code)

In other words, I don't think the borders are so tightly drawn, and the 
same way I trust the individual developers who send me patches (and git 
trees) rather than whatever _companies_ they happen to work, I also tend 
to trust individual developers rather than the _subsystem_ that they 
happen to maintain.

Of course, there's often a rather direct mapping between the two, where 
people naturally have the area they work in. But some people cross across 
any particular area, and while that tends to be unusual, that very much 
includes people like Andrew and Al.

In other words, at least to me it's not about "person X maintains file Y". 
It's much more about "I trust person X (perhaps within parameters Z)". And 
I don't think that's even unusual or even really unexpected.

And I think that's how we all work (and how we _should_ work), but 
sometimes people get so used to the fact that some people are fairly 
tightly associated with certain code that they think it's about the 
subsystem, not about the person.

			Linus
