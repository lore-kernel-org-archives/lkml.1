Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbYJJQ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbYJJQ2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbYJJQ2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:28:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758508AbYJJQ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:28:43 -0400
Date: Fri, 10 Oct 2008 09:27:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #2 - PAT updates
In-Reply-To: <20081009234951.GA24349@elte.hu>
Message-ID: <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org>
References: <20081009234951.GA24349@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
> Ingo Molnar (12):
>       Revert "reduce tlb/cache flush times of agpgart memory allocation"
>       Revert "introduce two APIs for page attribute"
>       Revert "x86: handle error returns in set_memory_*()"
>       Revert "x86: track memtype for RAM in page struct"
>       Revert "x86, cpa: global flush tlb after splitting large page and before doing cpa"
>       Revert "x86, cpa: remove cpa pool code"
>       Revert "x86, cpa: fix taking the pgd_lock with interrupts off"
>       Revert "x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC"
>       Revert "x86, cpa: make the kernel physical mapping initialization a two pass sequence"
>       Revert "x86, cpa: remove USER permission from the very early identity mapping attribute"
>       Revert "x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot"
>       x86, pat: cleanups

So half of the commits by Suresh were reverted. 

Not only that, they were reverted WITH ABSOLUTELY NO EXPLANATIONS OF WHY 
THEY WERE CLEARLY BUGGY PILES OF CRUD. The revert messages are just things 
like

	This reverts commit <sha1>.

which makes both the original commit _and_ the revert just totally 
pointless, because we didn't learn anything.

So tell me exactly why I should pull this series again? Why should I ever 
pull _any_ tree that cannot explain its commits? 

Next time you revert, explain _why_. And if a tree has this many reverts 
(and by "this many" I mean "dammit, there are three times as many commits 
as there should be, because a third of the commits are crap, a third of 
the commits are reverts of that crap, and a third of the commits actually 
remain"), why should I pull it again? 

In other words, why shouldn't I just think that this whole branch is a 
total failure, which is what I think right now?

		Linus
