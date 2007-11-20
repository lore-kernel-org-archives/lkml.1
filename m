Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbXKTXRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbXKTXRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXKTXRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:17:10 -0500
Received: from rtr.ca ([76.10.145.34]:1979 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbXKTXRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:17:09 -0500
Message-ID: <47436AF3.1070806@rtr.ca>
Date: Tue, 20 Nov 2007 18:17:07 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca>	<200711201837.39664.nickpiggin@yahoo.com.au>	<20071120064747.2a8036cd@laptopd505.fenrus.org>	<200711210243.46944.nickpiggin@yahoo.com.au>	<20071120110726.4cc2995e@laptopd505.fenrus.org>	<47433D63.5080806@rtr.ca> <20071120135839.08837372@laptopd505.fenrus.org>
In-Reply-To: <20071120135839.08837372@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 20 Nov 2007 15:02:43 -0500
> Mark Lord <lkml@rtr.ca> wrote:
>> ..
>>
>> Well, for my dualCore notebook, dualCore MythTV box, and QuadCore
>> desktop, the behaviour of the existing, working, 32-bit kernel
>> IRQBALANCE code outperforms the userspace utility.
>>
>> Mostly, I suspect, due to it's much faster response to changing
>> conditions. That's something the external one could try to match, but
>> at present it seems tuned specifically for high-traffic network
>> servers, not for the average notebook or desktop.
> 
> I'd really like to see what it's doing before commenting on this;
> at minimum can you give me the /proc/interrupts of the system?
> It might a simple bug or simple missing item, not a total "scratch the
> full system".
..

Next time I'm doing something significant there,
I'll collect some data for you.  Got other work now.

But it does make sense that this mechanism cannot be longterm for
a desktop.  Intensive loads come and go quickly there, and the
interrupt handling has to respond in a timely fashion.

It's not like a server where loads generally increase/decrease gradually.

Cheers

