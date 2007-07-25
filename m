Return-Path: <linux-kernel-owner+w=401wt.eu-S1764095AbXGYLE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764095AbXGYLE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbXGYLEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:04:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759717AbXGYLEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:04:20 -0400
Date: Wed, 25 Jul 2007 13:04:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070725110402.GA19060@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070725014912.35c7e325.akpm@linux-foundation.org> <20070725085204.GA22067@elte.hu> <20070725020003.63144fd6.akpm@linux-foundation.org> <20070725090439.GA26286@elte.hu> <20070725021730.a9a624b3.akpm@linux-foundation.org> <20070725092342.GA29814@elte.hu> <20070725095910.GL3287@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725095910.GL3287@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > Subject: blktrace: use cpu_clock() instead of sched_clock()
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > use cpu_clock() instead of sched_clock(). (the latter is not a proper
> > clock-source)
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> I tested it, seems to work fine for me.
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>

great! Now that cpu_clock() is in Linus' tree, could you put this patch 
into your block.git tree and merge it (once you think it should go 
upstream) together with other IO related fixes?

	Ingo
