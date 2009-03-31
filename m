Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbZCaWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbZCaWHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZCaWHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:07:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403AbZCaWHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:07:20 -0400
Message-ID: <49D2930A.5030905@redhat.com>
Date: Tue, 31 Mar 2009 18:02:50 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49D281D8.8030203@garzik.org>
In-Reply-To: <49D281D8.8030203@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jens Axboe wrote:
>> Another problem is that FLUSH_CACHE sucks. Really. And not just on
>> ext3/ordered, generally. Write a 50 byte file, fsync, flush cache and
>> wit for the world to finish. Pretty hard to teach people to use a nicer
>> fdatasync(), when the majority of the cost now becomes flushing the
>> cache of that 1TB drive you happen to have 8 partitions on. Good luck
>> with that.
>
> (responding to an email way back near the start of the thread)
>
> I emailed Microsoft about their proposal to add a WRITE BARRIER 
> command to ATA, documented at
> http://www.t13.org/Documents/UploadedDocuments/docs2007/e07174r0-Write_Barrier_Command_Proposal.doc 
>
>
> The MSFT engineer said they were definitely still pursuing this proposal.
>
> IMO we could look at this too, or perhaps come up with an alternate 
> proposal like FLUSH CACHE RANGE(s).
>
>     Jeff
>

I agree that it is worth getting better mechanisms in place - the cache 
flush is really primitive. Now we just need a victim to sit in on 
T13/T10 standards meetings :-)

ric

