Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYIIQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYIIQH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYIIQHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:07:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56193 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYIIQHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:07:12 -0400
Date: Tue, 9 Sep 2008 19:05:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909160528.GC30160@cs181140183.pp.htv.fi>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu> <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 12:30:02PM -0700, Linus Torvalds wrote:
>...
>  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
>    granted.
> 
> Yes, there are graduations to the above, but reasonably, those three are I 
> think the "architectural" big versions. The rest should be:
> 
>  - pure "tuning" options. A Pentium 4 is different from Core 2 in tuning, 
>    and the best code sequences can be very very different, but the binary 
>    should work on both.
> 
>  - with *dynamic* choices for the differences that are architecturally 
>    visible.
> 
>    Ie the whole choice of syscall/sysenter/int80 is dynamic, not specified 
>    statically at compile time with a config option. So are things like the 
>    different XMM versions etc.
>...

We use 3DNow! for bigger memcpy's if the kernel is configured for a K7.

How does this fit into your picture?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

