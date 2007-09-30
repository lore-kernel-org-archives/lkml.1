Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbXI3RLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbXI3RLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbXI3RLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:11:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34767 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbXI3RLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:11:47 -0400
Date: Sun, 30 Sep 2007 19:11:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] robust futex thread exit race
Message-ID: <20070930171121.GA10025@elte.hu>
References: <1191164539.4047.5.camel@localhost> <20070930151827.GB23127@elte.hu> <20070930160601.GA31506@elte.hu> <1191168625.19010.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191168625.19010.0.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> 
> On Sun, 2007-09-30 at 18:06 +0200, Ingo Molnar wrote:
> > > good catch! A quick preliminary review of your patch indicates it's 
> > > fine - and it might be v2.6.23 material.
> > 
> > there's a symmetric bug in kernel/compat_futex.c too.
> 
> True. I'll update the patch and send it again with the Acked-bys.

thanks! Logistics-wise: given that v2.6.22 has this same bug too, it's 
not a .23 regression per se and could in theory be merged after the 
2.6.23 release too, into 2.6.23.1.

	Ingo
