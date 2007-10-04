Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbXJDUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbXJDUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXJDUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:52:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbXJDUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:52:22 -0400
Date: Thu, 4 Oct 2007 22:52:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: w@1wt.eu, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] printk: add KERN_CONT annotation
Message-ID: <20071004205212.GA26485@elte.hu>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org> <20071002043408.GM10199@1wt.eu> <20071002051852.GC28345@elte.hu> <20071004134320.a9160974.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004134320.a9160974.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 2 Oct 2007 07:18:52 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > printk: add the KERN_CONT annotation (which is empty string but via 
> > which checkpatch.pl can notice that the lacking KERN_ level is fine). 
> > This useful for multiple calls of hand-crafted printk output done by 
> > early debug code or similar.
> > 
> 
> I like it.  Sort of self-documenting notation.

cool. Please push into v2.6.24.

> >  #define console_loglevel (console_printk[0])
> > Index: linux/kernel/sched.c
> 
> I get rejects from the sched.c hunk and that's your stuff anwyay, so I 
> dropped that bit.

yeah, i'll fix sched.c up once it goes upstream.

	Ingo
