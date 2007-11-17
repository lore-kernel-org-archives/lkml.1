Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXKQSKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXKQSKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXKQSKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:10:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbXKQSK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:10:29 -0500
Date: Sat, 17 Nov 2007 19:09:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Message-ID: <20071117180946.GA14055@elte.hu>
References: <473DA608.1020804@linux.vnet.ibm.com> <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
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


* Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> Sadly lockdep does not work for me, as it gets turned off early:
> [   39.851594] ---------------------------------
> [   39.855963] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> [   39.861981] swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> [   39.866963]  (&n->list_lock){-+..}, at: [<ffffffff802935c1>]

hey, that means it found a bug - which is not sad at all :-)

	Ingo
