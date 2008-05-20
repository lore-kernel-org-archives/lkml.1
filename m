Return-Path: <linux-kernel-owner+w=401wt.eu-S934610AbYETPud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbYETPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYETPuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:50:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:1765 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYETPuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QJR/bWgyjFq5Kp1QgCdTQLrBVLIOg8lxhahTmN2YBYHje3PGJ+RdVwv8U9Vzmeo8XZdXdASre0KU2FDmqmNEgPrm0FomTdHiKQbRsjdg3ebEzqgPfrCBJlOpmhHKnbiBmDr123gymjIqu+xG/HWBuTqd0FJCFjm3poSU41Ooq8Y=
Message-ID: <4832F337.4060703@gmail.com>
Date: Tue, 20 May 2008 17:50:15 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Abel Bernabeu <abel.bernabeu@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25: usb-storage unknown partition table issue
References: <48319C1F.6030005@gmail.com> <15577be70805191220h4413a9c1n11d7240a2906e056@mail.gmail.com>
In-Reply-To: <15577be70805191220h4413a9c1n11d7240a2906e056@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abel Bernabeu ha scritto:
> Looks like you did not enable the partition type "PC BIOS".
>
> Type "make menuconfig" and make sure you enabled it on:
>
> Partition types / Advanced partition / pc bios (ms dos partition tables)
>
> Discard any SCSI issue, indeed I am almost sure you can do a "cp
> /dev/sda /dev/null" with no problem (showing that your SCSI driver is
> working properly).
>
> Yours, Abel.
>
>
>
> 2008/5/19 Patrizio Bassi <patrizio.bassi@gmail.com>:
>   
>> Hi,
>>
>> i have a 8GB usb pen with several problem due to partition table.
>>
>> if i create a primary one with fdisk, then format it works ok.
>> then i umount it, unplug, replug, no more partition detected.
>>
>> I formatted it on Windows (same machine) and this some stress test, but it's
>> brand new and it works.
>> The partition and the free space is correctly seen by qtparted and parted,
>> but in the dmesg i see:
>>
>> Initializing USB Mass Storage driver...
>> scsi10 : SCSI emulation for USB Mass Storage devices
>> usb-storage: device found at 2
>> usb-storage: waiting for device to settle before scanning
>> usbcore: registered new interface driver usb-storage
>> USB Mass Storage support registered.
>> usb-storage: device scan complete
>> scsi 10:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI:
>> 2
>> sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
>> sd 10:0:0:0: [sdc] Write Protect is off
>> sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
>> sd 10:0:0:0: [sdc] Assuming drive cache: write through
>> sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
>> sd 10:0:0:0: [sdc] Write Protect is off
>> sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
>> sd 10:0:0:0: [sdc] Assuming drive cache: write through
>> sdc: unknown partition table
>> sd 10:0:0:0: [sdc] Attached SCSI removable disk
>>
>> This makes the partition unasable in my linux 2.6.25 (vanilla) system.
>> Another 1gb usbpen works perfectly.
>>
>> Bus 004 Device 001: ID 1d6b:0001
>> Bus 005 Device 001: ID 1d6b:0001
>> Bus 002 Device 001: ID 1d6b:0001
>> Bus 003 Device 001: ID 1d6b:0001
>> Bus 001 Device 002: ID 1307:0165 Transcend Information, Inc.
>> Bus 001 Device 001: ID 1d6b:0002
>>
>> Anything i can try?
>> It looks a scsi issue. And it's the first time i see the Mode Sense set to 0
>> for any usb storage device.
>>
>> Please CC me i'm not subscribed
>>
>>     
Hi Abel/All,

it doesn't work at all. Actually even other pen i have were formatted in 
windows and they work ok.

And, as said, parted reconize it. now i destroyed and created again with 
parted, but on windows it works, on linux not.

What else to try?

Patrizio
