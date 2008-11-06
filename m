Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYKFWYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYKFWYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYKFWYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:24:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYKFWYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:24:15 -0500
Date: Thu, 6 Nov 2008 23:23:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Message-ID: <20081106222347.GB7505@elte.hu>
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu> <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com> <4912943C.2090801@zytor.com> <1226008798.3023.23.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226008798.3023.23.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> On Wed, 2008-11-05 at 22:52 -0800, H. Peter Anvin wrote:
> > Yinghai Lu wrote:
> > >>
> > >> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
> > >> for good? Mind sending a patch for that too?
> > > 
> > > could remove CONFIG_PARAVIRT too.. Jeremy?
> > > 
> > 
> > This seems like a bad idea, especially for the embedded guys.
> 
> I'd actually really like to see us move to dynamically-allocated irq 
> tables as they're currently huge. But I haven't dug into it deeply 
> enough to see what sort of gotchas are involved.

sparseirq (== dynamic IRQ tables) is all implemented already, and most 
of the details except the final feature-enabler are upstream already.

	Ingo
