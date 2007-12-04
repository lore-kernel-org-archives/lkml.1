Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbXLDV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbXLDV5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXLDV5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:57:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXLDV5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:57:42 -0500
Date: Tue, 4 Dec 2007 22:57:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
	occurs
Message-ID: <20071204215716.GA16446@elte.hu>
References: <474CF7D5.6010702@cn.fujitsu.com> <474D05AE.60905@cn.fujitsu.com> <20071204130218.GE31590@elte.hu> <20071204215251.60C6326F8D9@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204215251.60C6326F8D9@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> > > Thank you for your detailed explanation and patch. I tested your 
> > > patch, unfortunately it can not stop all kinds of overflow.
> > [...]
> > > So, the patch I posted is still needed 
> > 
> > thanks, i've picked up your fix for x86.git, for 2.6.25 merging.
> 
> I just explained that not all overflows would be caught and that doing 
> so would violate the semantics of e.g. longjmp.  I don't see how the 
> patch you've included now doesn't still have all those problems.  I 
> think it's wrong.

ok, i've dropped it and reinstated your original fix - i missed that 
detail.

	Ingo
