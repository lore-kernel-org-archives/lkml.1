Return-Path: <linux-kernel-owner+w=401wt.eu-S933978AbXJROq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbXJROq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762654AbXJROqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:46:15 -0400
Received: from lixom.net ([66.141.50.11]:48927 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbXJROqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:46:15 -0400
Date: Thu, 18 Oct 2007 09:52:38 -0500
From: Olof Johansson <olof@lixom.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tejun Heo <htejun@gmail.com>, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018145238.GA5565@lixom.net>
References: <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk> <471738A6.2020201@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471738A6.2020201@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 06:42:46AM -0400, Jeff Garzik wrote:
> Jens Axboe wrote:
>> On Thu, Oct 18 2007, Jeff Garzik wrote:
>>> Jens Axboe wrote:
>>>> That should work as well. WRT ata_sg_is_last(), if we go ahead with my
>>>> recent sg chaining updates, we can keep the test as it would be a single
>>>> conditional and not require any looping.
>>>> Let me know when you have tested this!
>>> The patch I attached to the last email got both sata_mv test boxes 
>>> working reliably (so far).
>>>
>>> I worked up a patch that kills ata_sg_is_last() (plus the 
>>> max_phys_segments sata_mv fix), see attached.  I'm thinking this is what 
>>> I like to see in upstream.
>> Great!
>>> Of course, this doesn't explain why ata_sg_is_last() was broken, but 
>>> since it's working _and_ slightly more efficient, I don't really care :)
>> Tomo and I agreed to kill sg_last() a few days ago anyways, so this is
>> perfectly fine with me.
>
> Yep, the [attached] patch that kills ata_sg_is_last() is working here on 
> both machines that were previously croaking.
>
> It would be nice to get pdc_adma, sata_sil24 and ipr it-works test done, 
> but IMO the patch is pretty straightforward and should be OK.

Tested-by: Olof Johansson <olof@lixom.net>

Looks ok on SATA_SIL24 and SATA_MV here on PPC (together with Jens' latest
patch). Both barfed before.


Thanks!

-Olof
