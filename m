Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXHASB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXHASB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbXHASBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:01:50 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4335 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbXHASBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:01:49 -0400
Date: Wed, 1 Aug 2007 20:01:21 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070801175004.GA17936@elte.hu>
Message-ID: <Pine.LNX.4.64.0708011955430.1817@scrub.home>
References: <Pine.LNX.4.64.0707130415520.1818@scrub.home>
 <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home>
 <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home>
 <20070801071230.GA16375@elte.hu> <Pine.LNX.4.64.0708011511530.1817@scrub.home>
 <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de>
 <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
 <20070801175004.GA17936@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Ingo Molnar wrote:

> Andi's theory cannot be true either, Roman's debug info also shows this 
> /proc/<PID>/sched data:
> 
>   clock-delta              :                  95
> 
> that means that sched_clock() is in high-res mode, the TSC is alive and 
> kicking and a sched_clock() call took 95 nanoseconds.
> 
> Roman, could you please help us with this mystery?

Actually, Andi is right. What I sent you was generated directly after 
boot, as I had to reboot for the right kernel, so a little later appeared 
this:

Aug  1 14:54:30 spit kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
Aug  1 15:09:56 spit kernel: Clocksource tsc unstable (delta = 656747233 ns)
Aug  1 15:09:56 spit kernel: Time: pit clocksource has been installed.

bye, Roman
