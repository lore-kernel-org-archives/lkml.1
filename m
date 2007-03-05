Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbXCEPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbXCEPti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933544AbXCEPth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:49:37 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:36006 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541AbXCEPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:49:36 -0500
Date: Mon, 5 Mar 2007 17:44:45 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070305154422.GA4798@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302080441.GA12785@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: 2.6.21-rc1: known regressions (part 2)
> 
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > I'll try what i've described in the previous mail: mark all bisection 
> > points that do not include f3ccb06f as 'good' - thus 'merging' the 
> > known-bad area with the first known-good commit, and thus eliminating 
> > it from the bisection space.
> 
> this got me quite a bit further:
> 
>  git-bisect start
>  git-bisect bad       01363220f5d23ef68276db8974e46a502e43d01d
>  git-bisect good      f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 
>  git-bisect fake-good ee404566f97f9254433399fbbcfa05390c7c55f7
>  git-bisect bad       d43a338e395371733a80ec473b40baac5f74d768
>  git-bisect bad       255f0385c8e0d6b9005c0e09fffb5bd852f3b506
>  git-bisect fake-good f99c6bb6e2e9c35bd3dc0b1d0faa28bd6970930d
>  git-bisect fake-good 0187f221e96e3436d552c0c7143f183eb82fb658
>  git-bisect bad       81450b73dde07f473a4a7208b209b4c8b7251d90
>  git-bisect fake-good ef29498655b18d2bfd69048e20835d19333981ab
>  git-bisect fake-good 8a03d9a498eaf02c8a118752050a5154852c13bf
>  git-bisect good      5c95d3f5783ab184f64b7848f0a871352c35c3cf
>  git-bisect good      ecb5f7521a309cb9c5fc0832b9705cd2a03d7d45
>  git-bisect good      0539771d7236b425f285652f6f297cc7939c8f9a

I just confirmed that 0539771d7236b425f285652f6f297cc7939c8f9a
is good for me, too.

>  81450b73dde07f473a4a7208b209b4c8b7251d90 is first bad commit

Going to test that now.

-- 
MST
