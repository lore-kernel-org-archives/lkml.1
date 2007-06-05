Return-Path: <linux-kernel-owner+w=401wt.eu-S1765995AbXFEUiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765995AbXFEUiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765380AbXFEUh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:37:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765356AbXFEUh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:37:57 -0400
Date: Tue, 5 Jun 2007 22:37:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-ID: <20070605203720.GA5519@elte.hu>
References: <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com> <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu> <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org> <20070604122857.1399e3fc.dada1@cosmosbay.com> <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com> <20070604152540.985c186a.dada1@cosmosbay.com> <20070604141235.GA24352@elte.hu> <20070604162721.500211c9.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604162721.500211c9.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> > For example, the recent futex.c changes you did in commit 34f01cc1 
> > are, and unfortunately there's no better word i can find: plain 
> > disgusting. You apparently have plopped the 'fshared' code into the 
> > existing logic via conditionals and have blown up the complexity of 
> > the functions for no good reason - instead of neatly separating them 
> > out. You have added _33_ (thirty-three!) new 'if' branches to 
> > futex.c! The feature you introduced is nice and useful, but for 
> > heaven's sake please work on cleanliness of your code some more and 
> > undo that colossal damage ... preferably before working on other 
> > areas of the kernel.
> 
> This code took the normal path for inclusion and discussion. If you 
> find it so horrible, you should complained before. Fact is that you 
> Acked it :)

yes, of course, i still think it's a good and nice patch, all things 
considered =B-)

> If you wanted to make a joke, I find it quite misplaced.

no, i just wanted to make a demonstration that one can be pretty nasty 
in on-lkml replies while being technically correct :-) I think you went 
a bit overboard in your replies to Davide. Lets move this back into 
constructive channels, ok? :)

	Ingo
