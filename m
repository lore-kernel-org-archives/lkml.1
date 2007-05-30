Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbXE3Vbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbXE3Vbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXE3Vbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:31:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4383 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbXE3Vbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:31:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 30 May 2007 14:31:35 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
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
In-Reply-To: <465DDF0A.8080107@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0705301426160.6272@alien.or.mcafeemobile.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DDF0A.8080107@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Eric Dumazet wrote:

> > So library routines *must not* open file descriptors in the normal space.
> > 
> > (The same is true of real applications doing the equivalent of
> > 
> > 	for (i = 0; i < NR_OPEN; i++)
> > 		close(i);
> 
> Quite buggy IMHO

Looking at it now, I'd agree (although I think I have that somewhere in my 
old code too). Consider though, that such code is contained also in 
reference books like Richard Stevens "UNIX Network Programming".



- Davide


