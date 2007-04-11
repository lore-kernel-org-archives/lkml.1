Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbXDKHju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbXDKHju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXDKHjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:39:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXDKHjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:39:49 -0400
Date: Wed, 11 Apr 2007 09:38:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wedgwood <cw@f00f.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       "David S. Miller" <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070411073855.GA24943@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070408160954.edd248d1.akpm@linux-foundation.org> <46198FD7.5000900@garzik.org> <20070410075733.GA30886@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410075733.GA30886@tuatara.stupidest.org>
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


* Chris Wedgwood <cw@f00f.org> wrote:

> > >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/forcedeth-work-around-null-skb-dereference-crash.patch
> >
> > It sounded this was specific to Ingo.
> 
> I'm not sure, it sounds a bit like something I saw a while ago.  I 
> would have to check for sure, I made a quick debugging patch (sent to 
> netdev) and it went away so I think my last though was a 
> miscompilation.

the bug has turned into an 'interface hang under high load' (i.e. the 
hack patch above is not necessary, but the problem is still there). It 
still affects the latest forcedeth.c in -rc6. I.e. it's still an 
unresolved regression. The last state i'm aware of is that I have sent 
Ayaz ethtool output as well of the hang, as requested.

	Ingo
