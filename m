Return-Path: <linux-kernel-owner+w=401wt.eu-S1764049AbXGYNFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764049AbXGYNFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbXGYNFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:05:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbXGYNFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:05:39 -0400
Date: Wed, 25 Jul 2007 15:05:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
Message-ID: <20070725130536.GA12334@elte.hu>
References: <469600F7.3060603@free.fr> <20070723095357.GA886@elte.hu> <46A4B7C2.1070304@free.fr> <20070723160442.GA7995@elte.hu> <46A5B8E3.4060004@free.fr> <46A74A58.1070704@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A74A58.1070704@free.fr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John Sigler <linux.kernel@free.fr> wrote:

> >With a pair of the following in the middle:
> >
> >softirq--4     0....  670us : call_rcu (rt_run_flush)
> >softirq--4     0D..1  670us : __rcu_advance_callbacks (call_rcu)

> Any idea what went wrong in the above function trace? Why is the 
> kernel spinning in circles that way?

does your test-app have higher priority than softirq--4 ?

	Ingo
