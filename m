Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZKWIaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZKWIaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZKWIaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:30:25 -0500
Received: from aa003msb.fastweb.it ([85.18.95.82]:39506 "EHLO
	aa003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZKWIaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:30:24 -0500
Message-ID: <4B0A4813.7060305@evidence.eu.com>
Date: Mon, 23 Nov 2009 09:30:11 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH TRIVIAL] atmel_lcdfb.c: Fix sinfo->irqbase from %lu to
   %d in dev_info().
References: <1255083621-25147-1-git-send-email-nicolas.ferre@atmel.com> <alpine.LSU.2.00.0910091730560.19284@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910091730560.19284@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina ha scritto:
> On Fri, 9 Oct 2009, Nicolas Ferre wrote:
> 
>> From: Claudio Scordino <claudio@evidence.eu.com>
>>
>> This patch fixes a type mismatch when calling dev_info() in the
>> atmel_lcdfb.c driver.
>>
>> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  drivers/video/atmel_lcdfb.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
>> index 2830ffd..317afab 100644
>> --- a/drivers/video/atmel_lcdfb.c
>> +++ b/drivers/video/atmel_lcdfb.c
>> @@ -959,7 +959,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
>>  	if (sinfo->atmel_lcdfb_power_control)
>>  		sinfo->atmel_lcdfb_power_control(1);
>>  
>> -	dev_info(dev, "fb%d: Atmel LCDC at 0x%08lx (mapped at %p), irq %lu\n",
>> +	dev_info(dev, "fb%d: Atmel LCDC at 0x%08lx (mapped at %p), irq %d\n",
>>  		       info->node, info->fix.mmio_start, sinfo->mmio, sinfo->irq_base);
>>  
>>  	return 0;
> 
> Applied, thanks.
> 

Hi,

    may I ask you the current status of this patch ? I noticed that it
has not been merged, yet.

Do we have any idea when it will be done ?

Since it is a trivial fix, I think it should be merged before the
release of v2.6.32 (i.e., waiting the next merge window does not make
much sense for such a trivial fix...).

Many thanks,

             Claudio


