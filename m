Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbXCBLEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbXCBLEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXCBLEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:04:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52656 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329AbXCBLEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:04:14 -0500
Date: Fri, 2 Mar 2007 11:56:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070302105618.GA18377@elte.hu>
References: <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301101102.GE20171@elf.ucw.cz> <20070301111815.GB15709@2ka.mipt.ru> <20070302102714.GB27687@elf.ucw.cz> <20070302103713.GB28444@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302103713.GB28444@2ka.mipt.ru>
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

> Even if kevent has the same speed, it still allows to handle _any_ 
> kind of events without any major surgery - a very tiny structure of 
> lock and list head and you can process your own kernel event in 
> userspace with timers, signals, io events, private userspace events 
> and others without races and invention of differnet hacks for 
> different types - _this_ is main point.

did it ever occur to you to ... extend epoll? To speed it up? To add a 
new wait syscall to it? Instead of introducing a whole new parallel 
framework?

	Ingo
