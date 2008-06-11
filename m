Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYFKVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYFKVJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYFKVJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:09:32 -0400
Received: from mx2.compro.net ([216.54.166.4]:60028 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYFKVJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:09:31 -0400
X-IronPort-AV: E=Sophos;i="4.27,626,1204520400"; 
   d="scan'208";a="2334484"
Message-ID: <48503EB9.6000606@compro.net>
Date: Wed, 11 Jun 2008 17:08:09 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
References: <200806102152.23286.solstice.dhiver@gmail.com>	<20080610131314.5f7069e6@infradead.org>	<484EE71A.40002@intel.com>	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>	<20080611063639.5e1eea5b@infradead.org>	<alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>	<20080611065816.6cff290d@infradead.org>	<Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>	<20080611083644.32afc823@infradead.org>	<4850046C.4070602@compro.net>	<20080611104446.3b0ce2d9@infradead.org>	<48501159.4050908@compro.net>	<48503792.50003@compro.net> <20080611135828.29f6a7d7@infradead.org>
In-Reply-To: <20080611135828.29f6a7d7@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 11 Jun 2008 16:37:38 -0400
> Mark Hounschell <markh@compro.net> wrote:
> 
>>> Mark 
>>>
>> Ok, what would one use besides the tsc to take a fast high-res time
>> stamp in a kernel module that could also be used in user land (same
>> time source) to for instance calculate  the the time between an event
>> in the kernel to an event in user land?
>>
>> do_gettimeofday / gettimeofday are not really acceptable.
> 
> 
> btw you also changed the problem from "what is the cpu frequency" to
> "how usable is rdtsc for time". My entire point was that these weren't
> related...
> 
> 

If they are not the same how do you know at what rate the tsc is counting.

But back to "how usable is rdtsc for time", is there a

clock_gettime(CLOCK_MONOTONIC, &time) equivalent that can be used in the kernel?

Mark
