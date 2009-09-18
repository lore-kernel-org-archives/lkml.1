Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZIRU4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZIRU4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbZIRU4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:56:03 -0400
Received: from mail.candelatech.com ([208.74.158.172]:40693 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687AbZIRUz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:55:59 -0400
Message-ID: <4AB3F3DB.5090600@candelatech.com>
Date: Fri, 18 Sep 2009 13:55:55 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems booting 2.6.31 on Fedora 8
References: <4AB3C9A8.4060700@candelatech.com> <200909182248.21032@blacky.localdomain>
In-Reply-To: <200909182248.21032@blacky.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2009 11:48 AM, Nikita V. Youshchenko wrote:
>> I'm having troubles booting 2.6.31 on Fedora 8.  The same kernel
>> boots fine on F11, but on F8, it cannot find the root logical volume.
>>
>> One thing I notice is that F11 uses root=/dev/mapper... and F8 uses
>> root=/dev/VolGroup00/LogVol00 in grub.  It's not clear to me what
>> the value of mapper should be...is there some way to figure this
>> out from an older kernel (2.6.29) that boots fine?
>
> I've recently faced a very similar problem, trying to boot some "modern"
> kernel on debian etch system.
>
> It was solved by putting more recent lvm2 binary into initrd.

The LVM2 mailing list gave me another answer:

Compile with
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y


This will likely not work on later distributions, but seems to work
fine for Fedora 8, at least.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

