Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZCZCsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZCZCsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCZCsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:48:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45668 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZCZCsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:48:30 -0400
Date: Thu, 26 Mar 2009 02:47:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090326024753.GA27299@srcf.ucam.org>
References: <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org> <20090325215016.GP32307@mit.edu> <20090326021034.GA26559@srcf.ucam.org> <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 10:44:44PM -0400, Kyle Moffett wrote:

>    Perhaps we ought to add a couple extra open flags, O_BARRIER_BEFORE and
>    O_BARRIER_AFTER, and rename3(), etc functions that take flags arguments?
>    Or maybe a new set of syscalls like barrier(file1, file2) and
>    fbarrier(fd1, fd2), which cause all pending changes (perhaps limit to this
>    process?) to the file at fd1 to occur before any successive changes (again
>    limited to this process?) to the file at fd2.

That's an option, but what would benefit? If rename is expected to 
preserve ordering (which I think it has to, in order to avoid breaking 
existing code) then are there any other interesting use cases?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
