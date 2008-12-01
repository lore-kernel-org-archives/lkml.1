Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYLATk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYLATk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYLATkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:40:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51026 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYLATkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:40:16 -0500
Date: Mon, 1 Dec 2008 20:40:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH v2] sched: add uid information to sched_debug for
	CONFIG_USER_SCHED
Message-ID: <20081201194007.GC17250@elte.hu>
References: <20081201112954.GH20329@linux.vnet.ibm.com> <1228131416.7251.306.camel@twins> <20081201124452.GA21534@elte.hu> <20081201125628.GA25438@elte.hu> <20081201151905.GA8448@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201151905.GA8448@linux.vnet.ibm.com>
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


* Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2008-12-01 13:56:28]:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > On Mon, 2008-12-01 at 16:59 +0530, Arun R Bharadwaj wrote:
> > > > > Hi,
> > > > > 
> > > > > This patch adds uid information in sched_debug for CONFIG_USER_SCHED
> > > > 
> > > > I'd much rather have people working at removing USER_SCHED,. but sure,
> > > > the patch looks sane..
> > > 
> > > ok, i have applied it to tip/sched/core.
> > 
> > it doesnt build:
> > 
> >  kernel/sched_debug.c: In function 'print_cfs_rq':
> >  kernel/sched_debug.c:165: error: 'struct cfs_rq' has no member named 'tg'
> > 
> > please send v2 patch.
> > 
> > Ingo
> 
> Hi Ingo,
> 
> I've posted v2 of the patch.
> Had missed an '&& #if defined(CONFIG_FAIR_GROUP_SCHED)' last time
> around.

applied, thanks!

	Ingo
