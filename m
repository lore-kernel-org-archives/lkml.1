Return-Path: <linux-kernel-owner+w=401wt.eu-S1759853AbXE3VkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853AbXE3VkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbXE3Vj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:39:59 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4921 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbXE3Vj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:39:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 30 May 2007 14:39:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <465DE992.6070803@redhat.com>
Message-ID: <Pine.LNX.4.64.0705301434220.6272@alien.or.mcafeemobile.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DE992.6070803@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Linus Torvalds wrote:
> > 	for (i = 0; i < NR_OPEN; i++)
> > 		close(i);
> > 
> > to clean up all file descriptors before doing something new. And yes, I 
> > think it was bash that used to *literally* do something like that a long 
> > time ago.
> 
> Indeed.  It was not only bash, though, I fixed probably a dozen
> applications.  But even the new and better solution (readdir of
> /proc/self/fd) does not prevent the problem of closing descriptors the
> system might still need and the application doesn't know about.

Please, do not drop me out of the Cc list. If you have a valid point, you 
should be able to carry it forward regardless, no?



- Davide


