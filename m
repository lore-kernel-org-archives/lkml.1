Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbXI1Ia7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbXI1Ia7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXI1Iau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:30:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbXI1Iat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:30:49 -0400
Date: Fri, 28 Sep 2007 10:30:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
Message-ID: <20070928083037.GA18295@elte.hu>
References: <46FC2245.50907@tiscali.nl> <1190967450.18681.10.camel@chaos> <20070928012656.0bae3991.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928012656.0bae3991.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 28 Sep 2007 10:17:30 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > can we please add this to checkpatch.pl ? 
> > 
> > > -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> > > +DEFINE_SPINLOCK(bpci_lock);
> 
> That check is already in checkpatch.  Problem is that hardly anyone 
> runs the thing.

i automatically run it for every patch i submit or push out via git.

> I think we're ready to wire checkpatch up to a email robot which 
> monitors the mailing lists and sends people nastygrams.  I bet that'll 
> be popular ;)

heh ;-) It could be automated for patches that are sent out with a 
Signed-off-by [or a Reviewed-by] line. If you send a SoB patch that is 
broken, prepare to get a nastygram. (Initially i'd suggest the nastygram 
to Cc: to a different email list, not lkml.)

	Ingo
