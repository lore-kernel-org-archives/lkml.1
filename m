Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbYARQXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbYARQXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbYARQXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:23:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757866AbYARQXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:23:39 -0500
Date: Fri, 18 Jan 2008 17:22:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - enhance bt_ioremap
Message-ID: <20080118162257.GB6819@elte.hu>
References: <1200375906.3505.30.camel@caritas-dev.intel.com> <1200646105.17230.28.camel@cthulhu.hellion.org.uk> <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com> <4790BD90.9060303@zytor.com> <1200671665.9891.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200671665.9891.45.camel@localhost.localdomain>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> > Eric Biederman had a patchset that makes a PAE kernel use PAE page 
> > tables from the start.  That is really The Right Thing[TM].
> 
> That's much saner than dup'ing up the early ioremap stuff to support 
> both PAE and non-PAE at runtime, which is about the only idea I've got 
> for fixing this right now...
> 
> I think I'll just back out the early_ioremap patches locally for now 
> and wait for Eric's patches which should cause the fix for this issue 
> to just fall out in the wash.

Eric's patchset is nowhere near being submitted - he _had_ a patchset. 
So this needs to be fixed by the Xen-guest folks. (if the easiest/best 
fix is to pick up Eric's patchset, then plese do it so)

	Ingo
