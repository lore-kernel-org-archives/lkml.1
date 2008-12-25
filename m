Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYLYQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYLYQts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 11:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYLYQtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 11:49:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYLYQti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 11:49:38 -0500
Date: Thu, 25 Dec 2008 17:49:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Message-ID: <20081225164921.GA28464@elte.hu>
References: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > > > +#include <linux/irq.h>
> > > > 
> > > > looks good, but linux/irq.h cannot be included on all architectures. (for 
> > > > example s390 has no notion of 'hardirqs'). But we created linux/irqnr.h 
> > > > for this purpose - so including that should work better.
> > > 
> > > Oh, thanks good explain.
> > > I'll fix soon.
> > 
> > next spin is here.
> > I confirmed three architecture.
> > 
> >  1. alpha (without SPARSE_IRQ, build test by cross compiler only)
> >  2. ia64 (without SPARSE_IRQ)
> >  3. x86_64 (with SPARSE_IRQ)
> 
> 
> Is this good idea?
> this patch also tested on above three architecture.

yes, this is a nice cleanup too!

	Ingo
