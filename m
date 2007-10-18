Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbXJRHGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbXJRHGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbXJRHGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:06:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19463 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbXJRHGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:06:14 -0400
Date: Thu, 18 Oct 2007 09:05:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018070538.GD5063@kernel.dk>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716DB9A.2060809@rtr.ca> <4716DE82.2050006@rtr.ca> <4716E19F.1090201@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4716E19F.1090201@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Jeff Garzik wrote:
> Mark Lord wrote:
>> Okay, mine is dying with EIP at blk_rq_map_sg+0xcb/0x160.
>> Screen photo is at http://rtr.ca/recent/2.6.23-git12-crash.jpg,
>> but the top was cut off (isn't there a new config option or patch
>> to do double-columns or scrollback or something ???.
>
> Is this a sata_mv box?  If so, could you try this patch?

If anything, that shrinks the size of the resulting request. Did this
patch make any difference to you?

Now sata_mv should not be doing this (already discussed), but as long as
it's only lowering the physical sg count then it should not cause any
bugs at least.

-- 
Jens Axboe

