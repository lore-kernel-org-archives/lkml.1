Return-Path: <linux-kernel-owner+w=401wt.eu-S1764567AbYBWKCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764567AbYBWKCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758469AbYBWKBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:01:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbYBWKBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:01:52 -0500
Date: Sat, 23 Feb 2008 11:01:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/20] x86: Coding Style fixes to
	arch/x86/xen/multicalls.c
Message-ID: <20080223100140.GA23833@elte.hu>
References: <20080222231159.34dd5b5a@paolo-desktop> <1203720217.19319.99.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203720217.19319.99.camel@localhost>
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


* Joe Perches <joe@perches.com> wrote:

> >  			printk(KERN_ERR "%d multicall(s) failed: cpu %d\n",
> >  			       ret, smp_processor_id());
> > -			for(i = 0; i < b->mcidx; i++) {
> > +			for (i = 0; i < b->mcidx; i++) {
> >  				printk("  call %2d/%d: op=%lu arg=[%lx] result=%ld\n",
> 
> The printk needs a KERN_ERR prefix

yes - but we prefer to isolate the "does not change the .o in any way" 
cleanups from cleanups that materially change kernel behavior. (such as 
printing something else)

	Ingo
