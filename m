Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYL2QUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYL2QUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYL2QUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:20:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45321 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYL2QUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:20:34 -0500
Date: Mon, 29 Dec 2008 17:20:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081229162017.GB31964@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu> <20081229110012.GB11111@linux.vnet.ibm.com> <20081229110533.GA29592@elte.hu> <20081229160538.GA5952@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229160538.GA5952@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2008-12-29 12:05:33]:
> 
> > 
> > * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > 
> > > Hi Ingo,
> > > 
> > > 	kernel crashes after applying the patch, I will retest with 
> > > the patch posted at http://lkml.org/lkml/2008/12/29/48
> > 
> > yes - Yinghai observed this too. Could you check tip/master that has all 
> > the fixlets merged up, to make sure it's finally solved? Thanks,
> > 
> > also, what is the gcc -v output of your compiler?
> > 
> > 	Ingo
> 
> Hi Ingo/Yinghai,
> 
> 	Thanks for getting it resolved, the latest tip/master boot's up fine :)

thanks for testing it :-)

Linus - this means irq-core-for-linus + irq-fixes-for-linus-4 (or just 
plain irq-fixes-for-linus-4) should be golden.

	Ingo
