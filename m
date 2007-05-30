Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXE3IzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXE3IzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXE3Iyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:54:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57327 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXE3Iyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:54:47 -0400
Date: Wed, 30 May 2007 10:54:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530085400.GA17744@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <20070530083254.GA21528@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530083254.GA21528@2ka.mipt.ru>
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


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> I did not want to start with another round of ping-pong insults :), 
> but, Ingo, you did not show that kevent works worse. I did show that 
> sometimes it works better. It flawed from 0 to 30% win in that tests, 
> in results Johann Bork presented kevent and epoll behaved the same. In 
> results I posted earlier, I said, that sometimes epoll behaved better, 
> sometimes kevent. [...]

let me refresh your recollection:

  http://lkml.org/lkml/2007/2/25/116

where you said:

 "But note, that on my athlon64 3500 test machine kevent is about 7900
  requests per second compared to 4000+ epoll, so expect a challenge."

for a long time you made much fuss about how kevents is so much better 
and how epoll cannot perform and scale as well (you said various 
arguments why that is supposedly so), and some people bought into the 
performance argument and advocated kevent due to its supposed 
performance and scalability advantages - while now we are down to "epoll 
and kevent are break-even"?

in my book that is way too much of a difference, it is (best-case) a way 
too sloppy approach to something as fundamental as Linux's basic event 
model and design, and it is also compounded by your continued "nothing 
happened, really, lets move on" stance. Losing trust is easy, winning it 
back is hard. Let me reuse a phrase of yours: "expect a challenge".

	Ingo
