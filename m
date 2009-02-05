Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZBEW1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZBEW1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZBEW1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:27:23 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:42009 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZBEW1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GmnVy7D5H+M4HBl021Df3UUtkNI2mbAQ8QcRVm3q9qCjdNVjNol+mVcXM+c4G2yhRq
         N0d28A6uUSx1U2TYDRZZjiiHotfLnIF+p3xVb3n11Ep3tpigAbmNulRbE66n1YHcZlmv
         2lf2HiXhXvCn4Vrv1+HZ/wSI9uJWNC7mxExoo=
MIME-Version: 1.0
In-Reply-To: <20090205140255.b711b929.akpm@linux-foundation.org>
References: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
	 <1233822411-10210-3-git-send-email-cooloney@kernel.org>
	 <20090205140255.b711b929.akpm@linux-foundation.org>
Date: Thu, 5 Feb 2009 17:27:21 -0500
Message-ID: <8bd0f97a0902051427m2513bd07hddf4611696658b42@mail.gmail.com>
Subject: Re: [PATCH 2/3] mtd/maps: blackfin async flash maps: bfin-async mtd 
	driver needs complex mappings
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 17:02, Andrew Morton wrote:
> On Thu,  5 Feb 2009 16:26:50 +0800 Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
> This is an underwhelming changelog.
>
>>  drivers/mtd/maps/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
>> index 0225cbb..043d50f 100644
>> --- a/drivers/mtd/maps/Kconfig
>> +++ b/drivers/mtd/maps/Kconfig
>> @@ -491,7 +491,7 @@ config MTD_PCMCIA_ANONYMOUS
>>
>>  config MTD_BFIN_ASYNC
>>       tristate "Blackfin BF533-STAMP Flash Chip Support"
>> -     depends on BFIN533_STAMP && MTD_CFI
>> +     depends on BFIN533_STAMP && MTD_CFI && MTD_COMPLEX_MAPPINGS
>>       select MTD_PARTITIONS
>>       default y
>>       help
>
> I assume this corrects a build error?

yes ... bfin-async uses complex mappings and so needs it
-mike
