Return-Path: <linux-kernel-owner+w=401wt.eu-S1763196AbXHFQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196AbXHFQRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXHFQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:17:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbXHFQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:17:05 -0400
Date: Mon, 6 Aug 2007 18:16:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       J??rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070806161634.GA1862@elte.hu>
References: <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu> <20070805072141.GA4414@elte.hu> <20070805184408.GB22639@redhat.com> <20070806063909.GB31321@elte.hu> <20070806155919.GA21066@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806155919.GA21066@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

>  > does it work with the "atime on steroids" patch below? (no need to 
>  > configure anything, just apply the patch and go.)
> 
> people have reported that relatime does work, but my util-linux isn't 
> new enough to support it, so I've never got it to work. I'll give your 
> diff a try later, though as it seems to be equivalent I expect it'll 
> work.

would still be nice if you could test it and report back :)

	Ingo
