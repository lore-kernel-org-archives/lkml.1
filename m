Return-Path: <linux-kernel-owner+w=401wt.eu-S1763243AbYETAP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763243AbYETAP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbYETAPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:15:52 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46711 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973AbYETAPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:15:51 -0400
Date: Tue, 20 May 2008 03:13:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
Message-ID: <20080520001345.GG17716@cs181133002.pp.htv.fi>
References: <20080519215452.GK17716@cs181133002.pp.htv.fi> <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick> <20080519223232.GB17716@cs181133002.pp.htv.fi> <48321299.80303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48321299.80303@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:51:53PM -0700, H. Peter Anvin wrote:
> Adrian Bunk wrote:
>>>>
>>> If it is going to be unconditionally offered, we could get rid of
>>> __BYTEORDER_HAS_U64__ as a next step.  Unless there is something I've
>>> missed.
>>
>> Why do we need the byteorder headers in userspace at all?
>>
>
> Because Linux-specific software has depended on them for over 15 years  
> (they are a much better API than anything POSIX provides.)  We can't  
> just yank them, and so it's better if they actually work.
> 
> Yes, you can argue it should be glibc's job to provide them, but well,  
> why duplicate work when we already have a nicely working set.

The worst thing is how many CONFIG_'s they currently leak to userspace.

And e.g. the versions in the x86 header are therefore not the fastest 
ones (unless the userspace software #define's CONFIG_X86_BSWAP)...

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

