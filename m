Return-Path: <linux-kernel-owner+w=401wt.eu-S1764548AbXJRL5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764548AbXJRL5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761685AbXJRL5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:57:41 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19338 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbXJRL5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:57:40 -0400
Date: Thu, 18 Oct 2007 13:57:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018115702.GW5063@kernel.dk>
References: <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018.045505.106265100.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, 18 Oct 2007 10:21:45 +0200
> 
> > I like it. Basically the only real change is using bit 2 as a
> > termination point, so we avoid going beyond the end of the sgtable.
> > Here's a starting point, it actually booted for me in the first go
> > (boggle). Only x86 so far, archs will need to be converted. And lots
> > more drivers I'm sure, I only fixed up the ones that botched my compile.
> > 
> > So just consider this a directional patch.
> 
> Here are some sparc64 bits:

Thanks a lot, Dave! The patch is a monster right now, I'll work on
splitting it into a 3-step process. Any arch help is greatly
appreciated.

-- 
Jens Axboe

