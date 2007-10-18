Return-Path: <linux-kernel-owner+w=401wt.eu-S1763918AbXJRKRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763918AbXJRKRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbXJRKRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:17:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15024 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbXJRKR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:17:28 -0400
Date: Thu, 18 Oct 2007 12:16:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018101650.GR5063@kernel.dk>
References: <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk> <20071018101348.GA29296@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018101348.GA29296@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > Of course, this doesn't explain why ata_sg_is_last() was broken, but 
> > > since it's working _and_ slightly more efficient, I don't really 
> > > care :)
> > 
> > Tomo and I agreed to kill sg_last() a few days ago anyways, so this is 
> > perfectly fine with me.
> 
> it would still be nice to figure out exactly why it was broken.

It would always be nice. For this case I don't think it's very
interesting, if we pursue the improved sg iteration setup.

-- 
Jens Axboe

