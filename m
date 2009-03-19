Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbZCSIYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbZCSIYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZCSIXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:23:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZCSIXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:23:48 -0400
Date: Thu, 19 Mar 2009 09:23:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git-pull -tip] x86: mpparse cleanup
Message-ID: <20090319082328.GB32179@elte.hu>
References: <1237314836.3212.10.camel@localhost.localdomain> <1237380351.3042.0.camel@ht.satnam> <20090318141115.GA23034@elte.hu> <1237392355.12866.2.camel@ht.satnam> <20090318161829.GC21331@elte.hu> <20090318163933.GA29854@elte.hu> <1237396487.22438.2.camel@ht.satnam> <20090318190257.GB16286@elte.hu> <1237403503.22438.21.camel@ht.satnam> <alpine.LFD.2.00.0903182254060.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903182254060.29264@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 19 Mar 2009, Jaswinder Singh Rajput wrote:
> > > > 
> > > > As I told you earlier, I cannot check this on my side. Only 
> > > > suspect will be check_irq_src() please test this patch if this 
> > > > does not work I will revert check_irq_src():
> > > 
> > > no need to test on your side. If a patch is broken the first step is 
> > > to take a look at the patch and think about it. For example this 
> > > block:
> > > 
> > 
> > Subject: [PATCH] x86: mpparse introduced few helper functions
> > 
> > Introduced helper functions:
> > skip_entry, smp_reserve_bootmem, check_irq_src and check_slot
> 
> And to make review and testing simpler can we please have separate 
> patches for those helper functions as far as it is possible.

yes - that's definitely a good idea for the future. I'll give the 
fix another chance in testing - if it fails again we have to 
risk-reduce by doing more splitups.

	Ingo
