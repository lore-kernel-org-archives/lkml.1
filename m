Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYKGSPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYKGSPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYKGSPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:15:47 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51431 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751119AbYKGSPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:15:46 -0500
Message-ID: <4914861F.7080006@sgi.com>
Date: Fri, 07 Nov 2008 10:17:03 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <200811021229.16061.rusty@rustcorp.com.au> <alpine.LFD.2.00.0811011834360.3483@nehalem.linux-foundation.org> <200811070949.02914.rusty@rustcorp.com.au> <20081107084016.GF4435@elte.hu> <20081107201139.196fa52b.sfr@canb.auug.org.au> <20081107093911.GD7787@elte.hu> <20081107122400.GA20777@elte.hu>
In-Reply-To: <20081107122400.GA20777@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
> Find below the delta patch between the two versions, and an 
> analysis/review of the changes. I've started testing it as well, and 
> it's looking good so far.
> 
...
> "0c82f41: cpumask:new-API-only" thus has only a couple of hours of 
> lifetime and the "this has been in linux-next" is only true for that 
> short time period.
> 
> So ... i've reconstructed what's new in 0c82f41, and i came up with 
> the delta patch below.
...
>>From cd83e42c6b0413dcbb548c2ead799111ff7e6a13 Mon Sep 17 00:00:00 2001
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Fri, 7 Nov 2008 11:12:29 +1100
> Subject: [PATCH] cpumask: new API, v2
> 
> - add cpumask_of()
> - add free_bootmem_cpumask_var()
...

I'd like to begin resubmitting the patches that were in the cpus4096-v2
branch but I'm not quite sure how to set up the git tree.  I have:

git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git-remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
git-remote update
git-checkout -b cpus4096 tip/cpus4096

But I don't see the linux-next changes (like cpumask_first for uniprocessor), so I'm
guessing I need to either merge in linux-next, or insert it into the above setup
commands?

Fyi, hopefully this patch submission conduit will work:

	generic only: via linux-next
	arch-specific (x86 + others): Rusty via arch-maintainers (linux-next?)
	(x86 only): Mike via tip/cpus4096

Does this work for you?

Thanks,
Mike

