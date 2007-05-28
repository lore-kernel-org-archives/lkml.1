Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbXE1RL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbXE1RL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbXE1RLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:11:21 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47222 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750746AbXE1RLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:11:20 -0400
Date: Mon, 28 May 2007 19:11:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Message-ID: <20070528171115.GQ3899@stusta.de>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com> <200705281049.48679.dhazelton@enter.net> <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com> <20070528154346.GO3899@stusta.de> <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 09:33:32PM +0530, Nitin Gupta wrote:
> On 5/28/07, Adrian Bunk <bunk@stusta.de> wrote:
>...
>> - then ensure that it works correctly on all architectures and
>
> Already tested on x86, amd64, ppc (by Bret). I do not have machines
> from other archs available. Bret tested 'take 3' version but no
> changes were introduced in further revisions that could affect
> correctness - but still it will be good to have this version tested
> too. Only with inclusion in -mm and testing by much wider user base
> can make it to mainline (I suppose nobody uses -mm for production use
> anyway).
>
>>   document why your version is that much faster than the original
>>   version and why you know your optimizations have no side effects
>
> Replied in earlier mail regarding this.
>...

I have not seen any explanations:
- Why did the upstream author write the code that way?
- Why are your changes correct?
- Why do your changes allow the compiler to produce faster code?

The upstream author of the code is available - and he might be able to 
help you getting answers. No matter whether your changes are incorrect 
or correct optimizations that should go upstream, in both cases 
discussing these issues with upstream is the best solution.

And testing is nice, but if you broke some case that's outside of your 
tests you'll never notice.

> - Nitin

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

