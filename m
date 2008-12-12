Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYLLLL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYLLLL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYLLLLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:11:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbYLLLLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:11:21 -0500
Date: Fri, 12 Dec 2008 12:11:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ] x86 : Fix compilation warning on paravirt-spinlocks.c
Message-ID: <20081212111107.GF32640@elte.hu>
References: <b9df5fa10812080656l21385db3ob08fc4f9ad3f1f76@mail.gmail.com> <20081208150942.GA22016@elte.hu> <b9df5fa10812092228qe618ablaca61adc05f947ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10812092228qe618ablaca61adc05f947ab@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On 12/8/08, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Rakib Mullick <rakib.mullick@gmail.com> wrote:
> >
> > no - this just works around the compiler warning.
> >
> >  Look at the real fix below i did some time ago. If you are into fixing
> >  warnings you should try tip/master, that has a ton of warning fixes
> >  already:
> >
> >   http://people.redhat.com/mingo/tip.git/README
> >
> >         Ingo
> Thanks, Ingo for explanation. In 'default_spin_lock_flags' function ,
> the 2nd argument unsigned long flags isn't used in the function. Is it
> necessary to keep it ?

yes, it's a function pointer used in a generic template:

        .spin_lock_flags = default_spin_lock_flags,

.spin_lock_flags() expects that parameter signature - even if in specific 
implementations the parameter might be unused.

	Ingo

	Ingo
