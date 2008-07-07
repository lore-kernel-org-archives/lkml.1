Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYGGGcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYGGGcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYGGGcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:32:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYGGGcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:32:41 -0400
Date: Mon, 7 Jul 2008 08:32:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-ID: <20080707063218.GC23583@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.XLC.s0LcIB@albercik> <20080706111750.a6d77e81.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.
> 
> Ok, then it wasn't the nr_zones thing.
> 
> Since it seems to be repeatable for you, can you bisect it?

one guess would be:

| commit e8ee6f0ae5cd860e8e6c02807edfa3c1fa01bcb5
| Author: Yinghai Lu <yhlu.kernel@gmail.com>
| Date:   Sun Apr 13 01:41:58 2008 -0700
|
|     x86: work around io allocation overlap of HT links

but ... since CONFIG_NUMA makes it work, i'm not sure about that.

Randy, could you post the full CONFIG_NUMA bootlog as well, does it show 
any difference in resource allocations?

	Ingo

