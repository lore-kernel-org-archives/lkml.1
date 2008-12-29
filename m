Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYL2LKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYL2LKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYL2LKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:10:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44270 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYL2LKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:10:11 -0500
Date: Mon, 29 Dec 2008 12:09:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081229110954.GB5065@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu> <86802c440812281601j57fe5ecdif4b63b72280c65cd@mail.gmail.com> <2f11576a0812290039t11ca9b76sf305e82003ac607@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0812290039t11ca9b76sf305e82003ac607@mail.gmail.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> >>  kernel/irq/handle.c |    5 -----
> >>  kernel/irq/manage.c |    9 +++++++++
> >>  2 files changed, 9 insertions(+), 5 deletions(-)
> >>
> >
> > that is not enough.
> >
> > please check
> >
> > need one printk, and move two functions into chip.c
> 
> I'm sad ;-)
> 
> Why you use printk? if develper use non-x86 machine, they will see 
> perfectly worthless debug messages...

yes. If you can reproduce the problem then please check the version in 
tip/master:

  http://people.redhat.com/mingo/tip.git/README

it doesnt include any needless printks.

	Ingo
