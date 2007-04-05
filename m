Return-Path: <linux-kernel-owner+w=401wt.eu-S1766950AbXDELzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766950AbXDELzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766955AbXDELzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:55:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766950AbXDELzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:55:07 -0400
Date: Thu, 5 Apr 2007 13:54:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: [test] sched: SD-latest versus Mike's latest
Message-ID: <20070405115447.GA24138@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200703290944.45888.kernel@kolivas.org> <1175147455.6430.91.camel@Homer.simpson.net> <200704031237.21946.kernel@kolivas.org> <1175578270.6342.12.camel@Homer.simpson.net> <20070403060109.GA6708@elte.hu> <1175770950.6609.16.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175770950.6609.16.camel@Homer.simpson.net>
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

> On Tue, 2007-04-03 at 08:01 +0200, Ingo Molnar wrote:
> 
> > looks interesting - could you send the patch?
> 
> Ok, this is looking/feeling pretty good in testing.  Comments on 
> fugliness etc much appreciated.
>
> Below the numbers is a snapshot of my experimental tree.  It's a 
> mixture of my old throttling/anti-starvation tree and the task 
> promotion patch, with the addition of a scheduling class for 
> interactive tasks to dish out some of that targeted unfairness I 
> mentioned.

here's some test results, comparing SD-latest to Mike's-latest:

re-testing the weak points of the vanilla scheduler + Mike's:

 - thud.c:    this workload has almost unnoticeable effect
 - fiftyp.c:  noticeable, but alot better than previously!

re-testing the weak points of SD:

 - hackbench: still unusable under such type of high load - no improvement.
 - make -j:   still less interactive than Mike's - no improvement.

	Ingo
