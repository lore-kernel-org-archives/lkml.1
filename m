Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZCZChl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZCZChl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZCZChc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:37:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58542 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZCZChb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:37:31 -0400
Message-ID: <49CAEA2F.5000801@garzik.org>
Date: Wed, 25 Mar 2009 22:36:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org> <20090325215016.GP32307@mit.edu> <20090326021034.GA26559@srcf.ucam.org>
In-Reply-To: <20090326021034.GA26559@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> I disagree with this approach. If fsync() means anything other than "Get 
> my data on disk and then return" then we're breaking guarantees to 
> applications.

Due to lack of storage dev writeback cache flushing, we are indeed 
breaking that guarantee in many situations...


> The problem is that you're insisting that the only way 
> applications can ensure that their requests occur in order is to use 
> fsync(), which will achieve that but also provides guarantees above and 
> beyond what the majority of applications want.

That remains a true statement...   without the *sync* syscalls, you 
still do not have a _guarantee_ writes occur in a certain order.

	Jeff


