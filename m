Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbYKFQZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbYKFQZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYKFQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:25:29 -0500
Received: from host254-130-static.190-82-b.business.telecomitalia.it ([82.190.130.254]:60539
	"EHLO nausicaa2.coritel.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYKFQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:25:28 -0500
Message-ID: <49131A80.3000402@coritel.it>
Date: Thu, 06 Nov 2008 17:25:36 +0100
From: Marco Stornelli <marco.stornelli@coritel.it>
Organization: CoRiTeL
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: mtk.manpages@gmail.com
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] documentation: xip documentation update
References: <49130E3C.5040203@coritel.it> <cfd18e0f0811060742v46dd3f9eod624954cd9dcda3d@mail.gmail.com>
In-Reply-To: <cfd18e0f0811060742v46dd3f9eod624954cd9dcda3d@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michael Kerrisk wrote:
> Marco,
> 
> A few comments below.
> 
> On Thu, Nov 6, 2008 at 10:33 AM, Marco Stornelli
> <marco.stornelli@coritel.it> wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> xip documentation updated
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>>
>> --- a/Documentation/filesystems/xip.txt.orig    2008-08-20 20:11:37.000000000 +0200
>> +++ b/Documentation/filesystems/xip.txt 2008-11-06 12:47:48.000000000 +0200
>> @@ -39,10 +39,11 @@ The block device operation is optional,
>>  today:
>>  - dcssblk: s390 dcss block device driver
>>
>> -An address space operation named get_xip_page is used to retrieve reference
>> -to a struct page. To address the target page, a reference to an address_space,
>> -and a sector number is provided. A 3rd argument indicates whether the
> 
>> -function should allocate blocks if needed.
>> +An address space operation named get_xip_mem is used to retrieve reference
> 
> s/reference/a reference/?

Ok, it should actually be "references".

> 
>> +to a page frame number and a kernel address. To obtain these values a reference
>> +to an address_space is provided. This function assigns values to the kmem and
>> +pfn parameters. The 3rd argument indicates whether the function should allocate
> 
> It's a taste thing, but I would write "third" not "3rd".  (I
> appreciate that the existing text already used "3rd", but maybe that
> should be fixed.)

Ok.

> 
>> +blocks if needed.
>>
>>  This address space operation is mutually exclusive with readpage&writepage that
>>  do page cache read/write operations.
> 
> Cheers,
> 
> Michael
> 


I wait for other comments before re-send the patch.
