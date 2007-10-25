Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbXJYIPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbXJYIPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbXJYIPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:15:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14549 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbXJYIPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:15:06 -0400
Date: Thu, 25 Oct 2007 10:13:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Amit Shah <amitshah@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Panic in gart_map_sg
Message-ID: <20071025081321.GG5053@kernel.dk>
References: <877aabc40710250012se0afe99s819207e72726d333@mail.gmail.com> <20071025071239.GA5053@kernel.dk> <877aabc40710250102l7d4cff9ei5c7c3a40b084b32c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877aabc40710250102l7d4cff9ei5c7c3a40b084b32c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25 2007, Amit Shah wrote:
> On 25/10/2007, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Oct 25 2007, Amit Shah wrote:
> > > I get a kernel panic at gart_map_sg+0x201/0x470, which is around here:
> 
> ...
> 
> > Tomo already nailed this one, see below.
> >
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] x86: pci-gart fix
> >
> > map_sg could copy the last sg element to another position (if merging
> > some elements). It breaks sg chaining. This copies only
> > dma_address/length instead of the whole sg element.
> 
> Thanks, this fixed it.


Goodness, thanks for confirming!

-- 
Jens Axboe

