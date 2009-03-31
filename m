Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbZCaNdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbZCaNdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZCaNdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:33:11 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:45884 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbZCaNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:33:10 -0400
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
From: Chris Mason <chris.mason@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
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
In-Reply-To: <49D21939.4050106@rtr.ca>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org>
	 <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp>
	 <49D0B687.1030407@oss.ntt.co.jp>
	 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
	 <20090330175544.GX5178@kernel.dk>
	 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
	 <20090330185414.GZ5178@kernel.dk>
	 <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>
	 <20090330201732.GB5178@kernel.dk> <49D13123.7040007@rtr.ca>
	 <1238505376.8363.26.camel@think.oraclecorp.com>  <49D21939.4050106@rtr.ca>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 09:28:18 -0400
Message-Id: <1238506098.8363.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49D21A7D.00CC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 09:23 -0400, Mark Lord wrote:
> Chris Mason wrote:
> >
> > You can test this pretty easily:
> > 
> > dd if=/dev/zero of=foo bs=4k count=10000 oflag=direct
> > 
> > If that runs faster than 1MB/s the write cache is still on.
> ..
> 
> Or simply:   hdparm -W /dev/sd?   ## (for SATA/PATA drives)

I'm afraid I tend to hammer on the drive instead of asking it politely,
but I guess hdparm is trust worthy these days ;)

-chris


