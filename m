Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZFWTtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZFWTtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZFWTtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:49:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49427 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZFWTtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:49:32 -0400
Date: Tue, 23 Jun 2009 21:49:16 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090623194916.GA18657@localhost>
References: <20090616125248.GA23541@localhost> <1245253102.6067.94.camel@jstultz-laptop> <20090617172325.GA32332@localhost> <20090617172601.GA3493@elte.hu> <20090618121320.GA13025@localhost> <20090623095745.GC30634@elte.hu> <20090623131628.GA11827@localhost> <20090623133625.GA3026@elte.hu> <20090623143323.GA13932@localhost> <20090623191838.GB14852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623191838.GB14852@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:18:38PM +0200, Ingo Molnar wrote:
> 
> * Miroslav Lichvar <mlichvar@redhat.com> wrote:
> 
> > > > I'm not very familiar with the PPS API, is there something 
> > > > wrong with it?
> > > 
> > > The PPS patches i've seen just export IRQ timestamps to 
> > > user-space.
> > > 
> > > That is not very robust in my opinion when it comes to do time 
> > > approximations - to get quick, low-latency action and precise 
> > > measurements it's best to keep the critical path as short as 
> > > possible, and within a single source code repository: i.e. 
> > > within the kernel.
> > 
> > That's what kernel PPS discipline does, it will be probably 
> > included later. Its performance is an order or two better than the 
> > PLL/FLL discipline.
> 
> Is there some kernel patch i can look at?

It's in the old PPSkit patches for 2.4 kernels, function hardpps().

-- 
Miroslav Lichvar
