Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXDCGB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXDCGB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXDCGB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:01:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXDCGBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:01:25 -0400
Date: Tue, 3 Apr 2007 08:01:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: [PATCH] sched: staircase deadline misc fixes
Message-ID: <20070403060109.GA6708@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200703290944.45888.kernel@kolivas.org> <1175147455.6430.91.camel@Homer.simpson.net> <200704031237.21946.kernel@kolivas.org> <1175578270.6342.12.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175578270.6342.12.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > Try two instances of chew.c at _differing_ nice levels on one cpu on 
> > mainline, and then SD. This is why you can't renice X on mainline.
> 
> How about something more challenging instead :)
> 
> The numbers below are from my scheduler tree with massive_intr running 
> at nice 0, and chew at nice 5.  Below these numbers are 100 lines from 
> the exact center of chew's output.
> 
> (interactivity remains intact with this rather heavy load)

looks interesting - could you send the patch?

	Ingo
