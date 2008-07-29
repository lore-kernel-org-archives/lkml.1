Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYG2I6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYG2I6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYG2I6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:58:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbYG2I6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:58:40 -0400
Date: Tue, 29 Jul 2008 10:58:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: build failure
Message-ID: <20080729085815.GA1301@elte.hu>
References: <20080729162300.733b3e09.sfr@canb.auug.org.au> <20080729080055.GA28916@elte.hu> <20080729180317.94c64634.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729180317.94c64634.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Tue, 29 Jul 2008 10:00:55 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > > -#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
> > > +#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
> > 
> > hm, i'm wondering - is this a compiler bug?
> 
> Or maybe a deficiency in such an old compiler (v3.4.5) but the fix 
> makes sense anyway, right?

yeah, i was just wondering.

	Ingo
