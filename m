Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYIWHCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYIWHCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 03:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYIWHBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 03:01:50 -0400
Received: from host254-130-static.190-82-b.business.telecomitalia.it ([82.190.130.254]:55317
	"EHLO nausicaa2.coritel.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYIWHBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 03:01:49 -0400
Message-ID: <48D894BC.8010002@coritel.it>
Date: Tue, 23 Sep 2008 09:03:24 +0200
From: Marco Stornelli <marco.stornelli@coritel.it>
Organization: CoRiTeL
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: mtk.manpages@gmail.com, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] documentation: xip documentation update
References: <48D76770.9000808@coritel.it> <20080922083050.3ec7b7e9.rdunlap@xenotime.net>
In-Reply-To: <20080922083050.3ec7b7e9.rdunlap@xenotime.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, have I to submit the patch again with this new line?

Randy Dunlap ha scritto:
> On Mon, 22 Sep 2008 11:37:52 +0200 Marco Stornelli wrote:
> 
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> xip documentation updated
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>>
>> --- linux-2.6.26.5/Documentation/filesystems/xip.txt.orig	2008-08-20 20:11:37.000000000 +0200
>> +++ linux-2.6.26.5/Documentation/filesystems/xip.txt	2008-09-22 11:27:46.000000000 +0200
>> @@ -39,10 +39,11 @@ The block device operation is optional,
>>  today:
>>  - dcssblk: s390 dcss block device driver
>>  
>> -An address space operation named get_xip_page is used to retrieve reference
>> -to a struct page. To address the target page, a reference to an address_space,
>> -and a sector number is provided. A 3rd argument indicates whether the
>> -function should allocate blocks if needed.
>> +An address space operation named get_xip_mem is used to retrieve reference
>> +to a page frame number and a kernel address. To obtain these values a reference
>> +to an address_space is provided. This function is in charge to assign values to
> 
> How about:
>                                     This function assigns values to the kmem and
>    pfn parameters.
> 
>> +the pointers kmem and pfn. The 3rd argument indicates whether the function 
>> +should allocate blocks if needed.
>>  
>>  This address space operation is mutually exclusive with readpage&writepage that
>>  do page cache read/write operations.
> 
> 
> Thanks.
> 
> ---
> ~Randy
> 

-- 
Marco Stornelli
Embedded Software Engineer
CoRiTeL - Consorzio di Ricerca sulle Telecomunicazioni
http://www.coritel.it

marco.stornelli@coritel.it
+39 06 72582838
