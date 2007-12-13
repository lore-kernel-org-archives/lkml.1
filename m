Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbXLMPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbXLMPtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXLMPtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:49:08 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47108 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbXLMPtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:49:07 -0500
Date: Thu, 13 Dec 2007 16:49:09 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Next patches for the 2.6.25 queue
Message-ID: <20071213154908.GH10069@stusta.de>
References: <20071213144642.GA7800@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071213144642.GA7800@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:46:42AM -0500, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> I would like to post my next patches in a way that would make it as
> easy for you and the community to review them. Currently, the patches
> that have really settled down are :
> 
> * For 2.6.25
>...
> - Immediate Values
>   - Redux version, asked by Rusty
>...

I might have missed it:

Are there any real numbers (opposed to estimates and microbenchmarks) 
available how much performance we actually gain in which situations?

It might be some workload with markers using Immediate Values or 
something like that, but it should be something where the kernel
runs measurably faster with Immediate Values than without.

Currently I'm somewhere between "your Immediate Values are just an 
academic code obfuscation without any gain in practice" and "janitors 
should convert all drivers to use Immediate Values", and I'd like to 
form an opinion based on in which situations the kernel runs faster by 
how many percent.

That's also based on observation like e.g. that __read_mostly should 
improve the performance, but I've already seen situations in the kernel 
where it forced gcc to emit code that was obviously both bigger and 
slower than without the __read_mostly [1], and that's part of why I'm 
sceptical of all optimizations below the C level unless proven 
otherwise.

> Thanks,
> 
> Mathieu

cu
Adrian

[1] Figuring out what might have happened is left as an exercise to the 
    reader.  :-)

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

