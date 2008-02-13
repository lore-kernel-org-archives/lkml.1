Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbYBMRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbYBMRyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762565AbYBMRyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:54:10 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35385 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbYBMRyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:54:08 -0500
Date: Wed, 13 Feb 2008 19:53:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213175349.GB14269@cs181133002.pp.htv.fi>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:09:34AM -0800, Linus Torvalds wrote:
>...
> The other is that once somebody says "ok, I *really* need to cause this 
> breakage, because there's a major bug or we need it for fundamental reason 
> XYZ", then that person should
> 
>  (a) create a base tree with _just_ that fundamental infrastructure change,
>      and make sure that base branch is so obviously good that there is no 
>      question about merging it.
> 
>  (b) tell other people about the reason for the infrastructure change, and 
>      simply allow others to merge it. You don't have to wait for *me* to 
>      open the merge window, you need to make sure that the people that get 
>      impacted most can continue development!
> 
> This is where "rebases really are bad" comes in. When the above sequence 
> happens, the fundamental infrastructure change obviously does need to be 
> solid and not shifting under from other people who end up merging it. I do 
> not want to see five different copies of the fundamental change either 
> because the original source fixed it up and rebased it, or because the 
> people who merged it rebased _their_ trees and rebased the fundamental 
> change in the process.
> 
> Can that (b) be my tree? Sure. That's been the common case, and I'll 
> happily continue it, of course, so I'm not arguing for that to go away. 
> Merging is my job, I'll do it. But when the merge window is a problem, my 
> merge window should *not* hold up people from using the distributed nature 
> of git for their advantage.
> 
> But yes, obviously when doing cross-merges, you'd better be really 
> *really* sure that the base is solid and will get merged. But let's face 
> it, all the really core maintainers should damn well know that by now: 
> you've all worked with me for years, so you should be able to trivially be 
> able to tell whether you *might* need to worry about something, and when 
> it's a slam dunk.
> 
> And it's the "it's a slam dunk" cases that I think are (a) the common ones 
> and (b) the ones where you can just do cross-merges to satisfy each others 
> needs.
> 
> Hmm? Does that sound palatable to people?

I'm sure I understand only less than half of what you said.

My current understanding is that all the aspects of your proposal that  
are interesting for me can be summarized as follows:
- your tree stops compiling at the beginning of the merge window when 
  you merge the first subsystem tree
- your tree might compile again at the end of the merge window when you
  merge the last subsystem tree 
- git-bisect -> /dev/null

What do I miss?

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

