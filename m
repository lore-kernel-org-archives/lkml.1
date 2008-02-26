Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbYBZJZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbYBZJZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759350AbYBZJZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:25:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbYBZJZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:25:19 -0500
Date: Tue, 26 Feb 2008 10:24:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, dada1@cosmosbay.com,
       herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: include/linux/pcounter.h
Message-ID: <20080226092454.GA10987@elte.hu>
References: <20080216025051.751b4a86.akpm@linux-foundation.org> <47B6D12A.3090401@cosmosbay.com> <20080216112618.ec450f9b.akpm@linux-foundation.org> <20080216.215401.20463603.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216.215401.20463603.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Sat, 16 Feb 2008 11:26:18 -0800
> 
> > On Sat, 16 Feb 2008 13:03:54 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> > > Yes, per connection basis. Some workloads want to open/close more 
> > > than 1000 sockets per second.
> > 
> > ie: slowpath
> 
> Definitely not slow path in the networking.
> 
> Connection rates are definitely as, or more, important than packet 
> rates for certain workloads.

but the main and fundamental question still remains unanswered (more 
than 3 weeks after Andrew asked that question): why was this piece of 
general infrastructure merged via net.git and not submitted to lkml 
ever? The code touching -mm does _not_ count as "review".

Now that there was review of it and there is clearly controversy, the 
code should be reverted/undone and resubmitted after all review 
observations have been addressed. Just sitting around and ignoring 
objections, hoping for the code to hit v2.6.25 is rather un-nice ...

	Ingo
