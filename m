Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZLWMCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZLWMCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZLWMCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:02:16 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:46381 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZLWMCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X5eaOWiZfFamJqyeCDuS1HQdY3BGWfEWZnlrIENQ8+tRprulEFBLd7q5JFhOVQ9XT1
         200py+QbmMqbTe/zMq4qY+4cOsd0xHQ8xR9yEdybHS+o9J9b72M3OALyq1mzmmEDzrmq
         /PbHpeClWuKAajLeoX0DvIkJ4Gykw7/hD6ieQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
	 <4B30134C.1050609@gmail.com>
	 <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
	 <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com>
	 <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net>
	 <4B31DB17.4050509@kernel.org>
	 <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
Date: Wed, 23 Dec 2009 13:02:12 +0100
Message-ID: <9c30dffe0912230402s5af415c3i83d6f5ba4f8f1841@mail.gmail.com>
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
To: fengxiangjun <fengxiangjun@neusoft.com>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/23 fengxiangjun <fengxiangjun@neusoft.com>:
>
> Hi,
>
> with this patch, the problem still exists.
>
> ata1.01: XXX debounce start, SStatus=4
> ata1.01: XXX debounce done, SStatus=4, DET stable for 520 msecs
> ata1.00: SATA link down (SStatus 0 SControl 301)
> ata1.01: SATA link down (SStatus 0 Scontrol 300)
> ...
> VFS; cannot open root device ...
>
> The kernel just panic, and I can't see what's the messege printing before
> that.
>
> So, I tried 'console=ttyS0 console=tty1'，full dmesg attached。
>
> $ hdparm -I /dev/sda:
>
> /dev/sda:
>
> ATA device, with non-removable media
>        Model Number:       WDC WD800JD-60LSA5
>        Serial Number:      WD-WCAM9T882872
>        Firmware Revision:  10.01E03
> Standards:
>        Supported: 7 6 5 4
>        Likely used: 8
> Configuration:
>        Logical         max     current
>        cylinders       16383   16383
>        heads           16      16
>        sectors/track   63      63
>        --
>        CHS current addressable sectors:   16514064
>        LBA    user addressable sectors:  156301488
>        LBA48  user addressable sectors:  156301488
>        device size with M = 1024*1024:       76319 MBytes
>        device size with M = 1000*1000:       80026 MBytes (80 GB)
>        cache/buffer size  = 8192 KBytes
> Capabilities:
>        LBA, IORDY(can be disabled)
>        Standby timer values: spec'd by Standard, with device specific
> minimum
>        R/W multiple sector transfer: Max = 16  Current = 16
>        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
>             Cycle time: min=120ns recommended=120ns
>        PIO: pio0 pio1 pio2 pio3 pio4
>             Cycle time: no flow control=120ns  IORDY flow control=120ns
> Commands/features:
>        Enabled Supported:
>           *    SMART feature set
>                Security Mode feature set
>           *    Power Management feature set
>           *    Write cache
>           *    Look-ahead
>           *    WRITE_BUFFER command
>           *    READ_BUFFER command
>           *    NOP cmd
>           *    DOWNLOAD_MICROCODE
>           *    48-bit Address feature set
>           *    Device Configuration Overlay feature set
>           *    Mandatory FLUSH_CACHE
>           *    FLUSH_CACHE_EXT
>           *    SMART error logging
>           *    SMART self-test
>           *    General Purpose Logging feature set
>           *    SATA-I signaling speed (1.5Gb/s)
>           *    SATA-II signaling speed (3.0Gb/s)
>           *    Phy event counters
>                Device-initiated interface power management
>           *    Software settings preservation
>           *    SMART Command Transport (SCT) feature set
>           *    SCT Long Sector Access (AC1)
>           *    SCT LBA Segment Access (AC2)
>           *    SCT Error Recovery Control (AC3)
>           *    SCT Features Control (AC4)
>           *    SCT Data Tables (AC5)
>                unknown 206[12] (vendor specific)
> Security:
>        Master password revision code = 65534
>                supported
>        not     enabled
>        not     locked
>                frozen
>        not     expired: security count
>                supported: enhanced erase
>        24min for SECURITY ERASE UNIT. 24min for ENHANCED SECURITY ERASE
> UNIT.
> Checksum: correct
>
> Thanks.
>
> On Wed, 23 Dec 2009, Tejun Heo wrote:
>
>> Hello,
>>
>> On 12/22/2009 11:02 AM, fengxiangjun wrote:
>> > You are right, it's definitely timing related.
>> >
>> > I just tried capturing the failed booting message through a null modem
>> > cable, but the problem goes away! It seems that I can't reproduce it
>> > with serial console attached.
>>
>> Hmmm... this is the second report of probing failure with SIDPR based
>> hardreset.  Can you please apply the attached patch and see whether
>> the problem is reproducible?  And if so, please attach full boot log.
>> Can you please also attach hdparm -I output of the occassionally
>> failing drive.
>>
>> Thanks.
>>
>> --
>> tejun
>>
> ---------------------------------------------------------------------------------------------------
> Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s)
> is intended only for the use of the intended recipient and may be confidential and/or privileged of
> Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is
> not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying
> is strictly prohibited, and may be unlawful.If you have received this communication in error,please
> immediately notify the sender by return e-mail, and delete the original message and all copies from
> your system. Thank you.
> ---------------------------------------------------------------------------------------------------
>

Hey,

Could it be an idea to do a bisect for the patch that makes it break? :)

/Bjarke
