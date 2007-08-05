Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbXHEHSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbXHEHSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 03:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXHEHSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 03:18:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57076 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbXHEHSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 03:18:30 -0400
Date: Sun, 5 Aug 2007 09:18:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805071801.GD515@elte.hu>
References: <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804224706.617500a0@the-village.bc.nu>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Linux has always been a "POSIX unless its stupid" type of system.  
> > For the upstream kernel, we should do the right thing -- noatime by 
> > default -- but allow distros and people that care about rigid 
> > compliance to easily change the default.
> 
> Linux has never been a "suprise your kernel interfaces all just 
> changed today" kernel, nor a "gosh you upgraded and didn't notice your 
> backups broke" kernel.

HSM uses atime as a _hint_. The only even remotely valid argument is 
Mutt, and even that one could easily be fixed _it is not even installed 
by default on most distros_ and nobody but me uses it ;) [and i've been 
using Mutt on noatime filesystems for years] So basically a single type 
of package and use-case (against tens of thousands of packages) held all 
of Linux desktop IO performance hostage for 10 years, to the tune of a 
20-30-50-100% performance degradation (depending on the workload)? Wow. 

And the atime situation is _so_ obvious, what will we do in the much 
less obvious cases?

	Ingo
