Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbXHEHhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbXHEHhi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 03:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXHEHhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 03:37:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47652 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbXHEHha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 03:37:30 -0400
Date: Sun, 5 Aug 2007 09:37:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: J??rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805073709.GA6325@elte.hu>
References: <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804225121.5c7b66e0@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > it's also perhaps the most stupid Unix design idea of all times. 
> > Unix is really nice and well done, but think about this a bit:
> 
> Think about the user for a moment instead.
> 
> Do things right. The job of the kernel is not to "correct" for 
> distribution policy decisions. The distributions need to change 
> policy. You do that by showing the distributions the numbers.

you try to put the blame into distribution makers' shoes but in reality, 
had the kernel stepped forward with a neat .config option sooner 
(combined with a neat boot option as well to turn it off), we'd have had 
noatime systems 10 years ago. A new entry into relnotes and done. It's 
_much less_ of a compatibility impact than many of the changes that 
happen in a new distro release. (new glibc, new compiler, new kernel) 

Distro makers did not dare to do this sooner because some kernel 
developers came forward with these mostly bogus arguments ... The impact 
of atime is far better understood by the kernel community, so it is the 
responsibility of _us_ to signal such things towards distributors, not 
the other way around.

	Ingo
