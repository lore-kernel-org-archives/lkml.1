Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbXE2XLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbXE2XLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXE2XLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:11:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51111 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbXE2XLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:11:33 -0400
Date: Tue, 29 May 2007 16:09:31 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070529230931.GL7875@mami.zabbo.net>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465CA654.5000505@garzik.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You should pick up the kevent work :)

I haven't looked at it in a while but yes, it's "on the radar" :).

> Having async request and response rings would be quite useful, and most 
> closely match what is going on under the hood in the kernel and hardware.

Yeah, but I have lots of competing thoughts about this.

For the time being I'm focusing on simplifying the mechanisms that
support the sys_io_*() interface so I never ever have to debug fs/aio.c
(also known as chewing glass to those of us with the scars) again.

That said, I'll gladly work closely with developers who are seriously
considering putting some next gen interface to the test.  That todo item
about producing documentation and distro kernels is specifically to bait
Uli into trying to implement posix aio on top of syslets in glibc.

'cause we can go back and forth about potential interfaces for, well,
how long as it been?  years?  I want non-trivial users who we can
measure so we can *stop* designing and implementing the moment something
is good enough for them.

- z
