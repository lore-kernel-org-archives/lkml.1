Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYAAXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYAAXSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYAAXSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:18:48 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50800 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbYAAXSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:18:48 -0500
Date: Wed, 2 Jan 2008 01:18:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: clear IO_APIC before enabing apic error
	vector. v2
Message-ID: <20080101231832.GI27566@does.not.exist>
References: <200712291952.20455.yinghai.lu@sun.com> <20071230145115.GR16946@elte.hu> <86802c440712301248m38cd000ejf7e48f273d573edd@mail.gmail.com> <20071230220620.GC17670@does.not.exist> <86802c440712301442q476979f0hef047a45e5444c84@mail.gmail.com> <20071230232354.GA3083@does.not.exist> <86802c440712301601g62448de8i412895a105a9ae61@mail.gmail.com> <20071231002845.GB3083@does.not.exist> <86802c440712301703w1929ae9fue5bf937bf7f4e005@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86802c440712301703w1929ae9fue5bf937bf7f4e005@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 05:03:50PM -0800, Yinghai Lu wrote:
> On Dec 30, 2007 4:28 PM, Adrian Bunk <bunk@kernel.org> wrote:
> >
> > On Sun, Dec 30, 2007 at 04:01:39PM -0800, Yinghai Lu wrote:
>...
> > > the old one is in x86-mm tree
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ffcbdc220a1520d006a837f33589c7c19ffbeb76
> > >...
> >
> > Sorry for the dumb question, but what in
> >
> > +       if (!smp_processor_id() && !skip_ioapic_setup && nr_ioapics)
> > +               enable_IO_APIC();
> >
> > guarantees that this call doesn't happen when you hotplug CPU 0 ?
> >
> 
> if CPU 0 (BSP) can be hotplug, it will be restarted via smp_callin.
> and the delta function call patch will use setup_local_APIC(NULL),
> then it will be safe.

We are talking about the version without the pointer games.

> YH

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

