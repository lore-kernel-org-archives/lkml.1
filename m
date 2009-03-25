Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZCYU2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZCYU2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZCYU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:28:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46191 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbZCYU2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:28:04 -0400
Message-ID: <49CA9324.6010407@redhat.com>
Date: Wed, 25 Mar 2009 16:25:08 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA8ADA.3040709@redhat.com> <49CA9114.3040205@garzik.org>
In-Reply-To: <49CA9114.3040205@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Ric Wheeler wrote:> And, as I am sure that you do know, to add insult 
> to injury, FLUSH_CACHE
>> is per device (not file system).
>>
>> When you issue an fsync() on a disk with multiple partitions, you 
>> will flush the data for all of its partitions from the write cache....
>
> SCSI'S SYNCHRONIZE CACHE command already accepts an (LBA, length) 
> pair.  We could make use of that.
>
> And I bet we could convince T13 to add FLUSH CACHE RANGE, if we could 
> demonstrate clear benefit.
>
>     Jeff

How well supported is this in SCSI?  Can we try it out with a commodity 
SAS drive?

Ric

