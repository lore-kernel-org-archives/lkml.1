Return-Path: <linux-kernel-owner+w=401wt.eu-S1764593AbYD3UCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764593AbYD3UCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759917AbYD3UCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:02:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53604 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596AbYD3UCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:02:23 -0400
Date: Wed, 30 Apr 2008 23:01:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: mkrufky@linuxtv.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080430200139.GG29330@cs181133002.pp.htv.fi>
References: <20080430192829.GF29330@cs181133002.pp.htv.fi> <4818C91E.8070307@linuxtv.org> <20080430165214.10b793b4@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430165214.10b793b4@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:52:14PM -0300, Mauro Carvalho Chehab wrote:
> On Wed, 30 Apr 2008 15:31:42 -0400
> mkrufky@linuxtv.org wrote:
> 
> > > Are there actually reports from users running into this problem?
> 
> No.
> 
> Yet, the configuration may be valid. If you have a board with tda8290, it
> _will_ need another chip, like tda827x.
> 
> In the past, both tda8290 and tda827x were handled by the same driver, and
> worked for analog only.
> 
> So, IMO, this is a regression.
>...

drivers/media/ is the part of the kernel with the most fragile kconfig
constructs.

And we are talking about bringing a solution into -stable that has never 
and will never be in mainline.

A compile error in a configuration without practical relevance isn't a 
huge problem, and I'd vote for leaving -stable unchanged.

> Cheers,
> Mauro

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

