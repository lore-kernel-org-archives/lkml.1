Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbXKTX1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbXKTX1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXKTX1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:27:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbXKTX1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:27:03 -0500
Date: Wed, 21 Nov 2007 00:26:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, jeremy@goop.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       jkohen@users.sourceforge.net, akpm@linux-foundation.org,
       david@unsolicited.net
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071120232633.GA23667@elte.hu>
References: <20071120203919.GB10008@elte.hu> <20071120210315.GC13160@kroah.com> <20071120214927.GB24156@elte.hu> <20071120.151538.68704351.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120.151538.68704351.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> > so just to reiterate, to make sure we have the same plans: lets 
> > leave v2.6.22 and earlier kernels alone - and lets strive for the 
> > latest patches and code for v2.6.23 (and v2.6.24, evidently).
> 
> I've validated that those patches make 2.6.23 behave on my Niagara 
> box.

Great and thanks for testing it! Arjan noticed the shortness of the 1 
sec sleep too, my suggestion would be to increase the sleep period to 
~50 seconds and the detection threshold to 60 seconds - that should be 
large enough - instead of complicating the tick code even more.

	Ingo
