Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXBYSc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXBYSc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXBYSc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:32:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44791 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993AbXBYSc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:32:26 -0500
Date: Sun, 25 Feb 2007 19:24:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225182452.GB3622@elte.hu>
References: <20070221211355.GA7302@elte.hu> <20070224183421.GA6835@2ka.mipt.ru> <20070225172337.GB4998@elte.hu> <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu> <20070225182135.GB29821@2ka.mipt.ru> <20070225182555.GC29821@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225182555.GC29821@2ka.mipt.ru>
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

> > > Do you have any link where i could check the type of HTTP parsing 
> > > and send transport you are (or will be) using? What type of http 
> > > client are you using to measure, with precisely what options?
> > 
> > For example this ones (essentially the same, except that epoll and
> > kevent are used):
> > http://tservice.net.ru/~s0mbre/archive/kevent/evserver_kevent.c
> > http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c
> 
> Client is 'ab' with high number of connections and concurrency. For 
> example for athlon64 3500 I used concurrency of 8000 connections and 
> 80k total.

ok. So it's:

   ab -c 8000 -n 80000 http://yourserver/tmp/index.html

right? How large is index.html typically - the default 40960 bytes, and 
with a constructed HTTP reply header already included in the file?

	Ingo
