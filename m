Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbXGKJFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbXGKJFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760165AbXGKJEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:04:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774AbXGKJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:04:50 -0400
Date: Wed, 11 Jul 2007 11:04:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vatsa@linux.vnet.ibm.com, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070711090423.GA6758@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710105240.GA20914@linux.vnet.ibm.com> <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org> <20070711045516.GH2927@linux.vnet.ibm.com> <20070710222942.382fc9ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710222942.382fc9ba.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > 	c. Enable group scheduling bits only in -mm for now (2.6.23-mmX), using
> > 	   Paul's container patches. I can send you a short patch that hooks up 
> > 	   cfs group scheduler with Paul's container infrastructure.
> > 
> > If a. is not possible, I would prefer c.
> > 
> > Let me know your thoughts ..
> 
> I'm inclined to take the cautious route here - I don't think people 
> will be dying for the CFS thingy (which I didn't even know about?) in 
> .23, and it's rather a lot of infrastructure to add for a CPU 
> scheduler configurator gadget (what does it do, anyway?)
> 
> We have plenty of stuff for 2.6.23 already ;)
> 
> Is this liveable with??

another option would be to trivially hook up CONFIG_FAIR_GROUP_SCHED 
with cpusets, and to offer CONFIG_FAIR_GROUP_SCHED in the Kconfig, 
dependent on CPUSETS and defaulting to off. That would give it a chance 
to be tested, benchmarked, etc.

	Ingo
