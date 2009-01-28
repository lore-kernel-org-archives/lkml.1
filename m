Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZA1BDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZA1BDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 20:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZA1BDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 20:03:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZA1BDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 20:03:15 -0500
Message-ID: <497FAE97.6020703@zytor.com>
Date: Tue, 27 Jan 2009 17:02:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <497F9740.4000505@zytor.com> <alpine.LFD.2.00.0901271527340.3123@localhost.localdomain> <497FA2F5.2040806@zytor.com> <alpine.LFD.2.00.0901271616130.3123@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901271616130.3123@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>>>
>> This is probably true.  I think we should add this as one more of the
>> preprocessing rules which we really should just do, as well as automatic
>> mangling of integer types.
> 
> Btw, the really scary thing is that I bet there are programs out there 
> that "know" about kernel internals, and do things like
> 
> 	#define CONFIG_SMP 1
> 	#define __KERNEL__ 1
> 	#include <asm/atomic.h>
> 
> in order to get the atomic helpers from the kernel, and using CONFIG_xyz 
> markers to force the exact version they want.
> 
> And we will inevitably always end up breaking stuff like that. Nothing we 
> can do about it - in the end, users can do infinitely odd things and know 
> about our internals, and whatever changes we do will occasionally break 
> some of the more incestuous code.
> 

Yes, that's just PEBKAC.

	-hpa

