Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYH1U3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYH1U3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYH1U2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:28:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58967 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbYH1U2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:28:49 -0400
Date: Thu, 28 Aug 2008 23:27:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
Message-ID: <20080828202750.GB16462@cs181140183.pp.htv.fi>
References: <20080828183223.GA30781@localhost.localdomain> <20080828184025.GA22165@x200.localdomain> <48B6F12F.1010909@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B6F12F.1010909@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 09:40:47PM +0300, Pekka Enberg wrote:
> Hi Alexey,
>
> Alexey Dobriyan wrote:
>> On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
>>> How do you feel about this patch? It's all about making kmemcheck more
>>> useful... and not much else. Does it have any chance of entering the
>>> kernel along with kmemcheck (when/if that happens)?
>>
>> DEFINE_BITFIELD is horrible.
>
> Heh, heh, one alternative is to have a kmemcheck_memset() thingy that  
> unconditionally zeroes bit fields and maybe is a no-op when kmemcheck is  
> disabled.

This sounds as if this might cause bugs to disappear when debugging gets 
turned on?

Or do I miss anything?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

