Return-Path: <linux-kernel-owner+w=401wt.eu-S637761AbXDSNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637761AbXDSNBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637759AbXDSNBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:01:18 -0400
Received: from 1wt.eu ([62.212.114.60]:2017 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S637761AbXDSNBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:01:17 -0400
Date: Thu, 19 Apr 2007 14:54:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419125438.GA27584@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419090144.GA17100@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Apr 19, 2007 at 11:01:44AM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > Good idea. The machine I'm typing from now has 1000 scheddos running 
> > at +19, and 12 gears at nice 0. [...]
> 
> > From time to time, one of the 12 aligned gears will quickly perform a 
> > full quarter of round while others slowly turn by a few degrees. In 
> > fact, while I don't know this process's CPU usage pattern, there's 
> > something useful in it : it allows me to visually see when process 
> > accelerate/decelerate. [...]
> 
> cool idea - i have just tried this and it rocks - you can easily see the 
> 'nature' of CPU time distribution just via visual feedback. (Is there 
> any easy way to start up 12 glxgears fully aligned, or does one always 
> have to mouse around to get them into proper position?)

-- Replying quickly, I'm short in time --

You can certainly script it with -geometry. But it is the wrong application
for this matter, because you benchmark X more than glxgears itself. What would
be better is something like a line rotating 360 degrees and doing some short
stuff between each degree, so that X is not much sollicitated, but the CPU
would be spent more on the processes themselves.

Benchmarking interactions between X and multiple clients is a completely
different test IMHO. Glxgears is between those two, making it inappropriate
for scheduler tuning.

Regards,
Willy

