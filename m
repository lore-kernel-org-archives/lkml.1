Return-Path: <linux-kernel-owner+w=401wt.eu-S935117AbXGRQon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935117AbXGRQon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934058AbXGRQoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:44:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598AbXGRQoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:44:16 -0400
Date: Wed, 18 Jul 2007 18:43:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@ORACLE.COM>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070718164341.GA6327@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707181404.20458.olaf.kirch@oracle.com> <20070718124856.GB31215@elte.hu> <200707181641.45338.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707181641.45338.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@ORACLE.COM> wrote:

> > also, i'm using netconsole via the command line (both the network 
> > driver and netconsole is built into the bzImage), maybe that makes a 
> > difference?
> 
> Possibly - but so far there's nothing in the code that jumped at me.
> 
> Can you try the following please? I'm still pretty much in the dark; 
> so I'm adding a bunch of printks. Let's hope this doesn't change the 
> timing in a way that makes the bug disappear.

hm ... the box wouldnt even boot up because the 'keep on polling' and 
'done' messages are scrolling across so fast. Perhaps every printk 
triggers a packet which triggers another printk ... etc?

here's the 15MB log of it:

  http://redhat.com/~mingo/misc/100hz.3.log.bz2

	Ingo
