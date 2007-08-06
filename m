Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbXHFFg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbXHFFg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 01:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXHFFgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 01:36:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXHFFgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 01:36:49 -0400
Date: Mon, 6 Aug 2007 07:36:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>, Jeff Garzik <jeff@garzik.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [patch] implement smarter atime updates support, v2
Message-ID: <20070806053617.GB14881@elte.hu>
References: <46B4C0A8.1000902@garzik.org> <20070805102021.GA4246@unthought.net> <46B5A996.5060006@garzik.org> <20070805105850.GC4246@unthought.net> <20070805124648.GA21173@elte.hu> <alpine.LFD.0.999.0708050944470.5037@woody.linux-foundation.org> <20070805190928.GA17433@elte.hu> <20070805192226.GA20234@elte.hu> <20070805192838.GA21704@elte.hu> <20070805204220.GB32217@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805204220.GB32217@thunk.org>
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


* Theodore Tso <tytso@mit.edu> wrote:

> On Sun, Aug 05, 2007 at 09:28:38PM +0200, Ingo Molnar wrote:
> > 
> > added the relatime_interval sysctl that allows the changing of the 
> > atime update frequency. (default: 1 day / 86400 seconds)
> 
> What if you specify the interval as a per-mount option?  i.e.,
> 
> 	mount -o relatime=86400 /dev/sda2 /u1
> 
> If you had this, I don't think we would need the sysctl tuning 
> parameter.

it's much more flexible if there are _more_ options available. People 
can thus make use of the feature earlier, use it even on distros that 
dont support it yet, etc.

	Ingo
