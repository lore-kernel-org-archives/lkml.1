Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbXEKTjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbXEKTjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbXEKTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:39:24 -0400
Received: from 1wt.eu ([62.212.114.60]:2578 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368AbXEKTjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:39:23 -0400
Date: Fri, 11 May 2007 21:37:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Esben Nielsen <nielsen.esben@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070511193751.GC20383@1wt.eu>
References: <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <20070506082911.GA32644@elte.hu> <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org> <Pine.LNX.4.64.0705071311040.14011@frodo.shire> <463FC5D8.2090502@bigpond.net.au> <20070510130954.GC4052@ucw.cz> <alpine.LFD.0.98.0705110932430.3986@woody.linux-foundation.org> <20070511191824.GA7135@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511191824.GA7135@ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 07:18:25PM +0000, Pavel Machek wrote:
> Hi!
> 
> > > Also notice that current cpus were not designed to work 300 years.
> > > When we have hw designed for 50 years+, we can start to worry.
> > 
> > Indeed. CPU manufacturers don't seem to talk about it very much, and 
> > searching for it with google on intel.com comes up with
> > 
> > 	The failure rate and Mean Time Between Failure (MTBF) data is not 
> > 	currently available on our website. You may contact Intel? 
> > 	Customer Support for this information.
> > 
> > which seems to be just a fancy way of saying "we don't actually want to 
> > talk about it". Probably not because it's actually all that bad, but 
> > simply because people don't think about it, and there's no reason a CPU 
> > manufacturer would *want* people to think about it.
> > 
> > But if you wondered why server CPU's usually run at a lower frequency, 
> > it's because of MTBF issues. I think a desktop CPU is usually specced to 
> > run for 5 years (and that's expecting that it's turned off or at least 
> > idle much of the time), while a server CPU is expected to last longer and 
> > be active a much bigger percentage of time.
> > 
> > ("Active" == "heat" == "more damage due to atom migration etc". Which is 
> > part of why you're not supposed to overclock stuff: it may well work well 
> > for you, but for all you know it will cut your expected CPU life by 90%).
> 
> Actually, when I talked with AMD, they told me that cpus should last
> 10 years *at their max specced temperature*... which is 95Celsius. So
> overclocking is not that evil, according to my info.

I tend to believe that. I've slowed down the FANs on my dual-athlon XP
to silent them, and I found the system to be (apparently) stable till
96 deg Celsius with FANs unplugged. So I regulated them in order to maintain
a temperature below 90 deg for a safety margin, and they seem to be as
happy as my ears. They've been like that for the last 3-4 years, I don't
remember.

On a related note, older technology is less sensible. My old VAX VLC4000
from 1991 which received a small heatsink in exchange for its noisy fans
is still doing well in an closed place. I'm more worried for the EPROMs
which store the boot code. Also, I think that the RS6000 processed at
half-micron which run the Mars rovers might run for hundreds of years
at 30 MHz.

> (That would mean way more than 10 years if you use your cpu
> 'normally'.)
> 
> But I guess capacitors from cpu power supply will hate you running cpu
> at 95C...

even at 60, many of them die within a few years. Bu  I think we're
"slightly" off-topic now...

> 							Pavel

Cheers
Willy

