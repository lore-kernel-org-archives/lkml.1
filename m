Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbXE3TL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbXE3TL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXE3TLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:11:22 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7890 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbXE3TLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:11:21 -0400
Date: Wed, 30 May 2007 21:10:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530191024.GX15559@kernel.dk>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org> <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org> <20070530160913.GA14261@elte.hu> <465DCAE4.1010206@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465DCAE4.1010206@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30 2007, Mark Lord wrote:
> Ingo Molnar wrote:
> >
> > - sendfile(). This API mainly failed on #2. It partly failed on #1 too.
> >   (couldnt be used in certain types of scenarios so was unintuitive.)
> >   splice() fixes this almost completely.
> >
> > - KAIO. It fails on #2 and #3.
> 
> I wonder how useful it would be to reimplement sendfile()
> using splice(), either in glibc or inside the kernel itself?
> 
> sendfile() does get used a fair bit, but I really doubt that anyone
> outside of a handful of people on this list actually use splice().

It's indeed the plan, I even have git branch for it. Just never took the
time to actually finish it.

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=splice-sendfile

-- 
Jens Axboe

