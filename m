Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbXFVHpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbXFVHpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXFVHpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:45:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48661 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXFVHpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:45:03 -0400
Date: Fri, 22 Jun 2007 09:43:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 1/6] Convert the RCU tasklet into a softirq
Message-ID: <20070622074344.GA9472@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622040136.621853953@goodmis.org> <20070622071039.GB21291@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622071039.GB21291@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Jun 22, 2007 at 12:00:15AM -0400, Steven Rostedt wrote:
> > I believe this was originally done by Dipankar Sarma. I pulled these
> > changes from the -rt kernel.
> > 
> > For better preformance, RCU should use a softirq instead of a
> > tasklet.
> 
> I was under the imporession we had merged this a while ago due to 
> tasklet bottlenecks on big machines.  Any reason why it has been 
> delayed so long?

i thought so too, up until a few weeks ago. I think i might have mixed 
it up mentally with the scheduler rebalancing tasklet: that was 
converted to softirqs on my request and made me forget about the RCU 
tasklet thing.

	Ingo
