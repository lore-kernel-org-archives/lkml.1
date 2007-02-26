Return-Path: <linux-kernel-owner+w=401wt.eu-S965261AbXBZM6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbXBZM6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965262AbXBZM6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:58:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965261AbXBZM6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:58:06 -0500
Date: Mon, 26 Feb 2007 13:51:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226125123.GA31357@elte.hu>
References: <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru> <20070226095547.GA9485@elte.hu> <20070226103319.GA24284@2ka.mipt.ru> <20070226103517.GA17195@elte.hu> <20070226104748.GC24284@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226104748.GC24284@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Even having main dispatcher as epoll/kevent loop, the _whole_ 
> threadlet model is absolutely micro-thread in nature and not state 
> machine/event.

Evgeniy, i'm not sure how many different ways to tell this to you, but 
you are not listening, you are not learning and you are still not 
getting it at all.

The scheduler /IS/ a generic work/event queue. And it's pretty damn 
fast. No amount of badmouthing will change that basic fact. Not exactly 
as fast as a special-purpose queueing system (for all the reasons i 
outlined to you, and which you ignored), but it gets pretty damn close 
even for the web workload /you/ identified, and offers a user-space 
programming model that is about 1000 times more useful than 
state-machines.

	Ingo
