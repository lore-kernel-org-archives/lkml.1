Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZCZGZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZCZGZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 02:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZCZGZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 02:25:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33389 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZCZGZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 02:25:11 -0400
Message-ID: <49CB1F90.3090501@garzik.org>
Date: Thu, 26 Mar 2009 02:24:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090325185824.GO32307@mit.edu>	 <20090325194851.GA1617@infradead.org> <20090325215016.GP32307@mit.edu>	 <20090326021034.GA26559@srcf.ucam.org>	 <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>	 <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>	 <49CAEDA7.1080902@garzik.org>	 <f73f7ab80903252003j248b416ewe52b613c5b53066c@mail.gmail.com>	 <alpine.LFD.2.00.0903252017100.3032@localhost.localdomain> <f73f7ab80903252158o1d722068j117b4e9933f67589@mail.gmail.com>
In-Reply-To: <f73f7ab80903252158o1d722068j117b4e9933f67589@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Really, I think virtually all of the database programs would be
> perfectly happy with an "fsbarrier(fd, flags)" syscall, where if "fd"
> points to a regular file or directory then it instructs the underlying
> filesystem to do whatever internal barrier it supports, and if not
> just fail with -ENOTSUPP (so you can fall back to fdatasync(), etc).
> Perhaps "flags" would allow a "data" or "metadata" barrier, but if not
> it's not a big issue.

If you want a per-fd barrier call, there is always sync_file_range(2)


> If a user-level tool needs to enforce ordering
> between IOs the only tool right now is is a full flush

or sync_file_range(2)...

	Jeff



