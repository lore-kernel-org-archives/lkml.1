Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZFWODD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZFWODD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbZFWOCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:02:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:60377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbZFWOCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:02:54 -0400
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
 member in event_symbol
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090623082411.GC11181@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain>
	 <1245669268.17153.8.camel@localhost.localdomain>
	 <20090622113256.GA22479@elte.hu>
	 <1245675657.7537.3.camel@localhost.localdomain>
	 <20090622141009.GB6486@elte.hu>
	 <1245700551.6167.5.camel@localhost.localdomain>
	 <20090623082411.GC11181@elte.hu>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 19:32:12 +0530
Message-Id: <1245765732.3776.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 10:24 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > 
> > perf test also need some command to execute otherwise it will also 
> > show long list of <inactive>
> 
> I think what it should do is to execute test-cases _internally_. Not 
> just execute some random command on the system and hope for events.
> 

Can you suggest some good test cases where we can get numbers for almost
all the events on each and every run.


> >  context-switches                                         7956
> >  CPU-migrations                                              7
> 
> this needs to be provoked intentionally via sched_setaffinity(): 
> first migrate to cpu0, then to cpu1.
> 

There should be some option from user or we test it each time.

> >  L1-data-Cache-Load-Referencees                      398303881
> >  L1-data-Cache-Load-Misses                             3552374
> >  L1-data-Cache-Store-Referencees                        270178
> >  L1-data-Cache-Store-Misses                         <inactive>
> 
> this is probably inactive due to AMD not having events for that and 
> the generic cache event being 0 there, right?
> 

Yes, it is not set for AMD.

Thanks,
--
JSR

