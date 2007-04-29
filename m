Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXD2IQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXD2IQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXD2IQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:16:26 -0400
Received: from holomorphy.com ([66.93.40.71]:56776 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985AbXD2IQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:16:21 -0400
Date: Sun, 29 Apr 2007 01:16:35 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429081635.GY19966@holomorphy.com>
References: <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <20070429075436.GZ31925@holomorphy.com> <20070429080359.GA10844@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429080359.GA10844@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> I think it'd be a good idea to merge scheduler classes before changing 
>> over the policy so future changes to policy have smaller code impact. 
>> Basically, get scheduler classes going with the mainline scheduler.

On Sun, Apr 29, 2007 at 10:03:59AM +0200, Ingo Molnar wrote:
> i've got a split up patch for the class stuff already, but lets first 
> get some wider test-coverage before even thinking about upstream 
> integration. This is all v2.6.22 stuff at the earliest.

I'd like to get some regression testing (standard macrobenchmarks) in
on the scheduler class bits in isolation, as they do have rather
non-negligible impacts on load balancing code, to changes in which such
macrobenchmarks are quite sensitive.

This shouldn't take much more than kicking off a benchmark on an
internal box at work already set up to do such testing routinely.
I won't need to write any fresh testcases etc. for it. Availability
of the test systems may have to wait until Monday, since various people
not wanting benchmarks disturbed are likely to be out for the weekend.

It would also be beneficial for the other schedulers to be able to
standardize on the scheduling class framework as far in advance as
possible. In such a manner comparative testing by end-users and more
industrial regression testing can be facilitated.


-- wli
