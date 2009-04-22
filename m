Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZDVGzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZDVGzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZDVGzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:55:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48623 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZDVGzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:55:02 -0400
Date: Wed, 22 Apr 2009 08:54:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Peter Osterlund <petero2@telia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/pktcdvd.h: add mempool.h dependency
Message-ID: <20090422065430.GA26384@elte.hu>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090422062053.GA20960@elte.hu> <20090422063833.GA23258@elte.hu> <20090422063954.GW4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422063954.GW4593@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Apr 22 2009, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > A last-minute build error slipped through:
> > >
> > >   In file included from fs/compat_ioctl.c:105:
> > >   include/linux/pktcdvd.h:285: error: expected specifier-qualifier-list before ???mempool_t???
> > 
> > Caused by:
> > 
> >   1ba0c7d: fs/compat_ioctl: fix build when !BLOCK
> > 
> > fixed by the patch below. The build error itself triggers with 
> > !BLOCK
> 
> This fix is already queued up in the block tree, it just didn't 
> make -rc3.

ah, i see - it was posted two days ago:

  [PATCH 2/2] pktcdvd.h should include mempool.h

but the fix should have been queued up in the tree pushing the 
compat_ioctl.c change (Viro's). Could have been avoided by insisting 
on a fuller explanation in the changelog instead of just a "Fix this 
build error" line.

	Ingo
