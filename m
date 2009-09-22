Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZIVJDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZIVJDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZIVJDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:03:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbZIVJDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:03:00 -0400
Date: Tue, 22 Sep 2009 11:02:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2] perf vs d-cache aliasses
Message-ID: <20090922090248.GA7755@elte.hu>
References: <20090921140848.444528343@chello.nl> <20090921.101021.193734103.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921.101021.193734103.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon, 21 Sep 2009 16:08:48 +0200
> 
> > 
> > based on your vmalloc code, an alternative implementation that lets 
> > x86 stay with regular allocations.
> > 
> > While I'm sad to have to propose having two implementations around, 
> > I see no other way to please both sides.
> 
> If you guys want to maintain two implementations of the same thing, 
> that's fine with me :)

I take this as an acked-by :-)

I'll reshape these patches on top of the counters -> events rename.

	Ingo
