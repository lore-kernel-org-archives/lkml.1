Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbXGRIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbXGRIKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXGRIKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:10:05 -0400
Received: from brick.kernel.dk ([80.160.20.94]:10669 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXGRIKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:10:03 -0400
Date: Wed, 18 Jul 2007 10:09:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Message-ID: <20070718080935.GC11657@kernel.dk>
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com> <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org> <200707180045.03352.bzolnier@gmail.com> <alpine.LFD.0.999.0707171535170.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707171535170.27353@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 18 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > The new generic SG layer is CONFIG_SCSI=y "generic" in the current tree.
> 
> Yeah. I know, I already talked to Jens about it - in order to be generic, 
> the BSG stuff really does end up having to be able to stand on its own, 
> since not everybody wants/needs the whole SCSI layer.

Fully agree!

> > > obviously the older SCSI-ioctl layer) it should "just work".
> > 
> > Agreed but IDE driver has never claimed to have full SAT layer and
> > full SCSI-ioctl layer support has been provided only for ide-cd.
> 
> I agree, and understand why it happened, but hope that maybe it can be 
> improved in the future, or at least the error returned earlier so that the 
> request will never even hit the ATA device at all if the IDE layer cannot 
> then handle it.
> 
> > For now it should be sufficient to revert ide.c chunks of
> > 
> > commit 3d6392cfbd7dc11f23058e3493683afab4ac13a3
> 
> Jens?

Yep, those were probably a little over eager. I can see that this revert
has already been executed, so perfect.

Yep, those were probably a little over eager. I can see that this revert
has already been executed, so perfect.

-- 
Jens Axboe

