Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbXFGJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbXFGJmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbXFGJmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:42:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:47725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXFGJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=gjx6Q54z6YLvnrR35xXA6JuoG2Dt+A1URSnc7y7iRKQoOBw8vgizU+qyENcMya/Cpva7HP1v5Jv60jVmYrzTj5U5v6Nl2UOMV0zaod+muQxouYY8zea4vDAvt0qcdOqkKua/WNUm7bTksWDVhAJYInZ8xEdM6466Hms+Wcvt/Pc=
Message-ID: <4667D2DF.30207@googlemail.com>
Date: Thu, 07 Jun 2007 11:41:51 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>	 <4667018D.7020407@googlemail.com> <1181168095.3612.4.camel@lov.localdomain>	 <4667C47C.2010207@googlemail.com> <1181206091.3625.9.camel@lov.localdomain>
In-Reply-To: <1181206091.3625.9.camel@lov.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers pisze:
> On Thu, 2007-06-07 at 10:40 +0200, Michal Piotrowski wrote:
>> Kay Sievers pisze:
>>> On Wed, 2007-06-06 at 20:48 +0200, Michal Piotrowski wrote:
>>>> Andrew Morton pisze:
>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>>>>>
>>>> Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 initrd
>>>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg
>>>>
>>>> Please fix it ASAP, I can't test kernel...
>>> Do you have CONFIG_SYSFS_DEPRECATED set or unset?
>>>
>>> Kay
>>>
>>>
>> cat ../linux-mm-bo/.config | grep CONFIG_SYSFS_DEPRECATED
>> # CONFIG_SYSFS_DEPRECATED is not set
> 
> Oh, could you possibly try (with the block patch included) setting it to
> yes and see if it works? That would help to find what's going wrong.

I enabled CONFIG_SYSFS_DEPRECATED and 2.6.22-rc4-mm2 boots fine.

Regards,
Michal

-- 
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
