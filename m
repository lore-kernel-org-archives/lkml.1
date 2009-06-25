Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZFYPMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZFYPMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZFYPM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:12:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbZFYPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:12:26 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ada7hz0l5f0.fsf@cisco.com>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245876060.3038.7.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
	 <20090625092409.GC23547@elte.hu>
	 <alpine.LFD.2.00.0906251445200.2767@localhost.localdomain>
	 <1245936216.5308.43.camel@hpdv5.satnam>  <ada7hz0l5f0.fsf@cisco.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 20:41:53 +0530
Message-Id: <1245942713.9157.2.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 08:05 -0700, Roland Dreier wrote:
> > This still looks ugly and lines are again long check for
>  > 'L1-dcache-prefetch-misses' and does not solve the purpose :
>  > 
>  >  Performance counter stats for 'ls -lR /usr/include/':
>  >  
>  >       254259235  L1-dcache-loads       (scaled from 22.69%)
>  >         1129360  L1-dcache-load-misses  (scaled from 23.05%)
>  >          151929  L1-dcache-stores      (scaled from 22.94%)
>  >          395089  L1-dcache-prefetches  (scaled from 23.30%)
>  >          273699  L1-dcache-prefetch-misses  (scaled from 23.19%)
>  >       253780608  L1-icache-loads       (scaled from 23.07%)
>  >         4014781  L1-icache-load-misses  (scaled from 23.16%)
> 
> But even the longest line there (dcache-prefetch-misses) is only 64
> columns long, so you could just align the "(scaled" part a little
> further to the right and keep the output under, say, 72 columns.
> 

BTW, this is a shorten patch not widen patch ;-)

L1d and L1i is self explanatory.

If iTLB and dTLB are valid then why not L1d and L1i ?

Thanks,
--
JSR

