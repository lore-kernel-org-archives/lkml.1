Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbZD3Imq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbZD3Imq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZD3Img
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:42:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45474 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZD3Imf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:42:35 -0400
Message-ID: <49F96473.5070401@redhat.com>
Date: Thu, 30 Apr 2009 10:42:27 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nikanth K <nikanth@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] block: remove unused __REQ_NR_BITS
References: <49F85D9C.4000405@redhat.com> <807b3a220904300112vf8e77e5g5075eeb8f63e029d@mail.gmail.com>
In-Reply-To: <807b3a220904300112vf8e77e5g5075eeb8f63e029d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

Never mind, I missed your patch.

Jerome

Nikanth K wrote:
> Hi Jerome
> 
> On Wed, Apr 29, 2009 at 7:31 PM, Jerome Marchand <jmarchan@redhat.com> wrote:
>> Removes __REQ_NR_BITS which is not used since its only user
>> (blk_dump_rq_flags()) stopped to use it.
>>
> 
> See http://lkml.org/lkml/2009/4/27/140
> 
> A user for it is added by a patch in linux-2.6-block#for-2.6.31
> see http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=9eb55b030c4b3227334ee4482402096cd1d1a6fe
> 
> Thanks
> Nikanth
> 
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 2755d5c..a101821 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -119,7 +119,6 @@ enum rq_flag_bits {
>>        __REQ_INTEGRITY,        /* integrity metadata has been remapped */
>>        __REQ_NOIDLE,           /* Don't anticipate more IO after this one */
>>        __REQ_IO_STAT,          /* account I/O stat */
>> -       __REQ_NR_BITS,          /* stops here */
>>  };
>>
>>  #define REQ_RW         (1 << __REQ_RW)
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

