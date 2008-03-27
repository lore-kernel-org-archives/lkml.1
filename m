Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYC0MdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYC0MdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYC0Mc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:32:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43578 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbYC0Mcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:32:55 -0400
Date: Thu, 27 Mar 2008 13:32:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com, tony.luck@intel.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and
	smp_call_function_single()
Message-ID: <20080327123213.GC21894@elte.hu>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <20080321095343.GA21409@elte.hu> <20080321131558.GA15355@kernel.dk> <20080327100802.GD15003@elte.hu> <20080327103707.GH12346@kernel.dk> <20080327104359.GC26725@elte.hu> <20080327120244.GL12346@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327120244.GL12346@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > i'd love to be able to run/pull something simple that enables me to 
> > replicate the measurements you did on a generic PC [without having 
> > to hit any real IO hardware which would put any context switching 
> > effects down into the noise category].
> 
> You can pull io-cpu-affinity or io-cpu-affinity-kthread from 
> git://git.kernel.dk/linux-2.6-block.git - or just see the two attached 
> patches, apply either one to current -git to test it.

another stupid question: what should i run in user-space to replicate 
your "3 usecs versus 2 usecs" result? io-affinity-ipi.patch seems to 
have no self-benchmarking capability at first sight. (I'd rather not try 
and cook up anything myself - i'd like to reproduce the workload you 
think is relevant for your IO affinity purposes.) Best would be to have 
a Kconfig based self-test that just runs during bootup if i boot a 
bzImage. (laziness rules - and this way i could also track performance 
regressions more easily, by looking at historic serial logs.)

	Ingo
