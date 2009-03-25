Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZCYV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZCYV2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZCYV2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:28:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37342 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZCYV2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t4oVpDLelObDtW7XZnZkLwugk9M2fGSLtVZMG2I5IWk0qsp1MSeB4Ys3M5CUTve+sn
         ey4rRj7CLuf16M5mA6H6YgykV/m9KmOZWTPIEZv8lf7/L6IRpcG86IH78q7eXxoB+hYH
         ol3+kgrv6qHY+2aY3i3lZS+rGa8kyCi7p0yIU=
Message-ID: <49CAA1D6.4080407@panasas.com>
Date: Wed, 25 Mar 2009 23:27:50 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 25, 2009, 22:16 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Ric Wheeler wrote:> And, as I am sure that you do know, to add insult to 
> injury, FLUSH_CACHE
>> is per device (not file system).
>>
>> When you issue an fsync() on a disk with multiple partitions, you will 
>> flush the data for all of its partitions from the write cache....
> 
> SCSI'S SYNCHRONIZE CACHE command already accepts an (LBA, length) pair. 
>   We could make use of that.
> 
> And I bet we could convince T13 to add FLUSH CACHE RANGE, if we could 
> demonstrate clear benefit.

One more example of flexible, fine grain flush (though quite far out) are
T10 OSDs with which you can flush a byte range of a single object
(or collection, partition, or the whole device LUN)

Benny

> 
> 	Jeff
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

