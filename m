Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbXI3QG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbXI3QG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXI3QGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 12:06:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbXI3QGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 12:06:21 -0400
Date: Sun, 30 Sep 2007 18:06:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] robust futex thread exit race
Message-ID: <20070930160601.GA31506@elte.hu>
References: <1191164539.4047.5.camel@localhost> <20070930151827.GB23127@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930151827.GB23127@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > Hi Ingo,
> > I finally found the bug that causes tst-robust8 from the glibc to fail
> > on s390x. Turned out to be a common code problem with the processing of
> > the robust futex list. The patch below fixes the bug for me.
> 
> good catch! A quick preliminary review of your patch indicates it's 
> fine - and it might be v2.6.23 material.

there's a symmetric bug in kernel/compat_futex.c too.

	Ingo
