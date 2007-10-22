Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbXJVSXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbXJVSXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXJVSXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:23:18 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48862 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXJVSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:23:17 -0400
Date: Mon, 22 Oct 2007 19:22:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Alok kataria <alokkataria1@gmail.com>, Andi Kleen <ak@suse.de>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: ARCH_FREE_PTE_NR 5350 on x86_64
In-Reply-To: <200710152236.24789.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710221913250.18548@blonde.wat.veritas.com>
References: <35f686220710142354k66e1b9acwf65864b138ffd26@mail.gmail.com>
 <200710152236.24789.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Nick Piggin wrote:
> On Monday 15 October 2007 16:54, Alok kataria wrote:
> >
> > Looking at the tlb_flush code path and its co-relation with
> > ARCH_FREE_PTE_NR, on x86-64 architecture. I think we still don't use
> > the ARCH_FREE_PTE_NR of 5350 as the caching value for the mmu_gathers
> > structure, instead fallback to using 506 due to some typo errors in
> > the code.
> >
> > Found this link in the archives.
> >
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0509.1/1821.html
> >
> > I don't think anything has been done on this yet (looked at 2.6.23).
> > Do let me know if its only a typo that needs a fix, or we are still
> > waiting for some other other changes to come into effect.
> 
> ARCH_FREE_PTE_NR should probably just get ripped out completely at
> this point. Something similar (but working) could be added back if
> anybody actually had a workload where it helps to increase the mmu
> batch size.

Agreed.  No hurry, but thanks to Alok for reminding us.
CC'ing Ben since he's the one most active in mmu_gathering these days.
CC'ing Thomas lest he's puzzling over it in the x86 merge.

Hugh
