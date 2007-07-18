Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbXGRMmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbXGRMmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758377AbXGRMlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:41:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbXGRMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:41:54 -0400
Date: Wed, 18 Jul 2007 14:41:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070718124141.GA31215@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707172034.20581.olaf.kirch@oracle.com> <20070717185602.GA25271@elte.hu> <200707181404.20458.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707181404.20458.olaf.kirch@oracle.com>
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


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> On Tuesday 17 July 2007 20:56, Ingo Molnar wrote:
> > i logged these not via netconsole but via logging on over the console 
> > and using dmesg, so it should include everything. in the 100hz case the 
> > following seems to show the anomaly:
> > 
> >   NETDEV WATCHDOG: eth0: transmit timed out
> 
> So, it seems as if for some reason, dev->poll isn't called frequently 
> enough.
> 
> Here's a debugging patch that tries to locate the problem - can you 
> give it a try, please?

sure, give me a minute.

	Ingo
