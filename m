Return-Path: <linux-kernel-owner+w=401wt.eu-S935053AbXLPSO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935053AbXLPSO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765905AbXLPSOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:14:51 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50295 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752669AbXLPSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:14:50 -0500
Date: Sun, 16 Dec 2007 19:14:55 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RANDOM] Move two variables to read_mostly section to save
	memory
Message-ID: <20071216181455.GD14233@stusta.de>
References: <47650FBD.2060209@cosmosbay.com> <20071216130028.GB14233@stusta.de> <476539D5.7050305@cosmosbay.com> <20071216165348.GC14233@stusta.de> <476563A1.4090508@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <476563A1.4090508@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 06:42:57PM +0100, Eric Dumazet wrote:
> Adrian Bunk a écrit :
>...
>> And even more funny, with gcc 4.2 and CONFIG_CC_OPTIMIZE_FOR_SIZE=y your 
>> patch doesn't seem to make any space difference - are you using an older 
>> compiler or even worse CONFIG_CC_OPTIMIZE_FOR_SIZE=n for being able to see 
>> any space difference?
>>
>> In both cases your code uglification would be even more pointless...
>>
>
> I believe that CONFIG_SMP is uglification for you Adrian, but still I am 
> glad linux have it.
>
> If your CONFIG_SYSCTL=n is really that important for you, why dont you 
> define a new qualifier that can indeed mark some variables as :
>
> const if CONFIG_SYSCTL=n
> read_mostly if CONFIG_SYCTL=y
>
> This way you can keep compiler optimizations for your CONFIG_SYCTL=n, while 
> many people like me can still continue to optimize their kernel.
>
> Seeing so many sysctl already read_mostly in kernel, I wonder why you NACK 
> my patch, while it's easy to share your concerns with other people and find 
> a solution.

You omitted an answer to my main important point...

Let me ask it in a more simple way:

Do you see any space difference at all with gcc 4.2 and 
CONFIG_CC_OPTIMIZE_FOR_SIZE=y ?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

