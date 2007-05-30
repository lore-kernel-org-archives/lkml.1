Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbXE3J20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbXE3J20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbXE3J2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:28:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60413 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXE3J2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:28:17 -0400
Message-ID: <465D43A0.8040307@garzik.org>
Date: Wed, 30 May 2007 05:28:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
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
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu>
In-Reply-To: <20070530072055.GA3077@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> You should pick up the kevent work :)
> 
> 3 months ago i verified the published kevent vs. epoll benchmark and 
> found that benchmark to be fatally flawed. When i redid it properly 
> kevent showed no significant advantage over epoll. Note that i did those 
> measurements _before_ the recent round of epoll speedups. So unless 
> someone does believable benchmarks i consider kevent an over-hyped, 
> mis-benchmarked complication to do something that epoll is perfectly 
> capable of doing.

You snipped the key part of my response, so I'll say it again:

Event rings (a) most closely match what is going on in the hardware and 
(b) often closely match what is going on in multi-socket, event-driven 
software application.

To echo Uli and paraphrase an ad, "it's the interface, silly."

This is not something epoll is capable of doing, at the present time.

	Jeff


