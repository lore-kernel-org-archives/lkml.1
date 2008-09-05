Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbYIEUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbYIEUK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYIEUKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:10:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYIEUKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:10:16 -0400
Message-ID: <48C1912E.3070407@zytor.com>
Date: Fri, 05 Sep 2008 13:06:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux@sandersweb.net,
       Andi Kleen <andi-suse@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org> <200809051138.20615.linux@sandersweb.net> <48C17754.76E4.0078.0@novell.com> <alpine.LFD.1.10.0809050931340.3117@nehalem.linux-foundation.org> <20080905184353.GA29496@elte.hu>
In-Reply-To: <20080905184353.GA29496@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>  - Move the optimized nop definitions (K7_NOPx etc) to the only place that 
>>    cares - asm/x86/kernel/alternative.c. When we do things _dynamically_, 
>>    it can actually make sense to pick a nop more precisely, but for this 
>>    whole static thing it's just a pain.
>>
>> IOW, if it actually _worked_ reasonably, I wouldn't care. But clearly 
>> it doesn't. And once it's not working reasonably, it should be fixed.
> 
> yes - we had 3-4 tries already and while it looked worthwile initially 
> it's clearly not showing signs of getting more robust and whatever 
> benefits there might be slightly better NOPs is dwarved by all these 
> robustness problems. Peter?

There is already a fix for this based on a first-principles test in tip.

	-hpa


