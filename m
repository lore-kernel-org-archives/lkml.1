Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbXE3IgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbXE3IgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXE3Ifu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:35:50 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41855 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbXE3Ifs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:35:48 -0400
Date: Wed, 30 May 2007 12:32:54 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20070530083254.GA21528@2ka.mipt.ru>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070530072055.GA3077@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 30 May 2007 12:33:21 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, developers.

On Wed, May 30, 2007 at 09:20:55AM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
> > You should pick up the kevent work :)
> 
> 3 months ago i verified the published kevent vs. epoll benchmark and 
> found that benchmark to be fatally flawed. When i redid it properly 
> kevent showed no significant advantage over epoll. Note that i did those 
> measurements _before_ the recent round of epoll speedups. So unless 
> someone does believable benchmarks i consider kevent an over-hyped, 
> mis-benchmarked complication to do something that epoll is perfectly 
> capable of doing.

I did not want to start with another round of ping-pong insults :), but, 
Ingo, you did not show that kevent works worse. I did show that
sometimes it works better. It flawed from 0 to 30% win in that tests, 
in results Johann Bork presented kevent and epoll behaved the same. In
results I posted earlier, I said, that sometimes epoll behaved better, 
sometimes kevent. What does it say? Just the fact, that in that given 
workload result was the one we saw. Nothing more, nothing less.
It does not show something is broken, and definitely not that it is:
citation1:
we're heading to yet-another monolitic interface, we're heading with no
valid reasons given if other than some handwaving.
citation2:
consider kevent an over-hyped, mis-benchmarked complication to do 
something that epoll is perfectly

Getting into account another features kevent has (and what it was
designed for originally - for network AIO, which is quite hard 
(if ever possible) with files and epoll, I'm not talking about syslets
as AIO, it is different approach and likely it is simpler, getting even
only that it is already very good), it is not what people said in above 
citations.

It looks like you have some personal insults on that, which I do not
understand. But it has nothing with technical side of the problem, so
lets stop such rethoric and concentrate on real problem and forget any
possible personal issues which might be raised sometimes :).

Although I closed kevent and eventfs projects, I would gladly continue
if we can and want to have progress in that area.

Thanks.

> 	Ingo

-- 
	Evgeniy Polyakov
