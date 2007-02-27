Return-Path: <linux-kernel-owner+w=401wt.eu-S1030586AbXB0Io7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586AbXB0Io7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932862AbXB0IoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:44:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030583AbXB0IoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:44:19 -0500
Date: Tue, 27 Feb 2007 09:33:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David P. Reed" <dpreed@reed.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       jgarzik@pobox.com, netdev@vger.kernel.org,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Bob Tracy <rct@gherkin.frus.com>, Mark Brown <broonie@sirena.org.uk>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Message-ID: <20070227083349.GB30376@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070226220521.GB29575@stusta.de> <1172564491.3709.5.camel@chaos> <45E3ECF1.4040906@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45E3ECF1.4040906@googlemail.com>
User-Agent: Mutt/1.4.2.2i
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


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Thomas Gleixner napisał(a):
> > Adrian,
> > 
> > On Mon, 2007-02-26 at 23:05 +0100, Adrian Bunk wrote:
> >> Subject    : kernel BUG at kernel/time/tick-sched.c:168  (CONFIG_NO_HZ)
> >> References : http://lkml.org/lkml/2007/2/16/346
> >> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> >> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> >> Status     : problem is being debugged
> > 
> > The BUG_ON() was replaced by a warning printk(). The BUG_ON() exposed a
> > problem with the SMT scheduler. See below.
> > 
> >> Subject    : BUG: soft lockup detected on CPU#0
> >>              NOHZ: local_softirq_pending 20  (SMT scheduler)
> >> References : http://lkml.org/lkml/2007/2/20/257
> >> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> >> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> >>              Ingo Molnar <mingo@elte.hu>
> >> Status     : problem is being debugged
> > 
> > Patch available, not confirmed yet.
> > 
> 
> I can confirm that the bug is fixed (over 20 hours of testing should 
> be enough).

thanks alot! I think this thing was a long-term performance/latency 
regression in HT scheduling as well.

	Ingo
