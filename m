Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZDNLH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZDNLH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZDNLHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:07:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42606 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZDNLHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:07:17 -0400
Date: Tue, 14 Apr 2009 13:06:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] use smp_call_function_single() in
	arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
Message-ID: <20090414110610.GO3558@elte.hu>
References: <20090413000630.21C09DE12A@ozlabs.org> <20090413001657.GA24946@redhat.com> <200904141835.41961.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904141835.41961.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 13 Apr 2009 09:46:57 am Dave Jones wrote:
> > On Mon, Apr 13, 2009 at 09:30:02AM +0930, Rusty Russell wrote:
> >  > From: Andrew Morton <akpm@linux-foundation.org>
> >  > 
> >  > Impact: fix sysbench(oltp)+mysql 10% regression with 2.6.30-rc1
> >  > 
> > 
> > This, and the other cpufreq related patches in this series look 
> > sound to me. Given the other non-cpufreq bits in the series, do 
> > you want to just have these go through Andrew and onto Linus?
> 
> Sure, that's certainly easiest for me.  I'd assumed Ingo would 
> snarf them, but as he's suggested -mm, Andrew?

I tend to let the snarfing be done by the tree which introduced a 
regression to begin with ;-)

	Ingo
