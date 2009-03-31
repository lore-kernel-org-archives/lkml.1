Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZCaNXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZCaNXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbZCaNXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:23:10 -0400
Received: from rtr.ca ([76.10.145.34]:40880 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086AbZCaNXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:23:09 -0400
Message-ID: <49D21939.4050106@rtr.ca>
Date: Tue, 31 Mar 2009 09:23:05 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
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
       david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org>	 <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp>	 <49D0B687.1030407@oss.ntt.co.jp>	 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>	 <20090330175544.GX5178@kernel.dk>	 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>	 <20090330185414.GZ5178@kernel.dk>	 <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>	 <20090330201732.GB5178@kernel.dk>  <49D13123.7040007@rtr.ca> <1238505376.8363.26.camel@think.oraclecorp.com>
In-Reply-To: <1238505376.8363.26.camel@think.oraclecorp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
>
> You can test this pretty easily:
> 
> dd if=/dev/zero of=foo bs=4k count=10000 oflag=direct
> 
> If that runs faster than 1MB/s the write cache is still on.
..

Or simply:   hdparm -W /dev/sd?   ## (for SATA/PATA drives)
