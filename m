Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZCLMZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZCLMZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbZCLMYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:24:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33379 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbZCLMYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:24:54 -0400
Date: Thu, 12 Mar 2009 13:24:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: Re: [PATCH 1/2] x86: unify kmap_atomic_pfn() and
	iomap_atomic_prot_pfn()
Message-ID: <20090312122427.GA24295@elte.hu>
References: <20090311143317.GA22244@localhost.localdomain> <alpine.LFD.2.00.0903111606350.29264@localhost.localdomain> <961aa3350903110825y1af77709q49d6328703081afb@mail.gmail.com> <20090311165252.GB30777@elte.hu> <961aa3350903111728m6203106tf74a767f1a82e663@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961aa3350903111728m6203106tf74a767f1a82e663@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> 2009/3/12 Ingo Molnar <mingo@elte.hu>:
> >
> > * Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >
> >> 2009/3/12 Thomas Gleixner <tglx@linutronix.de>:
> >> > On Wed, 11 Mar 2009, Akinobu Mita wrote:
> >> >> kmap_atomic_pfn() and iomap_atomic_prot_pfn() are almost same except
> >> >> pgprot. This patch removes the code duplication for these two functions.
> >> >
> >> > How exaclty does this compile with CONFIG_HIGHMEM=n ?
> >> >
> >>
> >> Oh, I didn't try without CONFIG_HIGHMEM.
> >
> > i had it applied in testing locally and didnt see problems so
> > far. Let me know if you can see any problems.
> 
> It actually didn't compile with CONFIG_HIGHMEM=n as Thomas 
> pointed out.
> 
> arch/x86/mm/iomap_32.c:49: undefined reference to 
> `kmap_atomic_prot_pfn'

hm, i didnt see any build failures myself. Could you please send 
the .config that triggers it?

	Ingo
