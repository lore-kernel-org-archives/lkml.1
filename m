Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXE3HV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXE3HV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXE3HVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:21:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXE3HVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:21:50 -0400
Date: Wed, 30 May 2007 09:20:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530072055.GA3077@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465CA654.5000505@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

> You should pick up the kevent work :)

3 months ago i verified the published kevent vs. epoll benchmark and 
found that benchmark to be fatally flawed. When i redid it properly 
kevent showed no significant advantage over epoll. Note that i did those 
measurements _before_ the recent round of epoll speedups. So unless 
someone does believable benchmarks i consider kevent an over-hyped, 
mis-benchmarked complication to do something that epoll is perfectly 
capable of doing.

	Ingo
