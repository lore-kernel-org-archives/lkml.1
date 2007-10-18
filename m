Return-Path: <linux-kernel-owner+w=401wt.eu-S1765979AbXJROPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765979AbXJROPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXJROPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:15:07 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23381 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbXJROPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:15:06 -0400
Date: Thu, 18 Oct 2007 16:14:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018141426.GQ5063@kernel.dk>
References: <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <20071018125840.GF5063@kernel.dk> <20071018133200.GH5063@kernel.dk> <471764CB.5020906@rtr.ca> <20071018135810.GM5063@kernel.dk> <4717695B.5020806@rtr.ca> <47176A18.204@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47176A18.204@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Mark Lord wrote:
> Mark Lord wrote:
>>> On Thu, Oct 18 2007, Mark Lord wrote:
>>>> > Jens wrote:
>>>>> >> OK, I think that covers every arch out there. I haven't been able to
>>>>> >> compile any of them, but it's mostly search'n replace operations. I 
>>>>> hope
>>>>> >> nothing is missing linux/scatterlist.h includes...
>>>> >
>>>> > Patch fails on drivers/scsi/scsi_lib.c.
>>>> >
>>>> > I replaced that part of the patch with this updated portion instead:
>>>
>>> Hmm, what are you applying against? Must be a clean tree, throw away any
>>> patches that you already applied in this thread.
>>>
>>> Updated below.
>> I'll re-pull everything fresh again from kernel.org and rebuild
>> with the "updated below" patch you posted.  Thanks.
>
> Okay, fresh pull of everything from kernel.org,
> and now your latest patch does apply cleanly to -git13.
>
> Something weird (at this end).

Thanks for confirming, I did double check that my HEAD was uptodate -
and it is.

-- 
Jens Axboe

