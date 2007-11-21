Return-Path: <linux-kernel-owner+w=401wt.eu-S1765146AbXKUAYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765146AbXKUAYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760031AbXKUAYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:24:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50041 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751AbXKUAYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:24:00 -0500
Message-ID: <474379C1.2040703@zytor.com>
Date: Tue, 20 Nov 2007 16:20:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Lord <lkml@rtr.ca>, Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <200711201517.16171.nickpiggin@yahoo.com.au> <20071119213727.16d5917b@laptopd505.fenrus.org> <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu> <47436C43.6010200@rtr.ca> <20071120232723.GB23667@elte.hu> <47436ECD.3050004@zytor.com> <20071120234725.GH23667@elte.hu> <474372BC.2000609@zytor.com> <20071121000742.GN23667@elte.hu>
In-Reply-To: <20071121000742.GN23667@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>>>> Nope.  It runs inside an initramfs, of course; that initramfs is 
>>>> linked into the kernel binary.
>>> would be nice to have a single-image variant for all of this. having 
>>> the separate initrd was always trouble - and it's pointless as well. 
>>> (we rarely update the initrd without updating the vmlinuz as well)
>> We do.  Am I missing something?
> 
> do we have a single-image way of getting both the kernel image and the 
> initram set up at once? What i know of is a two-image approach: vmlinuz 
> and initrd.
> 

Yes, we do.  The initramfs can be linked into the kernel image.  The 
unified klibc build tree does that by default.

	-hpa
