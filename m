Return-Path: <linux-kernel-owner+w=401wt.eu-S1762301AbXGPUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762301AbXGPUKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbXGPUKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:10:43 -0400
Received: from brick.kernel.dk ([80.160.20.94]:21451 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXGPUKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:10:43 -0400
Date: Mon, 16 Jul 2007 22:10:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg
	helpers
Message-ID: <20070716201002.GQ5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681830-git-send-email-jens.axboe@oracle.com> <20070716130608.4d096e29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716130608.4d096e29.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, Andrew Morton wrote:
> On Mon, 16 Jul 2007 11:47:23 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > This prepares x86-64 for sg chaining support.
> > 
> > Additional improvements/fixups for pci-gart from
> > Benny Halevy <bhalevy@panasas.com>
> > 
> > Cc: ak@suse.de
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  arch/x86_64/kernel/pci-calgary.c |   25 ++++++++------
> >  arch/x86_64/kernel/pci-gart.c    |   63 ++++++++++++++++++++-----------------
> >  arch/x86_64/kernel/pci-nommu.c   |    5 ++-
> >  3 files changed, 51 insertions(+), 42 deletions(-)
> 
> This causes fairly extensive destruction of 2.6.23 changes which are
> pending in Andi's tree.
> 
> I shall drop the block tree until a) Andi has merged the pending Calgary
> changes and b) the block tree has been fixed up to account for those (and
> other) changes.
> 
> Really, this was the perfectly worst time possible to go tromping all over
> everyone else's trees.

Well, that's a bit hard for me to know, all I can do is push my stuff to
for-akpm so that it gets -mm exposure. If I don't, then you are yelling
at me as well :-)

I'll keep rebasing sglist and the other branches I pull into for-akpm,
so you can just re-enable the for-akpm pull when the a) is true.

-- 
Jens Axboe

