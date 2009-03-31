Return-Path: <linux-kernel-owner+w=401wt.eu-S1762508AbZCaQh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762508AbZCaQh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762869AbZCaQho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:37:44 -0400
Received: from rtr.ca ([76.10.145.34]:35248 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762862AbZCaQhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:37:43 -0400
Message-ID: <49D246D2.7020008@rtr.ca>
Date: Tue, 31 Mar 2009 12:37:38 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <49D13123.7040007@rtr.ca> <49D23B9C.2000000@sandeen.net>
In-Reply-To: <49D23B9C.2000000@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Mark Lord wrote:
..
>> XFS appears to have something along those lines.
>> I believe it tries to disable the drive write caches
>> if it discovers that it cannot do cache flushes.
> 
> No, it just stops issuing barriers if the initial mount-time test finds
> that they're not supported.  ext3/4/reiserfs do similar.
..

Okay.  My apologies to the XFS folks!

I'll have to dig deeper to find out who/what is disabling
the drive write caches, then.

Thanks
