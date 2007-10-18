Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbXJRKKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbXJRKKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXJRKKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:10:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbXJRKKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:10:36 -0400
Date: Thu, 18 Oct 2007 12:10:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018100959.GQ5063@kernel.dk>
References: <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47172FB1.5020704@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Jeff Garzik wrote:
> Jens Axboe wrote:
>> That should work as well. WRT ata_sg_is_last(), if we go ahead with my
>> recent sg chaining updates, we can keep the test as it would be a single
>> conditional and not require any looping.
>> Let me know when you have tested this!
>
> The patch I attached to the last email got both sata_mv test boxes working 
> reliably (so far).
>
> I worked up a patch that kills ata_sg_is_last() (plus the max_phys_segments 
> sata_mv fix), see attached.  I'm thinking this is what I like to see in 
> upstream.

Great!

> Of course, this doesn't explain why ata_sg_is_last() was broken, but since 
> it's working _and_ slightly more efficient, I don't really care :)

Tomo and I agreed to kill sg_last() a few days ago anyways, so this is
perfectly fine with me.

-- 
Jens Axboe

