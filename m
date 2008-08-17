Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYHQJbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYHQJbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 05:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYHQJba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 05:31:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYHQJb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 05:31:29 -0400
Date: Sun, 17 Aug 2008 11:31:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,
	write_trylock_irqsave
Message-ID: <20080817093114.GA21303@elte.hu>
References: <20080816095951.GA19926@martell.zuzino.mipt.ru> <20080816134600.GC20652@elte.hu> <20080816210439.GB5151@martell.zuzino.mipt.ru> <87pro8psk1.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pro8psk1.fsf@skyscraper.fehenstaub.lan>
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


* Johannes Weiner <hannes@saeurebad.de> wrote:

> >> (but it would also be hugely invasive, with not much upside with 
> >> tons of downside like years of migration fallout and having to 
> >> rewrite hundreds of kernel hacking books ;-) )
> >
> > I want my money back for scheduler chapter from "Understanding the 
> > Linux Kernel"!
> 
> I agree that this argument of Ingo's is not a very good one... ;)

i see the smiley, but still - there's a huge difference between the 
"pain" caused by a much better scheduler [ hey, did you expect me to say 
anything else? ;-) ] and a rather arbitrary value->pointer parametering 
change to a core API that is used _everywhere_.

	Ingo
