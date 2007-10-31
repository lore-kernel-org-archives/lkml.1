Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbXJaKSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbXJaKSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXJaKSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:18:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXJaKSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:18:13 -0400
Date: Wed, 31 Oct 2007 11:17:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
Message-ID: <20071031101746.GC5817@elte.hu>
References: <1193788979.5623.43.camel@localhost.localdomain> <p73odeg2l9v.fsf@bingen.suse.de> <20071031081513.GB3810@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031081513.GB3810@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Oct 31, 2007 at 01:14:04AM +0100, Andi Kleen wrote:
> > One (mostly psychological, but still serious) problem is that stack
> > dumps make panics always look like kernel bugs.  But there are panics
> > which are definitely not kernel bugs: like the popular cannot mount
> > root or machine checks or a couple of others.
> 
> But that one really shouldn't be a panic anyway.  The panic alone is 
> psycologically bad enough for users.  I think it would be best to have 
> a simple scanf loop asking for another root device..

yep. Steve's patch looks good in any case.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
