Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbYICCJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbYICCJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 22:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYICCJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 22:09:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42266 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYICCJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 22:09:24 -0400
Date: Wed, 3 Sep 2008 03:06:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080903020629.GS28946@ZenIV.linux.org.uk>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <alpine.LFD.1.10.0808271335260.3363@nehalem.linux-foundation.org> <20080828135245.GA12410@infradead.org> <20080902072642.GX20055@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902072642.GX20055@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 09:26:43AM +0200, Jens Axboe wrote:
> > Actually both interfaces are a fscking disaster.  The right things to
> > pass is neither and inode nor a file but a struct block_device.  Al had
> > all this work done a while and it just needs rebasing to a current tree:
> > 
> > 	http://git.kernel.org/?p=linux/kernel/git/viro/bdev.git;a=summary
> 
> Completely agreed. Al, I remember talking to you about this at the
> storage summit back in february. What are your current plans wrt moving
> this forward?

Rebased, with nfs parts of fmode_t patch taken out (irrelevant for
bdev anyway and really better off in intent-killing queue).  Other
than that, it's a straight port...  Same place, same branch.
