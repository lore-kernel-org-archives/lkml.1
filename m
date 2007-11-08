Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbXKHALL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbXKHALL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbXKHAK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:10:57 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:22243 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbXKHAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:10:56 -0500
Date: Wed, 07 Nov 2007 18:10:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata NCQ blacklist entry
In-reply-to: <fa.V2tP3GajMjY9gJUCTCoOjOocw+0@ifi.uio.no>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Message-id: <47325400.5060702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GsS7Kps/lQSHlhBlf0yXpLzcPLQ@ifi.uio.no>
 <fa.V2tP3GajMjY9gJUCTCoOjOocw+0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Florian La Roche wrote:
>> Hello all,
>>
>> I've taking email addresses from the last NCQ blacklist changes going
>> into the kernel.
>> This Fujitsu drive also gives me spurious command completions. Detailed
>> output also available at https://bugzilla.redhat.com/show_bug.cgi?id=366181.
>>
>> Let me know if you need more info or anything else.
>>
>> --- drivers/ata/libata-core.c
>> +++ drivers/ata/libata-core.c
>> @@ -4222,6 +4222,7 @@
>>  	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
>>  	{ "WDC WD3200AAJS-00RYA0", "12.01B01",	ATA_HORKAGE_NONCQ, },
>>  	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
>> +	{ "FUJITSU MHW2160BJ G2",       NULL,           ATA_HORKAGE_NONCQ },
>>  	{ "ST9120822AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
>>  	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
>>  	{ "ST9160821AS",	"3.ALD",	ATA_HORKAGE_NONCQ, },
> 
> Thanks.  We're currently trying to find out what's actually going on
> with all these drives.  At first, drives which got blacklisted aren't
> many and made sense (had other problems with NCQ, etc..) but with new
> generation drives from many vendors showing the same symptom, we aren't
> too sure now.
> 
> I'll keep your email in my todo list and add the drive to the blacklist
> once the problem is verified.

I agree that something seems fishy with this. It seems unlikely that 
this many drives from multiple vendors would have the exact same, 
relatively obscure problem..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

