Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXCCWLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXCCWLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030487AbXCCWLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:11:04 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33048 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbXCCWLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:11:02 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 3 Mar 2007 14:10:59 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
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
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703031403520.7278@alien.or.mcafeemobile.com>
References: <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru>
 <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu>
 <20070301145454.GB12684@2ka.mipt.ru> <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
 <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
 <20070303100625.GA22557@2ka.mipt.ru> <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
 <20070303203140.GA756@2ka.mipt.ru> <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007, Davide Libenzi wrote:

> Those *other* (tons?!?) interfaces can be created *when* the need comes 
> (see Linus signalfd [1] example to show how urgent that was). *When* 
> the need comes, they will work with existing POSIX interfaces, without 
> requiring your own just-another event interface. Those other interfaces 
> could also be more easily adopted by other Unix cousins, because of 
> the fact that they rely on existing POSIX interfaces. One of the reason 
> about the Unix file abstraction interfaces, is that you do *not* have to 
> plan and bloat interfaces before. As long as your new abstraction behave 
> in a file-fashion, it can be automatically used with existing interfaces. 
> And you create them *when* the need comes.

Now, if you don't mind, my spare time is really limited and I prefer to 
spend it looking at stuff the topic of this thread talks about.
Even because the whole epoll/kevent discussion is heavily dependent on the 
fact that syslets/threadlets will or will not result a viable method for 
generic AIO. Savvy?



- Davide


