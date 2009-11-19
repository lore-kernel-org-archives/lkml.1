Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbZKSVgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbZKSVgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZKSVgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:36:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59013 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZKSVgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:36:46 -0500
Message-ID: <4B05BA72.2030406@garzik.org>
Date: Thu, 19 Nov 2009 16:36:50 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <20091117145137.15430.11229.stgit@localhost.localdomain> <200911181919.19127.bzolnier@gmail.com>
In-Reply-To: <200911181919.19127.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2009 01:19 PM, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 17 November 2009 15:51:39 Alan Cox wrote:
>> Signed-off-by: Alan Cox<alan@linux.intel.com>
>> ---
>>
>>   drivers/ata/Kconfig |    8 ++++----
>>   1 files changed, 4 insertions(+), 4 deletions(-)
>>
>>
>> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
>> index f2df6e2..36931e0 100644
>> --- a/drivers/ata/Kconfig
>> +++ b/drivers/ata/Kconfig
>> @@ -374,7 +374,7 @@ config PATA_HPT366
>>   	  If unsure, say N.
>>
>>   config PATA_HPT37X
>> -	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
>> +	tristate "HPT 370/370A/371/372/374/302 PATA support"
>>   	depends on PCI&&  EXPERIMENTAL
>>   	help
>>   	  This option enables support for the majority of the later HPT
>> @@ -383,7 +383,7 @@ config PATA_HPT37X
>>   	  If unsure, say N.
>>
>>   config PATA_HPT3X2N
>> -	tristate "HPT 372N/302N PATA support (Experimental)"
>> +	tristate "HPT 372N/302N PATA support"
>>   	depends on PCI&&  EXPERIMENTAL
>>   	help
>>   	  This option enables support for the N variant HPT PATA
>
> Maybe they are 'stable' but when it comes to features they are behind hpt366
> (i.e. they lack PCI PM), which is also much cleaner than your drivers, easier
> to understand and much smaller..

That sounds like an ACK to Alan's patch, to me ;-)

A libata driver can be stable, yet not have all the features of drivers/ide.

That said, I do agree that libata drivers need to have the features 
found in the drivers/ide/ drivers.

	Jeff



