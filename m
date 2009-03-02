Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZCBNDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZCBNDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZCBND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:03:28 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:13316 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZCBND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:03:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cac4UT9/HjzNgk2CGSyY3XIJ5VvvlS2OerNec8TFvUZFSHTpOds6uNrILC+746u+NB
         83IB7gBp3tnuQRJORuI9/E4iRZnHwQqcMgvYG/4k/zCH/3Z9/R/0YRaNlisFJWvKCQdw
         j+yRRbeMVPZs5SLamOU4fl5gJdJv5G86BXWhI=
MIME-Version: 1.0
In-Reply-To: <20090302122547.GT11787@kernel.dk>
References: <d364733c0903012106g2625d433o4cdbbbcc5a9ff19a@mail.gmail.com>
	 <20090302122547.GT11787@kernel.dk>
Date: Mon, 2 Mar 2009 21:03:25 +0800
Message-ID: <d364733c0903020503x43a1448cq1b127a88fd816e1c@mail.gmail.com>
Subject: Re: The difference of request dir between AS and Deadline I/O 
	scheduler?
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you mean that the same process tends to have the same behavior of
I/O in the way of sycn?
Does this mean AS works better when requests are distincted by sync
mode  (the success rate of anticipation is higher when requests are
grouped by the mode of sync)?

Thanks,


On Mon, Mar 2, 2009 at 8:25 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Mar 02 2009, ???? wrote:
>> Hi,
>>
>> I'm little confused about the defination of request dir in AS and
>> Deadline I/O scheduler.
>> In AS, the request dir is defined by wheher it's sync:
>>
>> data_dir = rq_is_sync(rq);
>>
>> But in Deadline, the requests are grouped by read and write.
>>
>> Why is there the difference since AS is an extension of Deadline?
>> what's the consideration?
>
> Because AS uses the sync vs async distinction to decide whether to
> anticipate a new request from that process. 'sync' is then reads or sync
> writes, whereas deadline does not distinguish between sync and async
> writes.
>
> --
> Jens Axboe
>
>



-- 
Xie Gang
