Return-Path: <linux-kernel-owner+w=401wt.eu-S965638AbXCMJ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965638AbXCMJ3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXCMJ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:29:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965638AbXCMJ3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:29:39 -0400
Date: Tue, 13 Mar 2007 10:29:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313092920.GB7648@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <1173762639.7944.45.camel@Homer.simpson.net> <20070313081805.GA22327@elte.hu> <200703132021.50712.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703132021.50712.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> Well I guess you must have missed where I asked him if he would be 
> happy if I changed +5 metrics to do whatever he wanted and he refused 
> to answer me. [...]

I'd say lets keep nice levels out of this completely for now - while 
they should work _too_, it's easy because the scheduler has the 'nice' 
information. The basic behavior of CPU hogs that matters most.

So the question is: if all tasks are on the same nice level, how does, 
in Mike's test scenario, RSDL behave relative to the current 
interactivity code?

	Ingo
