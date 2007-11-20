Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbXKTQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbXKTQKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbXKTQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:10:30 -0500
Received: from rtr.ca ([76.10.145.34]:2264 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbXKTQK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:10:29 -0500
Message-ID: <474306F2.4060502@rtr.ca>
Date: Tue, 20 Nov 2007 11:10:26 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca>	<200711201517.16171.nickpiggin@yahoo.com.au>	<20071119213727.16d5917b@laptopd505.fenrus.org>	<200711201837.39664.nickpiggin@yahoo.com.au>	<20071120064747.2a8036cd@laptopd505.fenrus.org>	<4743018C.1000307@rtr.ca>	<474302D0.9000509@rtr.ca> <20071120080243.22725fb3@laptopd505.fenrus.org>
In-Reply-To: <20071120080243.22725fb3@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 20 Nov 2007 10:52:48 -0500
> Mark Lord <lkml@rtr.ca> wro
>> All of which reminds me of perhaps *the* most important reason to keep
>> core functionality like "IRQ distribution" *inside* the kernel:
>>
>>    It has to pass peer review on this mailing list.
> 
> 
> that's a reason to keep it in the *source*, that's not the same as
..

Ack.  :)


> keeping it in ring0 pinning down memory all the time etc ;)
..

I belive it *must* remain pinned in memory to be effective,
because I also know it must run much more frequently than it
currently seems to run, in order to respond to quick changes
in IRQ load.

Eg. a heretofore idle device is suddenly now being used to copy
a DVD-sized file around.  It *must* respond quickly to changes
in load like this, or system latencies will suffer badly.

Cheers
