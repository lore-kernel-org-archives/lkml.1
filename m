Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXE3Tde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXE3Tde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbXE3TdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:33:23 -0400
Received: from brick.kernel.dk ([80.160.20.94]:3420 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575AbXE3TdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:33:22 -0400
Date: Wed, 30 May 2007 21:32:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070530193226.GB32105@kernel.dk>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org> <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org> <20070530160913.GA14261@elte.hu> <465DCAE4.1010206@rtr.ca> <alpine.LFD.0.98.0705301212520.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705301212520.26602@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 30 May 2007, Mark Lord wrote:
> >
> > I wonder how useful it would be to reimplement sendfile()
> > using splice(), either in glibc or inside the kernel itself?
> 
> I'd like that, if only because right now we have two separate paths that 
> kind of do the same thing, and splice really is the only one that is 
> generic.
> 
> I thought Jens even had some experimental patches for it. It might be 
> worth to "just do it" - there's some internal overhead, but on the other 
> hand, it's also likely the best way to make sure any issues get sorted 
> out.

I do, this is a one year old patch that does that:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=f8f550e027fd07ad8d87110178803dc63b544d89

I'll update it, test, and submit for 2.6.23.

-- 
Jens Axboe

