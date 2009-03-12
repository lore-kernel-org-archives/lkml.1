Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZCLM2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZCLM2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZCLM2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:28:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbZCLM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:28:33 -0400
Date: Thu, 12 Mar 2009 13:27:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: Re: [PATCH 1/2] x86: unify kmap_atomic_pfn() and
	iomap_atomic_prot_pfn()
Message-ID: <20090312122727.GA24856@elte.hu>
References: <20090311143317.GA22244@localhost.localdomain> <alpine.LFD.2.00.0903111606350.29264@localhost.localdomain> <961aa3350903110825y1af77709q49d6328703081afb@mail.gmail.com> <20090311165252.GB30777@elte.hu> <961aa3350903111728m6203106tf74a767f1a82e663@mail.gmail.com> <20090312122427.GA24295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312122427.GA24295@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > It actually didn't compile with CONFIG_HIGHMEM=n as Thomas 
> > pointed out.
> > 
> > arch/x86/mm/iomap_32.c:49: undefined reference to 
> > `kmap_atomic_prot_pfn'
> 
> hm, i didnt see any build failures myself. Could you please 
> send the .config that triggers it?

got it now. Somehow randconfig does not find that combo.

	Ingo
