Return-Path: <linux-kernel-owner+w=401wt.eu-S939767AbXGSQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939767AbXGSQWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936011AbXGSQVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:21:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56149 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935991AbXGSQVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:21:44 -0400
Date: Thu, 19 Jul 2007 18:21:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: implement cpu_clock(cpu) high-speed time source,
	take #2
Message-ID: <20070719162114.GA6154@elte.hu>
References: <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu> <469F8179.2060802@goop.org> <20070719154254.GA24225@elte.hu> <20070719154449.GA28998@elte.hu> <469F8D28.1010304@goop.org> <20070719161643.GA5153@elte.hu> <469F8EBE.5020703@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F8EBE.5020703@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > yeah, that's the idea.
> 
> Good.  But the real question: does it help Andrew?

that's still an important question, but these changes are still needed 
nevertheless, to unbreak softlockup.c ... I havent been watching while 
doing CFS :-/

	Ingo
