Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXE3TFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXE3TFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXE3TFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:05:14 -0400
Received: from rtr.ca ([64.26.128.89]:3206 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbXE3TFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:05:12 -0400
Message-ID: <465DCAE4.1010206@rtr.ca>
Date: Wed, 30 May 2007 15:05:08 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
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
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org> <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org> <20070530160913.GA14261@elte.hu>
In-Reply-To: <20070530160913.GA14261@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
>  - sendfile(). This API mainly failed on #2. It partly failed on #1 too.
>    (couldnt be used in certain types of scenarios so was unintuitive.)
>    splice() fixes this almost completely.
> 
>  - KAIO. It fails on #2 and #3.

I wonder how useful it would be to reimplement sendfile()
using splice(), either in glibc or inside the kernel itself?

sendfile() does get used a fair bit, but I really doubt that anyone
outside of a handful of people on this list actually use splice().

Cheers
