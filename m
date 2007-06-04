Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbXFDIGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbXFDIGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXFDIFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:05:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53470 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXFDIFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:05:54 -0400
Date: Mon, 4 Jun 2007 10:05:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-ID: <20070604080537.GA22898@elte.hu>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1> <46633047.1020707@cosmosbay.com> <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com> <20070603230859.5000424d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070603230859.5000424d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I must say that it's not really clear to me why this fdmap thing was 
> created.  Exactly what problem is it solving, and what properties is 
> it designed to have?
> 
> Could not a (prehaps suitably modified) IDR tree have adequately 
> provided those properties?
> 
> I'm sure it's good stuff, but the patches were presented as if we all 
> know what they're for.  But I don't.  Maybe I was asleep at the time.

i think this sums it up:

 http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.3/2490.html

and some more, with a benchmark as well:

 http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-05/msg13685.html

( blame Google for picking up two different lkml archives for the two
  searches i did :-)

	Ingo
