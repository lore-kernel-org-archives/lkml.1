Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYINPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYINPxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYINPxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:53:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33471 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYINPxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:53:08 -0400
Date: Sun, 14 Sep 2008 17:52:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86, cpa: cpa related changes to be inline with
	TLB Application note
Message-ID: <20080914155251.GA13972@elte.hu>
References: <20080911203048.929515000@linux-os.sc.intel.com> <20080914084050.07e036d3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914084050.07e036d3@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> On Thu, 11 Sep 2008 13:30:48 -0700
> Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > Following patches fixes this behavior.
> > 
> > [1] http://developer.intel.com/design/processor/applnots/317080.pdf
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

applied them to tip/x86/pat:

3196625: x86, cpa: global flush tlb after splitting large page and before doing cpa
79abc89: x86, cpa: remove cpa pool code
e96d59b: x86, cpa: fix taking the pgd_lock with interrupts off
888fdd9: x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
e579af6: x86, cpa: make the kernel physical mapping initialization a two pass sequence
c86eefc: x86, cpa: remove USER permission from the very early identity mapping attribute
e8729a5: x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot

thanks!

	Ingo
