Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbZCYSac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbZCYSac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbZCYSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:30:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbZCYSaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:30:19 -0400
Date: Wed, 25 Mar 2009 11:21:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Rees <drees76@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <72dbd3150903251109x75aa5d8ke8277247c2f292f9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903251117380.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>  <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>  <20090324091545.758d00f5@lxorguk.ukuu.org.uk>  <20090324093245.GA22483@elte.hu>  <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
  <20090324103111.GA26691@elte.hu>  <20090324041249.1133efb6.akpm@linux-foundation.org>  <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>  <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
 <72dbd3150903251109x75aa5d8ke8277247c2f292f9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, David Rees wrote:
>
> Your Intel SSD will write streaming data 2-4 times faster than your 
> typical disk

Don't even bother with streaming data. The problem is _never_ streaming 
data.

Even a suck-ass laptop drive can write streaming data fast enough that 
people don't care. The problem is invariably that writes from different 
sources (much of it being metadata) interact and cause seeking.

> and can be an order of magnitude faster when it comes to small, random 
> writes.

Umm. More like two orders of magnitude or more.

Random writes on a disk (even a fast one) tends to be in the hundreds of 
kilobytes per second. Have you worked with an Intel SSD? It does tens of 
MB/s on pure random writes.

The problem really is gone with an SSD.

And please realize that the problem for me was never 30-second stalls. For 
me, a 3-second stall is unacceptable. It's just very annoying.

		Linus
