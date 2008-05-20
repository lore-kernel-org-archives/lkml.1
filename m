Return-Path: <linux-kernel-owner+w=401wt.eu-S935570AbYETWqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935570AbYETWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935293AbYETWow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:44:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:44172 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935572AbYETWor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M6680Xt9tgEzIlEjAr2D7mWldXw1IrzcBuffuPKk5aPAeX6JtJDm2UmFDhx2Kz2kZr4yFg/IU1gbGdYJCsXzf8+RVo3dfStP/rcgUAKxYfGTwcciC5BYVI8I9lSdwiG+37iCr4UtC6di9kHyXa8hZFw5NpVzWO4Nv/NE7G3OgMw=
Message-ID: <15577be70805201544p1910e8b0k4b179e7198437469@mail.gmail.com>
Date: Wed, 21 May 2008 00:44:46 +0200
From: "Abel Bernabeu" <abel.bernabeu@gmail.com>
To: patrizio.bassi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25: usb-storage unknown partition table issue
In-Reply-To: <4832F337.4060703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48319C1F.6030005@gmail.com>
	 <15577be70805191220h4413a9c1n11d7240a2906e056@mail.gmail.com>
	 <4832F337.4060703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you supply me your .config file? I am sure it is just a matter of
enabling the correct option there.

Yours, Abel.

2008/5/20 Patrizio Bassi <patrizio.bassi@gmail.com>:
> Abel Bernabeu ha scritto:
>>
>> Looks like you did not enable the partition type "PC BIOS".
>>
>> Type "make menuconfig" and make sure you enabled it on:
>>
>> Partition types / Advanced partition / pc bios (ms dos partition tables)
>>
>> Discard any SCSI issue, indeed I am almost sure you can do a "cp
>> /dev/sda /dev/null" with no problem (showing that your SCSI driver is
>> working properly).
>>
>> Yours, Abel.
>>
>>
>>
>> 2008/5/19 Patrizio Bassi <patrizio.bassi@gmail.com>:
>>
>>>
>>> Hi,
>>>
>>> i have a 8GB usb pen with several problem due to partition table.
>>>
>>> if i create a primary one with fdisk, then format it works ok.
>>> then i umount it, unplug, replug, no more partition detected.
>>>
>>> I formatted it on Windows (same machine) and this some stress test, but
>>> it's
>>> brand new and it works.
>>> The partition and the free space is correctly seen by qtparted and
>>> parted,
>>> but in the dmesg i see:
>>>
>>> Initializing USB Mass Storage driver...
>>> scsi10 : SCSI emulation for USB Mass Storage devices
>>> usb-storage: device found at 2
>>> usb-storage: waiting for device to settle before scanning
>>> usbcore: registered new interface driver usb-storage
>>> USB Mass Storage support registered.
>>> usb-storage: device scan complete
>>> scsi 10:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0
>>> ANSI:
>>> 2
>>> sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
>>> sd 10:0:0:0: [sdc] Write Protect is off
>>> sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
>>> sd 10:0:0:0: [sdc] Assuming drive cache: write through
>>> sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
>>> sd 10:0:0:0: [sdc] Write Protect is off
>>> sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
>>> sd 10:0:0:0: [sdc] Assuming drive cache: write through
>>> sdc: unknown partition table
>>> sd 10:0:0:0: [sdc] Attached SCSI removable disk
>>>
>>> This makes the partition unasable in my linux 2.6.25 (vanilla) system.
>>> Another 1gb usbpen works perfectly.
>>>
>>> Bus 004 Device 001: ID 1d6b:0001
>>> Bus 005 Device 001: ID 1d6b:0001
>>> Bus 002 Device 001: ID 1d6b:0001
>>> Bus 003 Device 001: ID 1d6b:0001
>>> Bus 001 Device 002: ID 1307:0165 Transcend Information, Inc.
>>> Bus 001 Device 001: ID 1d6b:0002
>>>
>>> Anything i can try?
>>> It looks a scsi issue. And it's the first time i see the Mode Sense set
>>> to 0
>>> for any usb storage device.
>>>
>>> Please CC me i'm not subscribed
>>>
>>>
>
> Hi Abel/All,
>
> it doesn't work at all. Actually even other pen i have were formatted in
> windows and they work ok.
>
> And, as said, parted reconize it. now i destroyed and created again with
> parted, but on windows it works, on linux not.
>
> What else to try?
>
> Patrizio
>
