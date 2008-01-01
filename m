Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbYAAXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbYAAXRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYAAXRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:17:30 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50760 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYAAXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:17:29 -0500
Date: Wed, 2 Jan 2008 01:17:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: clear IO_APIC before enabing apic error
	vector. v2
Message-ID: <20080101231714.GH27566@does.not.exist>
References: <200712291952.20455.yinghai.lu@sun.com> <20071230145115.GR16946@elte.hu> <86802c440712301248m38cd000ejf7e48f273d573edd@mail.gmail.com> <20071230220620.GC17670@does.not.exist> <86802c440712301442q476979f0hef047a45e5444c84@mail.gmail.com> <20071230232354.GA3083@does.not.exist> <86802c440712301601g62448de8i412895a105a9ae61@mail.gmail.com> <20071231002845.GB3083@does.not.exist> <86802c440712301656r31559d8fp3cee6e620df6efb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86802c440712301656r31559d8fp3cee6e620df6efb9@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 04:56:35PM -0800, Yinghai Lu wrote:
> On Dec 30, 2007 4:28 PM, Adrian Bunk <bunk@kernel.org> wrote:
>...
> > Sorry for the dumb question, but what in
> >
> > +       if (!smp_processor_id() && !skip_ioapic_setup && nr_ioapics)
> > +               enable_IO_APIC();
> >
> > guarantees that this call doesn't happen when you hotplug CPU 0 ?
> 
> so we can hotplug cpu0 or the bsp?

Honestly I don't know the amd64 architecture well enough for telling 
whether the hardware allows it or not.

> YH

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

