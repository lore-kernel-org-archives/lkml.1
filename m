Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYDCOGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYDCOGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbYDCOGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:06:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3621 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755577AbYDCOGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:06:23 -0400
Date: Thu, 3 Apr 2008 16:06:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC,PATCH] loopback: calls netif_receive_skb() instead of	netif_rx()
Message-ID: <20080403140600.GA4507@ucw.cz>
References: <47BDC848.50607@cosmosbay.com> <20080226.182120.183405235.davem@davemloft.net> <47C92F49.4070100@cosmosbay.com> <20080323.032949.194309002.davem@davemloft.net> <47E6A5FD.6060407@cosmosbay.com> <20080331094823.GA11651@elte.hu> <47F0B66C.6080404@cosmosbay.com> <20080331101237.GA12324@elte.hu> <47F1FE0A.9090501@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F1FE0A.9090501@cosmosbay.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >the rule on x86 should be something like this: on 4K 
> >stacks and 64-bit [which have irqstacks] free stack 
> >space can go as low as 25%. On 8K stacks [which doesnt 
...
>   32 bits and 4K stacks (separate irq stacks) : can use 
>   up to 25% of stack

I think ingo meant 'up to 75% used'.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
