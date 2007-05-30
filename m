Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbXE3JdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbXE3JdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXE3JdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:33:18 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43994 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXE3JdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:33:17 -0400
Date: Wed, 30 May 2007 13:30:02 +0400
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
Message-ID: <20070530093002.GA26598@2ka.mipt.ru>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <20070530083254.GA21528@2ka.mipt.ru> <20070530085400.GA17744@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070530085400.GA17744@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 30 May 2007 13:30:47 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:54:00AM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > I did not want to start with another round of ping-pong insults :), 
> > but, Ingo, you did not show that kevent works worse. I did show that 
> > sometimes it works better. It flawed from 0 to 30% win in that tests, 
> > in results Johann Bork presented kevent and epoll behaved the same. In 
> > results I posted earlier, I said, that sometimes epoll behaved better, 
> > sometimes kevent. [...]
> 
> let me refresh your recollection:
> 
>   http://lkml.org/lkml/2007/2/25/116
> 
> where you said:
> 
>  "But note, that on my athlon64 3500 test machine kevent is about 7900
>   requests per second compared to 4000+ epoll, so expect a challenge."

You can also find in that threads that I managed to run epoll server on 
that machine with 9k requests per second, although that was not
reproducible again.

> for a long time you made much fuss about how kevents is so much better 
> and how epoll cannot perform and scale as well (you said various 
> arguments why that is supposedly so), and some people bought into the 
> performance argument and advocated kevent due to its supposed 
> performance and scalability advantages - while now we are down to "epoll 
> and kevent are break-even"?

You just draw a picture you want to see.

Even on the kevent page I have links to other people's benchmarks, which
show how kevent behave compared to epoll in theirs load.
_My_ tests showed kevent performance win, you tuned my (can be
broken) epoll code and results changed - this is developemnt process,
where things are not obtained from the air.

> in my book that is way too much of a difference, it is (best-case) a way 
> too sloppy approach to something as fundamental as Linux's basic event 
> model and design, and it is also compounded by your continued "nothing 
> happened, really, lets move on" stance. Losing trust is easy, winning it 
> back is hard. Let me reuse a phrase of yours: "expect a challenge".

Well, I do not care much about what people think I did wrong or right.
There are obviously bad and good ideas and implementations.
I might be absolutely wrong with something, but that is a process of
solving problems, which I really enjoy.

I just want that there sould be no personal insults, if I made such things,
shame on me :)

> 	Ingo

-- 
	Evgeniy Polyakov
