Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYELHrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYELHrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbYELHqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:46:34 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39373 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771AbYELHqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:46:30 -0400
Date: Mon, 12 May 2008 10:45:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080512074505.GA1320@cs181133002.pp.htv.fi>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org> <20080511184952.GG1645@cs181133002.pp.htv.fi> <20080511194248.GA514@uranus.ravnborg.org> <20080511200016.GH1645@cs181133002.pp.htv.fi> <20080511203827.GA850@uranus.ravnborg.org> <20080511211902.GI1645@cs181133002.pp.htv.fi> <20080511214428.GA1782@uranus.ravnborg.org> <20080511221158.GN1645@cs181133002.pp.htv.fi> <20080512065759.GA7145@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080512065759.GA7145@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 08:57:59AM +0200, Sam Ravnborg wrote:
>...
> > Provocation is the only way of communication that works on this list.
> 
> So this was pure time waste. Thanks!
> Please do not waste my time answering this.

I'm saying since 2005 that breaking the semantics of "inline" in the 
kernel can cause problems - and noone cared.

Now I did choose an example that highlights the possible problem of 
changing the semantics of "inline" [1], defended it, and let other 
people (like you) argue against it.

This thread is AFAIR the only time someone other than me said
"Stop! That inline here might be required!".

What I'll do with non-provoking patches will be to remove the > 95%
inline's that are not required and hope people like you now have a
rough understanding that this plus removing the "optimized inlining"
stuff is the safe way to go.

> 	Sam

cu
Adrian

[1] in the few places that really need it a hint is not sufficient;
    if you think it's required somewhere you have to audit the code
    and use always_inline _before_ the "optimized inlining" gets offered

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

