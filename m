Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbZD3OKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbZD3OKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763998AbZD3OKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:10:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:20734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763960AbZD3OKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:10:07 -0400
Message-ID: <49F9B13C.3060008@monstr.eu>
Date: Thu, 30 Apr 2009 16:10:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271447.40984.arnd@arndb.de> <49F5A9A8.8010306@monstr.eu> <200904301553.47556.arnd@arndb.de>
In-Reply-To: <200904301553.47556.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 27 April 2009, Michal Simek wrote:
>> Arnd Bergmann wrote:
>>> On Monday 27 April 2009, Michal Simek wrote:
>>>>> st_size represents an off_t in user space, which is signed.
>>>>> Just over half the existing architectures use signed types
>>>>> for st_size, but for this (like Sam's suggestion for __u64),
>>>>> I don't think it matters either way.
>>>> OK. Is it mean that your structure is perfect? If yes,
>>>> I'll recompile toolchain and do some more tests. 
>>> Please wait for my full patches, which I am about to
>>> post. I hope to get to the stage where literally none
>>> of the ABI is defined in your own header files but
>>> it all gets into the generic parts. I hope to get this
>>> out within a few hours.
>> OK.
> 
> Any success so far with the patches I posted? I guess you
> need to apply just the first of the three microblaze patches
> in the series first to see if that works, before changing
> the signal handling and syscall table as well.

I looked at there are two things together. Header cleanup and syscall cleanup.
For both I have problems.
1. header cleanup -> some of them is only moving to generic location -> that's no problem
2. header cleanup -> some of them is pain because I have to recompile toolchain
that's should be a big deal but after recompilation kernel, user apps I am getting some problems.
3. syscall cleanup -> we still have old libc and I can't simple remove ancient syscalls

I would like to test all of them but I can't do too fast.
I am trying to cleanup uaccess.h troubles and I have some changes about context switch change
but this work only on MMU and I haven't had a time to fix it on noMMU.
I am fighting with old code where I don't have any information about.

I have your changes in my queue and they inspired me to do things better and I hope that
I will be able to use all of them.

Thanks,
Michal


> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
