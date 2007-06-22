Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXFVOF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXFVOF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbXFVOFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:05:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbXFVOFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:05:17 -0400
Date: Fri, 22 Jun 2007 16:00:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rostedt@goodmis.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, johnstul@us.ibm.com,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622140024.GA1409@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622070948.GA21291@infradead.org> <1182515542.5493.20.camel@localhost.localdomain> <20070622123805.GA9770@elte.hu> <1182517124.5493.38.camel@localhost.localdomain> <20070622061326.2e2d6d15.akpm@linux-foundation.org> <20070622132622.GA21130@elte.hu> <20070622064159.b762cb13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622064159.b762cb13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > there are 120 tasklet_init()s in the tree and 224 
> > tasklet_schedule()s.
> 
> couple of hours?

hm, what would you replace it with? Another new API? Or to workqueues 
with a manual adding of a local_bh_disable()/enable() pair around the 
worker function? If the latter, then converting it to workqueues isnt 
just a couple of hours i think. Maybe i'm overestimating the effort.

	Ingo
