Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXHFHVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXHFHVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbXHFHU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:20:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbXHFHU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:20:58 -0400
Date: Mon, 6 Aug 2007 09:20:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 4/9] ifdef raise_softirq_irqoff wakeup
Message-ID: <20070806072052.GG5359@elte.hu>
References: <20070730024534.369897977@mvista.com> <20070730024719.782847315@mvista.com> <20070730092751.GD25640@elte.hu> <1185810537.2636.19.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185810537.2636.19.camel@imap.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Mon, 2007-07-30 at 11:27 +0200, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > @@ -508,7 +508,9 @@ inline fastcall void raise_softirq_irqof
> > >  {
> > >  	__do_raise_softirq_irqoff(nr);
> > >  
> > > +#ifdef CONFIG_PREEMPT_SOFTIRQS
> > >  	wakeup_softirqd(nr);
> > > +#endif
> > 
> > thanks, applied. People rarely run the -rt kernel just to turn off 
> > PREEMPT_RT, that's why this bug was there ;-)
> 
> Ultimately, all modes should function correctly right?

yes, of course - especially once any of the components nears upstream 
integration ;-)

	Ingo
