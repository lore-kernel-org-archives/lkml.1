Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZCZDDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZCZDDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZCZDDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:03:09 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:12943 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZCZDDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <49CAEDA7.1080902@garzik.org>
References: <20090324093245.GA22483@elte.hu> <20090325150041.GM32307@mit.edu>
	 <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	 <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org>
	 <20090325215016.GP32307@mit.edu>
	 <20090326021034.GA26559@srcf.ucam.org>
	 <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
	 <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>
	 <49CAEDA7.1080902@garzik.org>
Date: Wed, 25 Mar 2009 23:03:03 -0400
Message-ID: <f73f7ab80903252003j248b416ewe52b613c5b53066c@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Kyle Moffett <kyle@moffetthome.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 10:51 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Then you have just reinvented the transactional userspace API that people
> often want to replace POSIX API with.  Maybe one day they will succeed.
>
> But "POSIX API replacement" is an area never short of proposals... :)

Well, I think the goal is not to *replace* the POSIX API or even
provide "transactional" guarantees.  The performance penalty for
atomic transactions is pretty high, and most programs (like GIT) don't
really give a damn, as they provide that on a higher level.

It's like the difference between a modern SMP system that supports
memory barriers and write snooping and one of the theoretical
"transactional memory" designs that have never caught on.

To be honest I think we could provide much better data consistency
guarantees and remove a lot of fsync() calls with just a basic
per-filesystem barrier() call.

Cheers,
Kyle Moffett
