Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXD2G7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXD2G7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 02:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXD2G7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 02:59:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43956 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXD2G7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 02:59:20 -0400
Date: Sun, 29 Apr 2007 08:59:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429065900.GB32281@elte.hu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429053022.GB23638@1wt.eu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> I don't know if Mike still has problems with SD, but there are now 
> several interesting reports of SD giving better feedback than CFS on 
> real work. In my experience, CFS seems smoother on *technical* tests, 
> which I agree that they do not really simulate real work.

well, there are several reports of CFS being significantly better than 
SD on a number of workloads - and i know of only two reports where SD 
was reported to be better than CFS: in Kasper's test (where i'd like to 
know what the "3D stuff" he uses is and take a good look at that 
workload), and another 3D report which was done against -v6. (And even 
in these two reports the 'smoothness advantage' was not dramatic. If you 
know of any other reports then please let me know!)

	Ingo
