Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757Ab0AZJni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0AZJni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299Ab0AZJne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:43:34 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40458 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab0AZJnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:43:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UcEXpd1Jzh1Y9JkQce4QHuj0MDg/o8R9DMhasouHYfRZpUmcruZLF+CyShw9P4tsvJ
         +9/dF1usLRJFwvr1kKRUMgCEJVbIn4URiUiujWsYFuN8wQ1pKiaVm0rV2MIv4Q4clC2M
         SfI9ahZIDBNXlgU6eaQMsRaCFt1ZTMWqagUCs=
MIME-Version: 1.0
In-Reply-To: <51f3faa71001211636s52a68af3u66f2832d81e7cbc0@mail.gmail.com>
References: <7c8826910912182213o2e0e8af7ic305f150c52e0618@mail.gmail.com>
	 <4B2C80DD.9080005@garzik.org> <4B2D1CF3.4070106@gmail.com>
	 <7c8826910912191437k4e1d93bap12874a6d6e0046d3@mail.gmail.com>
	 <51f3faa70912271352g2784edc8oc899bd6def7b7275@mail.gmail.com>
	 <7c8826911001211548l532a8f39y65b13b3ea4d0f93c@mail.gmail.com>
	 <51f3faa71001211636s52a68af3u66f2832d81e7cbc0@mail.gmail.com>
Date: Tue, 26 Jan 2010 01:43:31 -0800
Message-ID: <7c8826911001260143y51c91ae4q4fb6c7b3b7c072f9@mail.gmail.com>
Subject: Re: 2.6.32 seemed to have broken nVidia MCP7A sata controller
From: Mike Cui <cuicui@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

00:00.0 Host bridge [0600]: nVidia Corporation MCP79 Host Bridge
[10de:0a80] (rev b1)
00:00.1 RAM memory [0500]: nVidia Corporation MCP79 Memory Controller
[10de:0a88] (rev b1)
00:03.0 ISA bridge [0601]: nVidia Corporation MCP79 LPC Bridge
[10de:0aac] (rev b2)
00:03.1 RAM memory [0500]: nVidia Corporation MCP79 Memory Controller
[10de:0aa4] (rev b1)
00:03.2 SMBus [0c05]: nVidia Corporation MCP79 SMBus [10de:0aa2] (rev b1)
00:03.3 RAM memory [0500]: nVidia Corporation MCP79 Memory Controller
[10de:0a89] (rev b1)
00:03.4 RAM memory [0500]: nVidia Corporation Device [10de:0a98] (rev b1)
00:03.5 Co-processor [0b40]: nVidia Corporation MCP79 Co-processor
[10de:0aa3] (rev b1)
00:04.0 USB Controller [0c03]: nVidia Corporation MCP79 OHCI USB 1.1
Controller [10de:0aa5] (rev b1)
00:04.1 USB Controller [0c03]: nVidia Corporation MCP79 EHCI USB 2.0
Controller [10de:0aa6] (rev b1)
00:06.0 USB Controller [0c03]: nVidia Corporation MCP79 OHCI USB 1.1
Controller [10de:0aa7] (rev b1)
00:06.1 USB Controller [0c03]: nVidia Corporation MCP79 EHCI USB 2.0
Controller [10de:0aa9] (rev b1)
00:08.0 Audio device [0403]: nVidia Corporation MCP79 High Definition
Audio [10de:0ac0] (rev b1)
00:09.0 PCI bridge [0604]: nVidia Corporation MCP79 PCI Bridge
[10de:0aab] (rev b1)
00:0a.0 Ethernet controller [0200]: nVidia Corporation MCP79 Ethernet
[10de:0ab0] (rev b1)
00:0b.0 SATA controller [0106]: nVidia Corporation MCP79 AHCI
Controller [10de:0ab8] (rev b1)
00:0c.0 PCI bridge [0604]: nVidia Corporation MCP79 PCI Express Bridge
[10de:0ac4] (rev b1)
00:10.0 PCI bridge [0604]: nVidia Corporation MCP79 PCI Express Bridge
[10de:0aa0] (rev b1)
00:15.0 PCI bridge [0604]: nVidia Corporation MCP79 PCI Express Bridge
[10de:0ac6] (rev b1)
03:00.0 VGA compatible controller [0300]: nVidia Corporation C79
[GeForce 9300 / nForce 730i] [10de:086c] (rev b1)


Thanks!

On Thu, Jan 21, 2010 at 4:36 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Thu, Jan 21, 2010 at 5:48 PM, Mike Cui <cuicui@gmail.com> wrote:
>> I finally got a chance to try this on an x58 motherboard. It works
>> fine. It looks like the nvidia controller is the problem. Or maybe
>> it's just my motherboard.
>
> I'll try and cook up a patch to disable AA on this chipset. Can you
> post the output of "lspci -nn" ?
>
>>
>> Thanks.
>>
>> On Sun, Dec 27, 2009 at 1:52 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>>> On Sat, Dec 19, 2009 at 4:37 PM, Mike Cui <cuicui@gmail.com> wrote:
>>>> Thanks, changing that one line fixed it. I can try to find an intel
>>>> motherboard sometime next week to see if it's the drive or the
>>>> controller.
>>>
>>> Hi Mike, did you ever get a chance to try this test?
>>>
>>>>
>>>> On Sat, Dec 19, 2009 at 10:35 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>>>>> On 12/19/2009 01:29 AM, Jeff Garzik wrote:
>>>>>>
>>>>>> On 12/19/2009 01:13 AM, Mike Cui wrote:
>>>>>>>
>>>>>>> I have an nVidia MCP7A AHCI controller. I upgraded to 2.6.32.2 and my
>>>>>>> system deterministically freezes trying to mount file systems. Once in
>>>>>>> a while it will come back and finish booting after freezing for 1
>>>>>>> minute or 2. dmesg indicates that there were NCQ errors, but 2.6.31
>>>>>>> anb before has always worked flawlessly for me. What changed in
>>>>>>> 2.6.32? I will be more than happy to help track down this issue.
>>>>>>
>>>>>>> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>>>>>>> ata1.00: cmd 61/08:00:4f:ad:03/00:00:00:00:00/40 tag 0 ncq 4096 out
>>>>>>> res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>>>>>> ata1: hard resetting link
>>>>>>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>>>>> ata1.00: configured for UDMA/133
>>>>>>> ata1.00: device reported invalid CHS sector 0
>>>>>>
>>>>>> Looks like things are timing out, and then go downhill from there. This
>>>>>> explanation of timeout gives some hints on possible causes:
>>>>>> http://ata.wiki.kernel.org/index.php/Libata_error_messages#Error_classes
>>>>>>
>>>>>> The ideal would be if you could bisect between 2.6.31 and 2.6.32, to see
>>>>>> if it's a software change that is the cause.
>>>>>>
>>>>>> Looking at drivers/ata/ahci.c history, the only thing that -might- cause
>>>>>> problems is 388539f3ff0cf1de926b03f94e1eec112358f74d ('git show $commit'
>>>>>> for full commit info and diff).
>>>>>
>>>>> I suspect that as well (it's the commit that adds FPDMA auto-activate on DMA
>>>>> setup FIS support). Your drive indicates it's supported but it's possible
>>>>> it's broken on that drive or the controller. If the drive doesn't set the
>>>>> activate bit in the DMA setup FIS properly or the controller doesn't respect
>>>>> it, then FPDMA requests will stall.
>>>>>
>>>>> Mike, can you try and revert that patch, or else just change this line in
>>>>> drivers/ata/ahci.c:
>>>>>
>>>>>                pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
>>>>>
>>>>> to
>>>>>
>>>>>                pi.flags |= ATA_FLAG_NCQ;
>>>>>
>>>>> and rebuild and see if it works better?
>>>>>
>>>>> I tend to suspect the controller is the problem (I've got WD drives that
>>>>> work fine with AA on Intel AHCI, though it could be model-specific). I guess
>>>>> the only way to verify for sure which one it is would be if someone else had
>>>>> that particular drive model on a different AHCI controller and could verify
>>>>> if it worked with 2.6.32+ or not.
>>>>>
>>>>
>>>
>>
>
