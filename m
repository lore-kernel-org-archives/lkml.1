Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbXGJPp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbXGJPp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbXGJPpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:45:11 -0400
Received: from THUNK.ORG ([69.25.196.29]:40585 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbXGJPpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:45:09 -0400
Date: Tue, 10 Jul 2007 11:45:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-ID: <20070710154503.GC27033@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
	Amit Arora <aarora@in.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710090737.GA16519@osiris.boeblingen.de.ibm.com> <20070710022213.81e7b432.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710022213.81e7b432.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 02:22:13AM -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 11:07:37 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > We reserved a different syscall number than the one that is used right now
> > in the patch. Please drop this patch... Martin or I will wire up the syscall
> > as soon as the x86 variant is merged. Everything else just causes trouble and
> > confusion.
> 
> OK, I dropped all the fallocate patches.

Andrew, I want to clarify who is going to push the fallocate patches.
I can either push them to Linus as part of the ext4 patch set, or we
can wait for you to push them.  I thought since you had them in -mm
and we were going to wait you to push them (and presume that this was
going to happen soon).

Alternatively I can push them directly to Linus along with other ext4
patches.  We can drop the s390 patch if Martin or Heiko wants to wire
it up themselves.

As far as I know there hasn't been any real contention on the actual
syscall patches, other than the numbering issues, so it seems that
pushing them to Linus sooner rather than later is the right thing to
do. 

I don't particularly care who pushes them, just as long as they get
pushed.  :-)  

So if you've dropped, shall I push them to Linus as part of the ext4
patches we've been planning on pushing?

Regards,

					- Ted
