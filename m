Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZHLVBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZHLVBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbZHLVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:01:10 -0400
Received: from mail.ruggedcom.com ([204.50.190.93]:14574 "EHLO
	mail.ruggedcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbZHLVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:01:10 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2009 17:01:09 EDT
Message-ID: <4A832D11.3020802@ruggedcom.com>
Date: Wed, 12 Aug 2009 16:58:57 -0400
From: Michael Barkowski <michaelbarkowski@ruggedcom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru> <20090731004100.GB8371@oksana.dev.rtsoft.ru> <4A832A03.6020507@ruggedcom.com> <20090812205800.GA27074@oksana.dev.rtsoft.ru>
In-Reply-To: <20090812205800.GA27074@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 20:59:03.0723 (UTC) FILETIME=[B956D7B0:01CA1B8F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Wed, Aug 12, 2009 at 04:45:55PM -0400, Michael Barkowski wrote:
>> Hello Anton,
>>
>> Is m25p_probe now valid with dev.platform_data == NULL, for of platforms?
>>
>> Then shouldn't you have the following change as well, near the end of
>> the function?
>>
>> -  	} else if (data->nr_parts)
>> +  	} else if (data && data->nr_parts)
>> 		dev_warn(&spi->dev, "ignoring %d default partitions on %s\n",
>> 				data->nr_parts, data->name);
>>
>> Or am I misunderstanding something?
> 
> Yeah, you missed this patch:
> http://patchwork.kernel.org/patch/38179/
> 
> 
> Thanks,
> 

Beautiful - thanks - sorry to interrupt

-- 
Michael Barkowski
905-482-4577
