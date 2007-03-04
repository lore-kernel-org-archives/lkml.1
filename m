Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbXCDRsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbXCDRsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXCDRsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:48:30 -0500
Received: from smtpout.mac.com ([17.250.248.176]:60829 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbXCDRs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:48:29 -0500
In-Reply-To: <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
References: <20070301131118.GA30228@elte.hu> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com> <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com> <20070303100625.GA22557@2ka.mipt.ru> <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com> <20070303203140.GA756@2ka.mipt.ru> <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com> <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <82AD23D8-E5BE-4B69-A602-1B474EC0C4EA@mac.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Sun, 4 Mar 2007 12:46:00 -0500
To: Kirk Kuchov <kirk.kuchov@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 04, 2007, at 11:23:37, Kirk Kuchov wrote:
> So here we are, 2007. epoll() works with files, pipes, sockets,  
> inotify and anything pollable (file descriptors) but aio, timers,  
> signals and user-defined event. Can we please get those working  
> with epoll ? Something as simple as:
>
> [code snipped]
>
> Would this be acceptable? Can we finally move on?

Well, even this far into 2.6, Linus' patch from 2003 still (mostly)  
applies; the maintenance cost for this kind of code is virtually  
zilch.  If it matters that much to you clean it up and make it apply;  
add an alarmfd() syscall (another 100 lines of code at most?) and  
make a "read" return an architecture-independent siginfo-like  
structure and submit it for inclusion.  Adding epoll() support for  
random objects is as simple as a 75-line object-filesystem and a 25- 
line syscall to return an FD to a new inode.  Have fun!  Go wild!   
Something this trivially simple could probably spend a week in -mm  
and go to linus for 2.6.22.

Cheers,
Kyle Moffett

