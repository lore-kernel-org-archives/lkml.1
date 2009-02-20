Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZBTQRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZBTQRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZBTQRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:17:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43014 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZBTQRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:17:45 -0500
Date: Fri, 20 Feb 2009 17:17:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       "jens.axboe" <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Announce] 2.6.29-rc4-rt2
Message-ID: <20090220161709.GE11294@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <1235111568.3363.3.camel@localhost.localdomain> <1235116151.4736.12.camel@laptop> <1235142548.3588.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235142548.3588.5.camel@localhost.localdomain>
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


* Thomas Meyer <thomas@m3y3r.de> wrote:

> With above patch I get a lot of warnings in 
> 
> lib/scatterlist.c:395 sg_miter_stop+0x5a/0xa4().
> 
> Like:
> [   34.946650] ------------[ cut here ]------------
> [   34.946653] WARNING: at lib/scatterlist.c:395 sg_miter_stop+0x5a/0xa4()

could you edit lib/scatterlist.c line 395 and remove this line:

                        WARN_ON(!irqs_disabled());

?

	Ingo
