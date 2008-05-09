Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYEIJnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYEIJnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYEIJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:43:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbYEIJnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:43:08 -0400
Date: Fri, 9 May 2008 11:42:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
Message-ID: <20080509094224.GD16037@elte.hu>
References: <48222C7C.2050807@googlemail.com> <20080507154155.2b472bb1.akpm@linux-foundation.org> <482233CD.70502@googlemail.com> <4822DD4E.3010000@googlemail.com> <1210245238.13978.199.camel@twins> <4822E23F.8040101@googlemail.com> <1210325973.13978.216.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210325973.13978.216.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Subject: sched: fixup sched-clock offset
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> It could happen that ktime doesn't start at 0.

applied, thanks Peter. I'm wondering which clocks do this - HPET 
perhaps?

	Ingo
