Return-Path: <linux-kernel-owner+w=401wt.eu-S1030636AbXBMEUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030636AbXBMEUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 23:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030648AbXBMEUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 23:20:51 -0500
Received: from [219.153.9.10] ([219.153.9.10]:16990 "EHLO mail.iblink.com.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030638AbXBMEUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 23:20:50 -0500
Message-ID: <45D13C93.6010400@idccenter.cn>
Date: Tue, 13 Feb 2007 12:20:35 +0800
From: "Tony.Ho" <linux@idccenter.cn>
User-Agent: Thunderbird 2.0b2 (Windows/20070116)
MIME-Version: 1.0
To: albcamus <albcamus@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Why can't I build a running Kernel?
References: <200702081817.l18IHlbE027996@deneb.dwf.com>	 <45CB79CF.9010702@gmail.com> <df9815e70702120036k3e2a2a50re0dc2605c31766f3@mail.gmail.com> <45D129DA.1040306@idccenter.cn>
In-Reply-To: <45D129DA.1040306@idccenter.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In addition....
This problem is not appear on another PC host with the same 
hardware(CPU,HD) except MEM is 2G.
OS is origin RHEL4 without updates.


Tony.Ho wrote:
> I have the same problem with 2.6.20.
> My host is dell PE850: pemtiumD 2.8G X1,  MEM  1G X4,  SATA  73G X1.
>
> albcamus wrote:
>> 2007/2/9, Jiri Slaby <jirislaby@gmail.com>:
>>> Reg Clemens napsal(a):
>>> > Why can't I build a running Kernel?
>>> > I have in the past, but since some time in the 2.6.19 series,
>>> > I have got the following series of errors.
>>> > Same thing now with 2.6.20.
>>> >
>>> > I build with:
>>> >
>>> >     make xconfig
>>> >
>>> > changing only the Processor type to Pentium4,
>>> > then I
>>> >
>>> >     make bzImage
>>> >     make modules
>>> >     make modules_install
>>> >     make install
>>> >
>>> > Fine everything builds, no errors.
>>> > I then try booting, and I get 4 or 5 lines and then
>>> >
>>> >     Unable to access resume device (/dev/sda5)
>>> >     mount: could not find filesystem '/dev/root'
>>> >     < 4 more lines with setuproot and switchroot >
>>> >
>>> > and then
>>> >
>>> >     Kernel panic - not syncing: Attempting to kill init!
>>> >
>>> > Sigh.
>>> > What has changed, what do I need to do to get this thing to boot?
>>>
>> I have the same problem with 2.6.19 and later. The previous kernel with
>> same .config works, but it's not true for 2.6.19 and 2.6.30.
>>
>>
>>
>>
>>> Re-enable sata/scsi/usb/whatever is your root behind stuff back 
>>> again? What
>>> does
>>> your .config look like?
>>>
>>> regards,
>>
>> I selected everything about ATA to <*> or <M>, and made initrd for the
>> newly-built kernel, still unable to boot.
>>
>> The .config was attached, I have kdb-4.4 patched.
>>
>> Thanks and Regards,
>> albcamus <albcamus@gmail.com>
>
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

