Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbXDQLMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbXDQLMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 07:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXDQLMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 07:12:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:57471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbXDQLMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 07:12:19 -0400
Date: Tue, 17 Apr 2007 13:11:59 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417111159.GA5122@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <46247DAB.1060808@shadowen.org> <20070417093257.GA9267@wotan.suse.de> <20070417095900.GB25553@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417095900.GB25553@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 11:59:00AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > 2.6.21-rc7-cfs-v2
> > 534.80user 30.92system 2:23.64elapsed 393%CPU
> > 534.75user 31.01system 2:23.70elapsed 393%CPU
> > 534.66user 31.07system 2:23.76elapsed 393%CPU
> > 534.56user 30.91system 2:23.76elapsed 393%CPU
> > 534.66user 31.07system 2:23.67elapsed 393%CPU
> > 535.43user 30.62system 2:23.72elapsed 393%CPU
> 
> Thanks for testing this! Could you please try this also with:
> 
>    echo 100000000 > /proc/sys/kernel/sched_granularity
> 
> on the same system, so that we can get a complete set of numbers? Just 
> to make sure that lowering the preemption frequency indeed has the 
> expected result of moving kernbench numbers back to mainline levels. (if 
> not then that would indicate some CFS buglet)
> 
> could you maybe even try a more extreme setting of:
> 
>    echo 500000000 > /proc/sys/kernel/sched_granularity
> 
> for kicks? This would allow us to see how much kernbench we lose due to 
> preemption granularity. Thanks!

Yeah but I just powered down the test-box, so I'll have to get onto
that tomorrow.
