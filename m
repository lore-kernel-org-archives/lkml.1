Return-Path: <linux-kernel-owner+w=401wt.eu-S1763245AbYBSKOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763245AbYBSKOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYBSKN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:13:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759917AbYBSKN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:13:57 -0500
Date: Tue, 19 Feb 2008 11:13:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86_64: check msr to get mmconfig for amd family
	10h opteron v3
Message-ID: <20080219101335.GB14092@elte.hu>
References: <200802150127.21247.yinghai.lu@sun.com> <200802150128.41638.yinghai.lu@sun.com> <200802150130.14915.yinghai.lu@sun.com> <200802150131.16816.yinghai.lu@sun.com> <86802c440802181959t762bc242n79d2f0d93b224f31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802181959t762bc242n79d2f0d93b224f31@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> > +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> 
> Ingo/Thomas,
> 
> It seems you missed this one in the 5.
> 
> this one should be safe. it only reads msr.

we picked up all of your patches - have you checked the x86.git#testing 
branch, or only the x86.git#mm branch? We started x86.git#testing 
recently, it includes more bleeding-edge stuff and wider, cross-tree 
features as well.

> Andi had concern with other one that was touching msr. I will keep 
> that one in my local tree.

We've got that one queued up in x86.git#testing as well. Someone on lkml 
having concerns is not a basis to not deal with a patch. What matters 
is: are those concerns well-founded? If you do not agree with the 
concerns then just indicate it to us when re-submitting but do not drop 
patches. Your patches have a good track record so please do not let 
yourself get scared away from contributing. Please do not keep patches 
in your local tree, we'd like Linux to work fine out of box, on as broad 
range of hardware as possible.

	Ingo
