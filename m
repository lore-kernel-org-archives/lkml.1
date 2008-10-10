Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYJJL5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYJJL5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYJJL5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:57:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35239 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbYJJL5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:57:33 -0400
Date: Fri, 10 Oct 2008 13:57:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <s0mbre@tservice.net.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081010115725.GD19487@elte.hu>
References: <20081009231759.GA8664@tservice.net.ru> <20081010080910.GA31723@tservice.net.ru> <20081010091511.GC5116@elte.hu> <20081010113100.GA1030@tservice.net.ru> <20081010114245.GB19487@elte.hu> <20081010115518.GA3159@tservice.net.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010115518.GA3159@tservice.net.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <s0mbre@tservice.net.ru> wrote:

> On Fri, Oct 10, 2008 at 01:42:45PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> > > vanilla 27: 347.222
> > > no TSO/GSO: 357.331
> > > no hrticks: 382.983
> > > no balance: 389.802
> > 
> > okay. The target is 470 MB/sec, right? (Assuming the workload is sane 
> > and 'fixing' it does not mean we have to schedule worse.)
> 
> Well, that's where I started/stopped, so maybe we will even move
> further? :)

that's the right attitude ;)

	Ingo
