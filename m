Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbYC0Mfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbYC0Mfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbYC0Mfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:35:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21077 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYC0Mfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:35:30 -0400
Date: Thu, 27 Mar 2008 13:35:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com, tony.luck@intel.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and  smp_call_function_single()
Message-ID: <20080327123525.GN12346@kernel.dk>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <20080321095343.GA21409@elte.hu> <20080321131558.GA15355@kernel.dk> <20080327100802.GD15003@elte.hu> <20080327103707.GH12346@kernel.dk> <20080327104359.GC26725@elte.hu> <20080327120244.GL12346@kernel.dk> <20080327123213.GC21894@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327123213.GC21894@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > i'd love to be able to run/pull something simple that enables me to 
> > > replicate the measurements you did on a generic PC [without having 
> > > to hit any real IO hardware which would put any context switching 
> > > effects down into the noise category].
> > 
> > You can pull io-cpu-affinity or io-cpu-affinity-kthread from 
> > git://git.kernel.dk/linux-2.6-block.git - or just see the two attached 
> > patches, apply either one to current -git to test it.
> 
> another stupid question: what should i run in user-space to replicate 
> your "3 usecs versus 2 usecs" result? io-affinity-ipi.patch seems to 
> have no self-benchmarking capability at first sight. (I'd rather not try 
> and cook up anything myself - i'd like to reproduce the workload you 
> think is relevant for your IO affinity purposes.) Best would be to have 
> a Kconfig based self-test that just runs during bootup if i boot a 
> bzImage. (laziness rules - and this way i could also track performance 
> regressions more easily, by looking at historic serial logs.)

I didn't do those numbers - Alan, when you timed the kthread vs ipi
"wake up", what did you use? I'm guessing some hacked in test, perhaps
you can pass that to Ingo?

-- 
Jens Axboe

