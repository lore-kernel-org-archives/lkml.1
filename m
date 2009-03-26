Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZCZCoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZCZCoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZCZCnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:43:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51442 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZCZCnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:43:50 -0400
Date: Thu, 26 Mar 2009 02:42:20 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
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
Message-ID: <20090326024220.GB27004@srcf.ucam.org>
References: <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org> <20090325215016.GP32307@mit.edu> <20090326021034.GA26559@srcf.ucam.org> <49CAEA2F.5000801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CAEA2F.5000801@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 10:36:31PM -0400, Jeff Garzik wrote:
> Matthew Garrett wrote:
> >The problem is that you're insisting that the only way 
> >applications can ensure that their requests occur in order is to use 
> >fsync(), which will achieve that but also provides guarantees above and 
> >beyond what the majority of applications want.
> 
> That remains a true statement...   without the *sync* syscalls, you 
> still do not have a _guarantee_ writes occur in a certain order.

The interesting case is whether data hits disk before metadata when 
renaming over the top of an existing file, which appears to be 
guaranteed in the default ext4 configuration now? I'm sure there are 
filesystems where this isn't the case, but that's mostly just an 
argument that it's not sensible to use those filesystems if your 
system's at any risk of crashing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
