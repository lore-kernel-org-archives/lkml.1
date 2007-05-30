Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbXE3WiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbXE3WiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXE3WiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:38:17 -0400
Received: from holomorphy.com ([66.93.40.71]:34952 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbXE3WiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:38:16 -0400
Date: Wed, 30 May 2007 15:38:57 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
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
Message-ID: <20070530223857.GF6909@holomorphy.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <20070530222715.GK11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530222715.GK11166@waste.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 01:00:30PM -0700, Linus Torvalds wrote:
>> Which *could* be something as simple as saying "bit 30 in the file 
>> descriptor specifies a separate fd space" along with some flags to make 
>> open and friends return those separate fd's. That makes them useless for 
>> "select()" (which assumes a flat address space, of course), but would be 
>> useful for just about anything else.

On Wed, May 30, 2007 at 05:27:15PM -0500, Matt Mackall wrote:
> Or.. we could have a method of swizzling in and out an entire FD
> array, similar to UML's trick for swizzling MMs.

I like that notion even better than randomization. I think it should
happen. I like SKAS, too, of course.


-- wli
