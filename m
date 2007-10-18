Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbXJRUlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbXJRUlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbXJRUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:41:17 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27654 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288AbXJRUlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:41:16 -0400
Date: Thu, 18 Oct 2007 22:41:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
Subject: Re: libata crash
Message-ID: <20071018204111.GN10674@kernel.dk>
References: <20071018164745.GD10674@kernel.dk> <20071018192839.GA17247@elte.hu> <20071018193236.GJ10674@kernel.dk> <20071018195903.GA29567@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018195903.GA29567@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > I'll see if I can spend some time tonight chopping the patch into 
> > digestable pieces, unfortunately I'll be away the next three days. And 
> > it would be nice to get this thing merged asap.
> 
> and make sure it builds:
> 
> drivers/scsi/fd_mcs.c: In function 'fd_mcs_intr':
> drivers/scsi/fd_mcs.c:976: error: 'struct scatterlist' has no member named 'page'
> drivers/scsi/fd_mcs.c:1009: error: 'struct scatterlist' has no member named 'page'
> drivers/scsi/fd_mcs.c: In function 'fd_mcs_queue':
> drivers/scsi/fd_mcs.c:1112: error: 'struct scatterlist' has no member named 'page'
> drivers/scsi/in2000.c: In function 'in2000_queuecommand':
> drivers/scsi/in2000.c:375: error: 'struct scatterlist' has no member named 'page'
> drivers/scsi/in2000.c: In function 'transfer_bytes':
> drivers/scsi/in2000.c:767: error: 'struct scatterlist' has no member named 'page'

Oops, wonder why they were missed in the allyes/modconfig. Fixed now,
thanks!

-- 
Jens Axboe

