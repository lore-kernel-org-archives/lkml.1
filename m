Return-Path: <linux-kernel-owner+w=401wt.eu-S964983AbXCALeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbXCALeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964988AbXCALeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:34:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbXCALeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:34:14 -0500
Date: Thu, 1 Mar 2007 12:27:00 +0100
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
Message-ID: <20070301112700.GA897@elte.hu>
References: <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301111629.GA27381@2ka.mipt.ru>
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

> I've uploaded them to:
> 
> http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c
> http://tservice.net.ru/~s0mbre/archive/kevent/evserver_kevent.c

thanks.

> I also changed client socket to nonblocking mode with the same result 
> in epoll server. [...]

what does this mean exactly? Did you change this line in 
evserver_epoll.c:

        //fcntl(cs, F_SETFL, O_NONBLOCK);

to:

        fcntl(cs, F_SETFL, O_NONBLOCK);

and the result was the same?

	Ingo
