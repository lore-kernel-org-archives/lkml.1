Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbXB0KlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbXB0KlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXB0KlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:41:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987AbXB0KlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:41:14 -0500
Date: Tue, 27 Feb 2007 11:34:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070227103407.GA17819@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227103021.GA2250@kernel.dk>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0289]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > > x60 doesn't resume from S2R either, it doesn't matter if 
> > > CONFIG_NO_HZ is set or not though. 2.6.20 worked fine.
> > 
> > It somehow works for me. As long as I do not play with bluetooth and 
> > suspend to disk...
> 
> It locks solid here on resume, going back to 2.6.20 makes it work 
> perfectly again. In between 2.6.20 and 2.6.21-rc1 some ACPI change 
> broke resume, but that got fixed. Some other change later snuck in 
> that broke it AGAIN for me, sigh.
> 
> I don't use bluetooth nor suspend to disk.

resume is stock on my T60 too. So you mean v2.6.21-rc1 vanilla works 
fine? Do you know a commit ID that works for sure? I'd like to bisect 
this, but this way i might just find that ACPI change that got already 
fixed later on (and then got re-broken).

	Ingo
