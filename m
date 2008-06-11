Return-Path: <linux-kernel-owner+w=401wt.eu-S1764424AbYFKRAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764424AbYFKRAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYFKRAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:00:46 -0400
Received: from mx2.compro.net ([216.54.166.4]:2441 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYFKRAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:00:45 -0400
X-IronPort-AV: E=Sophos;i="4.27,625,1204520400"; 
   d="scan'208";a="2333408"
Message-ID: <4850046C.4070602@compro.net>
Date: Wed, 11 Jun 2008 12:59:24 -0400
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
References: <200806102152.23286.solstice.dhiver@gmail.com>	<20080610131314.5f7069e6@infradead.org>	<484EE71A.40002@intel.com>	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>	<20080611063639.5e1eea5b@infradead.org>	<alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>	<20080611065816.6cff290d@infradead.org>	<Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com> <20080611083644.32afc823@infradead.org>
In-Reply-To: <20080611083644.32afc823@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 11 Jun 2008 10:14:50 -0400
> "linux-os (Dick Johnson)" <linux-os@analogic.com> wrote:
> 
>> I use CPU frequency to scale the output of rdtsc when timing
>> routines being optimized.
> 
> Ok this is broken in various really bad ways.
> 
> 1) CPU frequency is very fluctuating, it changes in principle every
> millisecond or more

I'm curious. What do you mean by "in principle"? And why will it change?

> 2) the rdtsc "frequency" is conceptually unrelated to cpu frequency. In
> fact, you'll be hard-pressed to buy a system today where this
> relationship works....
> 

And what do you mean by "conceptually unrelated to cpu frequency"?
Is it not the clock freq that is driving the cpu and the freq at which
the tsc is incremented?

> 
>> If CPU frequency goes away, I'll
>> have to add calibration routines to a lot of code. I don't
>> think one should just dispose of something that has been
>> useful for many years because they don't understand its
>> utility.
> 
> clearly you don't understand it either ;-)
> 

Could you explain what we don't understand about this please?

> I'm not arguing for removing it, at all. I'm just arguing that any user
> of it (being human or program) has some problems in how they use the
> data.
> 
> 
> 

Regards
Mark
