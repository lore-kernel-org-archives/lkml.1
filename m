Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYEHPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYEHPf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYEHPfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:35:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41341 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYEHPfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:35:06 -0400
Date: Thu, 8 May 2008 18:33:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080508153343.GD7718@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080508151028.GA12109@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 05:10:28PM +0200, Ingo Molnar wrote:
>...
> also includes a scheduler arithmetics fix from Mike. Find the shortlog 
> and diff below.
> 
> 	Ingo
> 
> ------------------>
>...
> Mike Galbraith (1):
>       sched: fix weight calculations
>...

The commit description says:

<--  snip  -->

...

This bug could be related to the regression reported by Yanmin Zhang:

| Comparing with kernel 2.6.25, sysbench+mysql(oltp, readonly) has lots
| of regressions with 2.6.26-rc1:
|
| 1) 8-core stoakley: 28%;
| 2) 16-core tigerton: 20%;
| 3) Itanium Montvale: 50%.

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
...

<--  snip  -->

Can we get that verified and the description updated before it hits 
Linus' tree?

Otherwise this "could be related" will become unchangable metadata that 
will stay forever - no matter whether there's any relation at all.

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

