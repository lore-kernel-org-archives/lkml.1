Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYBQTvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYBQTvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYBQTvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:51:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYBQTvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:51:03 -0500
Date: Sun, 17 Feb 2008 20:50:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       Linux Mailing List <linux-kernel@vger.kernel.org>,
       "Huang, Ying" <ying.huang@intel.com>
Subject: Re: arch/x86/mm/ioremap unification grew by 10x
Message-ID: <20080217195041.GA20850@elte.hu>
References: <1203107155.12383.230.camel@cinder.waste.org> <20080215203228.GA4295@uranus.ravnborg.org> <1203110488.12383.231.camel@cinder.waste.org> <1203117425.12383.238.camel@cinder.waste.org> <1203275382.27987.20.camel@localhost.localdomain> <20080217192840.GH14588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217192840.GH14588@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> >  static __initdata int after_paging_init;
> > -static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
> > -				__attribute__((aligned(PAGE_SIZE)));
> > +static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
> 
> Replace
> > +		__attribute__((__section__(".bss.page_aligned")));
> 
> with the shorter form:
> > +		__section(.bss.page_aligned)));

i've picked up Ian's patch into x86.git and have done the above change. 
Thanks,

	Ingo
