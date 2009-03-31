Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZCaWX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZCaWX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbZCaWXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:23:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55603 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562AbZCaWXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:23:12 -0400
Message-ID: <49D29797.80200@garzik.org>
Date: Tue, 31 Mar 2009 18:22:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <liml@rtr.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49D281D8.8030203@garzik.org> <49D2930A.5030905@redhat.com>
In-Reply-To: <49D2930A.5030905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> Jeff Garzik wrote:
>> Jens Axboe wrote:
>>> Another problem is that FLUSH_CACHE sucks. Really. And not just on
>>> ext3/ordered, generally. Write a 50 byte file, fsync, flush cache and
>>> wit for the world to finish. Pretty hard to teach people to use a nicer
>>> fdatasync(), when the majority of the cost now becomes flushing the
>>> cache of that 1TB drive you happen to have 8 partitions on. Good luck
>>> with that.
>>
>> (responding to an email way back near the start of the thread)
>>
>> I emailed Microsoft about their proposal to add a WRITE BARRIER 
>> command to ATA, documented at
>> http://www.t13.org/Documents/UploadedDocuments/docs2007/e07174r0-Write_Barrier_Command_Proposal.doc 

>> The MSFT engineer said they were definitely still pursuing this proposal.
>>
>> IMO we could look at this too, or perhaps come up with an alternate 
>> proposal like FLUSH CACHE RANGE(s).

> I agree that it is worth getting better mechanisms in place - the cache 
> flush is really primitive. Now we just need a victim to sit in on 
> T13/T10 standards meetings :-)


Heck, we could even do a prototype implementation with the help of Mark 
Lord's sata_mv target mode support...

	Jeff



