Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYEKMxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYEKMxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYEKMxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:53:42 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41309 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYEKMxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:53:41 -0400
Date: Sun, 11 May 2008 15:52:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511125221.GF1645@cs181133002.pp.htv.fi>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511111820.GA3326@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080511111820.GA3326@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 01:18:20PM +0200, Andreas Mohr wrote:
> 
> [manual reply, no access to original content]
> 
> Hi,
> 
> rather NACKish here (from my minor side, that is, since there are no
> useful explanations, and in the case of a lack of explanations no
> backing numbers either which would have been helpful to resolve this ;).
> 
> "x86: add optimized inlining"
> (http://kerneltrap.org/mailarchive/git-commits-head/2008/4/26/1612644)
> does not really say anything relevant to your patch, AFAICS.
> 
> That one simply says that previously every inline was force-inlined (ugh),
> which now gcc is allowed to properly decide by itself now. This, however,
> does _NOT_ imply that it's now somehow fully sufficient for a perfect outcome
> to simply remove all open-coded "inline"s.

They both do the same - gcc is no longer forced to inline these 
functions.

With either my patch or the "optimized inlining" it's 100% gcc's 
choice whether or not to inline functions marked as "inline" in 
kernel/sched* .

If you didn't complain when "x86: add optimized inlining" got into 
Linus' tree you can't validly complain about my patch.

> Just my thoughts (keep it or burn it),
> 
> Andreas Mohr

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

