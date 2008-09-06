Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYIFRSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYIFRSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYIFRSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:18:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYIFRSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:18:16 -0400
Date: Sat, 6 Sep 2008 19:18:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dyn_array: using %pF instead of
	print_fn_descriptor_symbol
Message-ID: <20080906171803.GJ4856@elte.hu>
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com> <20080829152053.92fa6fd4.akpm@linux-foundation.org> <86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com> <20080829155319.dc76b1c0.akpm@linux-foundation.org> <20080906170944.GG4856@elte.hu> <86802c440809061016n2fa6d8te0dd486ceeb6135d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809061016n2fa6d8te0dd486ceeb6135d@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Sat, Sep 6, 2008 at 10:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> >     ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
> >> >     if (!ptr)
> >> >             panic("Can not alloc dyn_alloc\n");
> >>
> >> Why duplicate the panic()?  Just call __alloc_bootmem().
> >
> > agreed.
> >
> >> > #ifdef CONFIF_GENERIC_HARDIRQS
> >>
> >> That doesn't appear to have been very well tested?
> >
> > on non-genirq systems? Most likely. If then most testing they get is
> > from cross-build tools. Few if any actual users.
> >
> >> The code has a few coding-style glitches which checkpatch can detect.
> >
> > yeah. Yinghai, could you please fix them?
> 
> already in tip/master and -mm
> except  first one.

that needs fixing too i think. We dont really want to sprinkle the code 
with various specific panics.

	Ingo
