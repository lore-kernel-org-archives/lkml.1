Return-Path: <linux-kernel-owner+w=401wt.eu-S1423090AbXBUX3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423090AbXBUX3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423269AbXBUX3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:29:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50550 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423090AbXBUX3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:29:21 -0500
Date: Thu, 22 Feb 2007 00:24:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070221232407.GA5895@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael K. Edwards <medwards.linux@gmail.com> wrote:

> 2) Facilities for manipulating pools of threadlets, so you can 
> throttle their concurrency, reprioritize them, and cancel them in 
> bulk, disposing safely of any dynamically allocated memory, 
> synchronization primitives, and so forth that they may be holding;

pthread_cancel() [if/once threadlets are integrated into pthreads] ought 
to do that. A threadlet, if it gets moved to an async context, is a 
full-blown thread.

	Ingo
