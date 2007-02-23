Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbXBWMoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbXBWMoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXBWMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:44:10 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53066 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbXBWMoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:44:08 -0500
Date: Fri, 23 Feb 2007 15:41:23 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070223124123.GA24749@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070223122224.GB5392@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 23 Feb 2007 15:42:14 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 03:22:25PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> I meant that we end up with having one thread per IO - they were
> preallocated, but that does not matter. And what about your idea of
> switching userspace threads to cachemiss threads?
> 
> My main concern was only about the situation, when we ends up with truly
> bloking context (like network), and this results in having thousands of
> threads doing the work - even having most of them sleeping, there is a
> problem with memory overhead and context switching, although it is usable
> situation, but when all of them are ready immediately - context switching 
                                            simultaneously
> will kill a machine even with O(1) scheduler which made situation damn
> better than before, but it is not a cure for the problem.

Week of no-dictionary writings starts beating me.

-- 
	Evgeniy Polyakov
