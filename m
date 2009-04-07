Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZDGGRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZDGGRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZDGGR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:17:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbZDGGR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:17:26 -0400
Date: Tue, 7 Apr 2009 08:15:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
Message-ID: <20090407061558.GA31261@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu> <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239084280.22733.404.camel@macbook.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> I think the problem here is actually the fact that we used 
> 'select' instead of proper dependencies. I wouldn't normally have 
> used the abomination that is 'select', but since I was just moving 
> things around I ended up doing so by accident.

Yeah, it's genuinely fragile.

> X2APIC currently selects INTR_REMAP, and the bug would never have 
> happened if we'd made X2APIC _depend_ on INTR_REMAP instead.
>
> This is a better fix:

Yep, that patch looks better - it gets rid of a select and 
establishes proper dependencies - applied it to x86/urgent
and will get it to Linus later today.

Thanks,

	Ingo
