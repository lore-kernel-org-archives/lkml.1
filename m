Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYIML1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYIML1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 07:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYIML0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 07:26:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:23249 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYIML0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 07:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F6KZGNwVHAdzBiJyQ+MxCxIcVSPQ2xXVGPFVF6vIcXZU3n0ftqC2iSpvZZSS7AHl92
         BBXnuXDhSUlDkJM4vMIT4B6JDOivYNEVsKqi8vbntGF3xN2iEMH1E1a9qPb6RhtRcn4Y
         hcw7BdBYTK3M8xJq4EhnMNFgyxw6+1SQ9sF2c=
Message-ID: <48CBA377.9020802@gmail.com>
Date: Sat, 13 Sep 2008 04:26:47 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [MTD] physmap.c: Add #endif comments
References: <48CB5E9F.9060109@gmail.com> <20080913104641.GE21603@xi.wantstofly.org>
In-Reply-To: <20080913104641.GE21603@xi.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek wrote:
> On Fri, Sep 12, 2008 at 11:33:03PM -0700, Zev Weiss wrote:
> 
>> Adding comments to a few of the less painfully-obvious #endifs.
>>
>> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
>> ---
>>   drivers/mtd/maps/physmap.c |    6 +++---
>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
>> index 6fba0d4..49e2039 100644
>> --- a/drivers/mtd/maps/physmap.c
>> +++ b/drivers/mtd/maps/physmap.c
>> @@ -244,7 +244,7 @@ static void physmap_flash_shutdown(struct platform_device *dev)
>>   #define physmap_flash_suspend NULL
>>   #define physmap_flash_resume NULL
>>   #define physmap_flash_shutdown NULL
>> -#endif
>> +#endif /* CONFIG_PM */
>>
>>   static struct platform_driver physmap_flash_driver = {
>>   	.probe		= physmap_flash_probe,
>> @@ -302,8 +302,8 @@ void physmap_set_partitions(struct mtd_partition *parts, int
>> num_parts)
>>   	physmap_flash_data.nr_parts = num_parts;
>>   	physmap_flash_data.parts = parts;
>>   }
>> -#endif
>> -#endif
>> +#endif /* CONFIG_MTD_PARTITIONS */
>> +#endif /* PHYSMAP_COMPAT */
> 
> I thought that this was frowned upon.  (I don't like it myself, and
> my editor is perfectly well capable of pointing out to me which ifdef
> matches up with which endif.)
> 

Ah, OK -- I found it slightly hard to follow the ones that get longer than a 
screenful or so, and I don't have my editor set to match them up nicely (though I 
might look into that).  It's something I'm accustomed to doing and seeing, and I saw 
no mention of it one way or another in Documentation/CodingStyle, so I didn't really 
give it a second thought.


