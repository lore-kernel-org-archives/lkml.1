Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbZE1QNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbZE1QNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbZE1QNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:13:40 -0400
Received: from fifo99.com ([67.223.236.141]:46208 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbZE1QNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:13:39 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
	fallback sched_clock().
From: Daniel Walker <dwalker@fifo99.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <1243515570.6600.96.camel@laptop>
References: <1243348681.23657.14.camel@twins>
	 <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
	 <20090526230855.GA27218@linux-sh.org>
	 <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
	 <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop>
	 <20090528091936.GA27545@linux-sh.org> <1243503281.23657.80.camel@twins>
	 <20090528110902.GA27884@linux-sh.org>
	 <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain>
	 <20090528124207.GA28830@linux-sh.org>  <1243515570.6600.96.camel@laptop>
Content-Type: text/plain
Date: Thu, 28 May 2009 09:13:38 -0700
Message-Id: <1243527218.28705.35.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 14:59 +0200, Peter Zijlstra wrote:

> 
> 
> CPU0                           CPU1
> 
> clock = ACCESS_ONCE(sched_clocksource);
> 
>                                unload module
>                                  clocksource_unregister()
>                                    sched_clocksource = jiffies
>                                  unmap data/text
> 
> cyc2ns(clock, clocksource_read(clock)) <--- fireworks
> 
> 

Do any module based clocksources even exist right now?
clocksource_unregister only seems to be used 3 times..

Daniel

