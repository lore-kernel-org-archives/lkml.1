Return-Path: <linux-kernel-owner+w=401wt.eu-S1764338AbXGQR0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764338AbXGQR0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXGQRZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:25:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42113 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbXGQRZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:25:57 -0400
Date: Tue, 17 Jul 2007 19:25:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070717172546.GC7905@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070717100300.821650f5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717100300.821650f5.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > +	if ((print_timestamp >= touch_timestamp &&
> > +			print_timestamp < (touch_timestamp + 1)) ||
> > +			did_panic || !per_cpu(watchdog_task, this_cpu)) {
> >  		return;
> > +	}
> >  
> >  	/* do not print during early bootup: */
> >  	if (unlikely(system_state != SYSTEM_RUNNING)) {
> 
> patch contains unneeded braces { }.

for multi-line conditions like the above they can be used.

	Ingo
