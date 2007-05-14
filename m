Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbXENULV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbXENULV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXENULM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:11:12 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:5782 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791AbXENULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:11:12 -0400
In-Reply-To: <20070514123046.d75cc170.akpm@linux-foundation.org>
References: <46483FAC.60503@freescale.com> <20070514110636.GB10143@uranus.ravnborg.org> <3DF58590-DFD9-4665-8C47-33F407AAD1E7@kernel.crashing.org> <20070514123046.d75cc170.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <510243B4-E915-4E32-808F-F33CB32B7497@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Li Yang <leoli@freescale.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ppc-dev list <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Date: Mon, 14 May 2007 15:10:04 -0500
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14, 2007, at 2:30 PM, Andrew Morton wrote:

> On Mon, 14 May 2007 08:56:52 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>> On May 14, 2007, at 6:06 AM, Sam Ravnborg wrote:
>>
>>> On Mon, May 14, 2007 at 06:53:32PM +0800, Li Yang wrote:
>>>> This patch fixes the following "Section mismatch" warnings when
>>>> build powerpc platforms.
>>>>
>>>> -------------
>>>> WARNING: arch/powerpc/mm/built-in.o - Section mismatch:  
>>>> reference to
>>>> .init.text:early_get_page from .text between
>>>> 'pte_alloc_one_kernel' (at
>>>> offset 0xc68) and 'pte_alloc_one'
>>>> WARNING: mm/built-in.o - Section mismatch: reference to
>>>> .init.text:set_up_list3s from .text between
>>>> 'kmem_cache_create' (at offset
>>>> 0x20300) and 'cache_reap'
>>>> -------------
>>
>> This warnings should be handled by __init_refok instead.
>>
>
> Yes, I think so.
>
>>
>>>> Massive warnings represented by:
>>>> -------------
>>>> WARNING: arch/powerpc/kernel/built-in.o - Section mismatch:
>>>> reference to
>>>> .init.data:.got2 from prom_entry (offset 0x0)
>>>> WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:
>>>> reference to
>>>> .init.text:mpc8313_rdb_probe from .machine.desc after
>>>> 'mach_mpc8313_rdb'
>>>> (at offset 0x4)
>>>> -------------
>>>>
>>>> Signed-off-by: Li Yang <leoli@freescale.com>
>>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>
> I always get confused when a git-tree-owner says "acked-by" against  
> a patch
> which falls within his tree's area.  An acked-by would mean "I'm OK  
> with
> the patch, please apply it".  But I'd have expected to see a "thanks,
> applied" instead.
>
> If it was "Andrew: please merge and send to Linus because it's  
> urgent and I
> can't be bothered setting up a git pull for it" then fine, but  
> please be
> explicit about that.

I'd prefer to handle the ppc specific bits through the powerpc.git  
since they are only warnings and we should be able to fix them up for  
the next 2.6.22-rc unless Linus is on a made dash to get 2.6.22 out  
faster than any previous release :)

- k

