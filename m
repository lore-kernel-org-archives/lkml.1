Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbZILWK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbZILWK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 18:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZILWK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 18:10:26 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22518 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZILWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 18:10:26 -0400
Date: Sun, 13 Sep 2009 00:10:28 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86/xen for v2.6.32
In-Reply-To: <20090912071428.GC12702@elte.hu>
Message-ID: <alpine.LNX.2.00.0909130007580.23341@swampdragon.chaosbits.net>
References: <20090911200135.GA1426@elte.hu> <alpine.LNX.2.00.0909120000010.31018@swampdragon.chaosbits.net> <20090912071428.GC12702@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009, Ingo Molnar wrote:

> 
> * Jesper Juhl <jj@chaosbits.net> wrote:
> 
[...]
> > 
> > Why is this cast of 'va' needed?  As far as I can see, 'va' already has 
> > the correct type of "unsigned long".
> > Pointless casts do more harm than good, let's remove this one :-)
> > 
> > Sorry that all I could comment on was this trivial thing, but I thought it 
> > better to comment than keep silent now that I had read the patch and 
> > spotted it...
> 
> Yes, that cast could be removed.
> 
> Btw., i'd suggest that if you have trivial review feedback please 
> comment on the originating patches, in the original, finegrained 
> context, not the summary pull request. (Incidentally i did that too 
> there and the above patches did result in a few cleanups when they 
> were submitted.)
> 
> The reason is that the originating threads all have full changelogs 
> and have all the right people Cc:-ed in general - and by reviewing 
> them you will also influence the patches before they are sent to 
> Linus. The pull requests have Linus and the affected maintainers 
> Cc:-ed mainly. So for example you did not Cc: Jeremy to the x86/fpu 
> pull request comments you did so he had no chance to comment on them 
> unless he happened to run across your comments on lkml.
> 
> Bug/crash reports and serious gotcha feedback can go to the pull 
> requests too just fine - but even then, if you know what the 
> originating commit is, try to include the people who originated the 
> commit. (And feel free to Cc: Linus to that trivial feedback if you 
> think it's important enough.)
> 

You are making a lot of sense Ingo. I'll try to remember that.


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

