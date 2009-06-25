Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZFYNYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZFYNYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZFYNYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:24:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:55939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbZFYNYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:24:09 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0906251445200.2767@localhost.localdomain>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245876060.3038.7.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
	 <20090625092409.GC23547@elte.hu>
	 <alpine.LFD.2.00.0906251445200.2767@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 18:53:36 +0530
Message-Id: <1245936216.5308.43.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 14:48 +0200, Thomas Gleixner wrote:
> On Thu, 25 Jun 2009, Ingo Molnar wrote:
> 
> > 
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Thu, 25 Jun 2009, Jaswinder Singh Rajput wrote:
> > > > On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> > > > 
> > > >       248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
> > > >       283542921  dL1-loads             (scaled from 23.28%)
> > > 
> > > Where is the point of this? dL1-loads is a completely non 
> > > intuitive artificial abbreviation.
> > 
> > blame me :)
> > 
> > I found L1-data-Cache-Load-References way too long and i asked for 
> > suggestions and came up with my list of abbreviations.
> > 
> > I found 'dL1' intuitive because we use 'dTLB' and 'iTLB' as well.
> 
> :)
>  
> > How about L1-data-loads ?
> 
> Yeah, something like that would be nice. The ones Roland
> suggested are fine as well.
> 

This still looks ugly and lines are again long check for
'L1-dcache-prefetch-misses' and does not solve the purpose :

 Performance counter stats for 'ls -lR /usr/include/':
 
      254259235  L1-dcache-loads       (scaled from 22.69%)
        1129360  L1-dcache-load-misses  (scaled from 23.05%)
         151929  L1-dcache-stores      (scaled from 22.94%)
         395089  L1-dcache-prefetches  (scaled from 23.30%)
         273699  L1-dcache-prefetch-misses  (scaled from 23.19%)
      253780608  L1-icache-loads       (scaled from 23.07%)
        4014781  L1-icache-load-misses  (scaled from 23.16%)
          94336  L1-icache-prefetches  (scaled from 23.66%)
        5553717  LLC-loads             (scaled from 23.70%)
         533195  LLC-load-misses       (scaled from 23.68%)
        5534185  LLC-stores            (scaled from 23.92%)
      252786406  dTLB-loads            (scaled from 23.86%)
        5058100  dTLB-load-misses      (scaled from 24.17%)
      248308183  iTLB-loads            (scaled from 24.55%)
           4627  iTLB-load-misses      (scaled from 24.10%)
      106942084  branches              (scaled from 23.93%)
        5280013  branch-misses         (scaled from 23.06%)

Please check my patch which I send few minutes ago.

Thanks,
--
JSR

