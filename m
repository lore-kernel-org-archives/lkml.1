Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYGVL4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYGVL4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYGVLz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:55:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbYGVLz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:55:56 -0400
Date: Tue, 22 Jul 2008 13:55:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
Message-ID: <20080722115540.GA26178@elte.hu>
References: <200807221431.58991.rusty@rustcorp.com.au> <4885774E.3000909@goop.org> <20080722083626.GC2065@elte.hu> <200807222058.37130.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807222058.37130.rusty@rustcorp.com.au>
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

> On Tuesday 22 July 2008 18:36:26 Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > Rusty, in his peevish way, complained that macros defining constants
> > > should have a name which somewhat accurately reflects the actual
> > > purpose of the constant.
> >
> > Applied to tip/x86/cleanups anyway. Rusty will find out himself how bad
> > this whole concept of clean and understandable code is, soon enough!
> 
> I am disgusted with this inappropriate emphasis on clarity over 
> obscurity.  It should be pretty clear to everyone here that we can't 
> have both!
> 
> Fortunately, there is a way to partially rectify the situation. Ingo, 
> please apply.

> +/* There's something suspicious about this line: see PTE_PFN_MASK comment. */
>  #define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)

>  /* PTE_PFN_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
> +/* This line is quite subtle.  See __PHYSICAL_MASK comment above. */
>  #define PTE_PFN_MASK		((pteval_t)PHYSICAL_PAGE_MASK)

Now that you and Jeremy have thoroughly destroyed this file's obscurity 
with your disgusting cleanups and clarifications, i fear it's beyond 
repair. No matter how much i'd love to apply this infinitely recursive 
piece of documentation (what a genius it takes to even think of it!) i 
regret that i cannot. So sad.

	Ingo
