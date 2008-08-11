Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbYHKLnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYHKLnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYHKLng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:43:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYHKLnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:43:35 -0400
Date: Mon, 11 Aug 2008 13:43:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [revert] mysql+oltp regression
Message-ID: <20080811114324.GA23529@elte.hu>
References: <1218454322.25098.24.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218454322.25098.24.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Greetings,
> 
> During regression testing of tip/sched/clock fixes, a regression in 
> low client count throughput turned up, which I traced this back to the 
> commit below.  I don't see anything wrong with it, but suspect that it 
> is preventing client/server pairs from staying together on the same 
> CPU as buddies, which mysql definitely likes quite a lot.  (I suspect 
> that this is the case, because I've seen this same performance curve 
> while tinkering with wakeup affinity and breaking it all to pieces;)
> 
> Changelog and test results below in case nobody sees a problem with 
> the commit itself.

i've applied your fix to tip/sched/urgent for the time being, thanks 
Mike for tracking it down. We can re-try newer iterations of Greg's 
patch in tip/sched/devel.

	Ingo
