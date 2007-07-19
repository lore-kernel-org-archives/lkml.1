Return-Path: <linux-kernel-owner+w=401wt.eu-S935086AbXGSHqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086AbXGSHqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764406AbXGSHq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:46:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53451 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734AbXGSHq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:46:28 -0400
Date: Thu, 19 Jul 2007 09:46:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070719074609.GA12760@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719002231.069ebbdd.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > [this is -stable material too.]
> 
> This seems terribly sensitive.
> 
> Someone has broken the Vaio (shock, horror).  It now has mysterious 
> jerkiness: when leaning on autorepeat it stalls for maybe 0.25 seconds 
> every 1.5 seconds.  The stalls are far less than a second.  Yet this 
> is enough to trigger random softlockup warnings.
> 
> Some of those warnings are below.  Note that the traces are all pretty 
> useless, as softlockup warnings so often seem to be.

hm, you havent picked up the other softlockup enhancements i did, which 
make the warnings more useful.

	Ingo
