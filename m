Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYDRMtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYDRMtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbYDRMs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:48:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbYDRMs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:48:57 -0400
Date: Fri, 18 Apr 2008 14:48:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080418124834.GB20857@elte.hu>
References: <20080418074736.GA27579@elte.hu> <20080418010008.2fb29e5c.akpm@linux-foundation.org> <20080418081113.GA789@infradead.org> <20080418.011858.228414800.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418.011858.228414800.davem@davemloft.net>
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

> > > include/asm/pgtable.h: In function `set_pte_at':
> > > include/asm/pgtable.h:670: warning: `init_mm' is deprecated (declared at include/linux/sched.h:1616)
> > 
> > Why is is deprecated anyway?  I think we all agreed that killing the 
> > export is good, but I don't see any way how we could kill the core 
> > useage.
> 
> set_pte_at() is done inside drivers and what-not, you're not going to 
> be able to get rid of this export so easily.

ok, good point, i zapped this change [it was in the x86/testing section 
anyway, i.e. not to be pushed upstream as an x86 change] - and if it's 
resubmitted it should be sent to -mm anyway. Arjan, what do you think?

	Ingo
