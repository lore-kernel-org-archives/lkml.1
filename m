Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbXD0Nma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbXD0Nma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbXD0Nm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:42:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbXD0Nm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:42:28 -0400
Date: Fri, 27 Apr 2007 15:41:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070427134100.GA26050@elte.hu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177681144.25960.117.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177681144.25960.117.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > Kasper, just to exclude the possibility that this is somehow related 
> > to IO scheduling, could you copy the OGG file over to /dev/shm and 
> > play it from there? Do you still get the bad skips?
> 
> That's what I can observe here:
> 
> ogg123 local harddisk	skips
> ogg123 nfs		works
> ogg123 /dev/shm		works
> 
> The skips when running from the local harddisk are definitely caused 
> by the I/O scheduler or some other bottleneck in the 
> block/disk/scsi/sata jungle. I try to find out more details.

and is it independent of the scheduler - i.e. can you see this skipping 
on vanilla too?

	Ingo
