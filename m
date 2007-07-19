Return-Path: <linux-kernel-owner+w=401wt.eu-S938906AbXGSQHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938906AbXGSQHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbXGSQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:07:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761294AbXGSQHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:07:24 -0400
Date: Thu, 19 Jul 2007 18:07:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Olaf Kirch <olaf.kirch@oracle.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719160713.GA3807@elte.hu>
References: <20070716091236.GA10718@elte.hu> <20070719104756.GA13769@elte.hu> <20070719105816.GA15852@elte.hu> <200707191452.09609.olaf.kirch@oracle.com> <469F867C.7020707@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F867C.7020707@intel.com>
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


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> > I don't have a fix ready yet - I hope I'll have something later this 
> > afternoon.
> 
> interesting, you seem to found the cause allright. I can't confirm the 
> problem but I know that netpoll and NAPI has historically been an 
> issue. I look forward to your suggestions...

because i dont seem to be able to trigger Olaf's WARN_ON(), can you see 
anything in the ethtool output that i sent in the previous mail(s)?

	Ingo
