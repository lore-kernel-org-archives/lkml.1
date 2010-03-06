Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab0CFFqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 00:46:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:44550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab0CFFqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 00:46:17 -0500
Message-ID: <4B91EBC6.6080509@kernel.org>
Date: Fri, 05 Mar 2010 21:44:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Thelen <gthelen@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: please don't apply : bootmem: avoid DMA32 zone by default
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com> 	<20100305032106.GA12065@cmpxchg.org> <49b004811003042117n720f356h7e10997a1a783475@mail.gmail.com> <4B915074.4020704@kernel.org> <4B916BD6.8010701@kernel.org>
In-Reply-To: <4B916BD6.8010701@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 12:38 PM, Yinghai Lu wrote:
> if you don't want to drop
> |  bootmem: avoid DMA32 zone by default
> 
> today mainline tree actually DO NOT need that patch according to print out ...
> 
> please apply this one too.
> 
> [PATCH] x86/bootmem: introduce bootmem_default_goal
> 
> don't punish the 64bit systems with less 4G RAM.
> they should use _pa(MAX_DMA_ADDRESS) at first pass instead of failback...

andrew,

please drop Johannes' patch : bootmem: avoid DMA32 zone by default

so you don't need to apply two fix patches from me:
[PATCH] early_res: double check with updated goal in alloc_memory_core_early
[PATCH] x86/bootmem: introduce bootmem_default_goal

move all bootmem to above 4g, make system performance get worse...

Thanks

Yinghai Lu

