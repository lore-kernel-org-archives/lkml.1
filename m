Return-Path: <linux-kernel-owner+w=401wt.eu-S940868AbXGSRmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940868AbXGSRmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:42:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbXGSRlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:41:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbXGSRls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:41:48 -0400
Date: Thu, 19 Jul 2007 19:41:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719174133.GA30061@elte.hu>
References: <20070716091236.GA10718@elte.hu> <20070719155230.GA31267@elte.hu> <20070719160556.GA3330@elte.hu> <200707191936.12646.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707191936.12646.olaf.kirch@oracle.com>
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

> On Thursday 19 July 2007 18:05, Ingo Molnar wrote:
> > that network-intense test also produced periodic broadcast packets that 
> > got the e1000 out of its weird state before the tx timeout could hit. 
> > Now that i've stopped the test, the network is quiescent again and the 
> > e1000 hangs.
> 
> Can you confirm this by spraying the laptop with arp packets or 
> broadcast pings while it's booting?

yes, i did exactly that, and it made the box boot.

	Ingo
