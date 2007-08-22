Return-Path: <linux-kernel-owner+w=401wt.eu-S1764693AbXHVTEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764693AbXHVTEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761636AbXHVTE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:04:26 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:49228 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764060AbXHVTEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:04:25 -0400
Message-ID: <46CC88B3.6080000@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 00:34:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [BUG] 2.6.23-rc3-mm1 - kernel BUG at net/core/skbuff.c:95!
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC33EC.1040803@linux.vnet.ibm.com> <20070822085002.8a116f72.akpm@linux-foundation.org> <1187805493.5303.11.camel@lov.localdomain>
In-Reply-To: <1187805493.5303.11.camel@lov.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>> gargh, sorry, that's probably due to my screwed up attempt to fix Kay's
>> screwed up
>> gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
>>
>> Kay sent an update patch but it didn't arrive in time.
>>
>> Greg, if you haven't yet merged that, please do so asap?
>>
>> So what _should_ this:
>>
>> --- a/arch/powerpc/kernel/vio.c~fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
>> +++ a/arch/powerpc/kernel/vio.c
>> @@ -373,7 +373,7 @@ static int vio_hotplug(struct device *de
>>  	dn = dev->archdata.of_node;
>>  	if (!dn)
>>  		return -ENODEV;
>> -	cp = of_get_property(dn, "compatible", &length);
>> +	cp = of_get_property(dn, "compatible", &env->buflen);
>>  	if (!cp)
>>  		return -ENODEV;
>>  
>> _
>>
>> have done?
> 
> Does replacing "&length" with "NULL" work? That's what's in the updated
> patch.
> 

Hi, Kay,

replacing &length with NULL does not work for me. I get a message saying that
init terminated with signal 7.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
