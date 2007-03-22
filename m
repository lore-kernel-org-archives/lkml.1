Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXCVJHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXCVJHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXCVJHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:07:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030278AbXCVJHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:07:44 -0400
Date: Thu, 22 Mar 2007 10:06:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] lockdep: debug_show_all_locks &  debug_show_held_locks vs. debug_locks
Message-ID: <20070322090652.GC15328@elte.hu>
References: <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru> <20070321181635.GA570@tv-sign.ru> <20070322061119.GA1466@ff.dom.local> <20070322065759.GB1466@ff.dom.local> <1174548200.16411.6.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174548200.16411.6.camel@twins>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2007-03-22 at 07:57 +0100, Jarek Poplawski wrote:
> > And here is some addition.
> > 
> > [PATCH] lockdep: debug_show_all_locks &  debug_show_held_locks vs. debug_locks
> >  
> > lockdep's data shouldn't be used when debug_locks == 0
> > because it's not updated after this, so it's more misleading
> > than helpful.
> > 
> > PS: probably lockdep's current-> fields should be reset after
> > it turns debug_locks off: so, after printing a bug report, but
> > before return from exported functions, but there are really
> > a lot of these possibilities (e.g. after DEBUG_LOCKS_WARN_ON),
> > so, something could be missed. (Of course direct use of this
> > fields isn't recommended either.)
> > 
> > Reported-by: Folkert van Heusden <folkert@vanheusden.com>
> > Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
> > Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
