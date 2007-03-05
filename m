Return-Path: <linux-kernel-owner+w=401wt.eu-S1750937AbXCEIQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937AbXCEIQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXCEIQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:16:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44694 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXCEIQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:16:24 -0500
Date: Mon, 5 Mar 2007 09:08:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Message-ID: <20070305080824.GA20583@elte.hu>
References: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com> <1173018209.24738.135.camel@localhost.localdomain> <6bffcb0e0703040636q5a4ed3ekf5a0461052e8e018@mail.gmail.com> <1173022668.24738.141.camel@localhost.localdomain> <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com> <1173026442.24738.143.camel@localhost.localdomain> <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com> <1173027823.24738.156.camel@localhost.localdomain> <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log2.txt

weird. Could you do a dump with SysRq-T, SysRq-Q done /twice/ after each 
other, to see how the system progresses while in this lockup? Plus 
please also try to get a register dump via SysRq-P. 

Btw., the task state printout seems busted:

udev_run_devd ? C15B0030  2544   979    853                     (L-TLB)

shouldnt that be 'R' instead of the question mark?

	Ingo
