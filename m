Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbXKMUBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbXKMUBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbXKMUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:00:54 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49747 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758140AbXKMUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:00:52 -0500
Date: Tue, 13 Nov 2007 21:00:28 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <liml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113200028.GJ4250@stusta.de>
References: <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113181228.GF4250@stusta.de> <4739EA83.5040006@rtr.ca> <20071113183605.GG4250@stusta.de> <4739F12E.5020807@rtr.ca> <20071113190428.GH4250@stusta.de> <4739FA4D.1050900@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4739FA4D.1050900@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 02:26:05PM -0500, Mark Lord wrote:
> Adrian Bunk wrote:
>> On Tue, Nov 13, 2007 at 01:47:10PM -0500, Mark Lord wrote:
>>> Adrian Bunk wrote:
> ..
>> Another point is that it shifts the work from the few experienced 
>> developers to the many users. Users (and voluntary testers) we have
>> many, but developer time for debugging bug reports is a quite scarce 
>> resource.
>>
>>> And when a "maintainer" is too busy to find/fix their own bugs,
>>> that could be a sign that they've bitten off too big of a chunk
>>> of the kernel, and it's time for them to distribute code maintainership.
>>
>> The problem is: Maintainers don't grow on trees.
> ..
>
> Hey, if somebody has time to break things, then they damn well ought
> to be able to make time to fix them again.  And the best developers
> here on LKML do just that (fix what they break).
>
> You broke it, you fix it.  A simple rule.
>
> Translation for the particularly daft:
>
> If you've been making significant updates to a driver/subsystem,
> and people are reporting that it is now broken for them,

What are "significant updates"?

Sometimes one person makes one small patch and this patch contains
a typo.

> then it's your job to make it right.

We have some open drivers/ata/ regressions.

I see some person named "Mark Lord" being responsible for 4 commits.

What pubishment do you plan for him if 2.6.24 ships with any libata 
regressions?

Let George W. Bush wrongly accuse him of possessing weapons of 
mass destructions and invade Canada?

> The reporters can help,
> and many may even git-bisect or send patches.  
> But you cannot *expect* or *insist* upon them doing your job.

Bullshit.

Bug fixing is not about finding someone to blame, it's about getting the 
bug fixed.

The bug reporter is the person who can reproduce the problem, and if 
it's a regression then bisecting is the natural way of getting nearer 
at getting it fixed.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

