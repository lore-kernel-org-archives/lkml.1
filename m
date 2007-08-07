Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXHGHGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXHGHGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXHGHG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:06:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbXHGHG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:06:28 -0400
Date: Tue, 7 Aug 2007 09:05:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       J??rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070807070521.GC19745@elte.hu>
References: <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org> <20070804194259.GA25753@lazybastard.org> <20070805203602.GB25107@infradead.org> <46B7626C.6050403@redhat.com> <20070806203710.39bdc42e@the-village.bc.nu> <46B77AB3.40006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B77AB3.40006@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.0.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1444]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> > Ingo's latest 'not quite noatime' seems to cure mutt/tmpwatch so it 
> > might finally make sense to do so.
> 
> Do we report max(ctime, mtime) as the atime by default when noatime is 
> set or do we still need that to be done?

noatime is unchanged by my patch (it is not the same as the 'improved 
relatime' mode my patch activates), but it would make sense to do your 
change, independently.

	Ingo
