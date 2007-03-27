Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbXC0Wzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbXC0Wzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933258AbXC0Wzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:55:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64226 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288AbXC0Wzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=KcJ4JvVqJ+1SsVkf3MEwph0wnqjqLyGgwdnvz95d4LugdWamkj74g3UL2jyq/L0Wk0jcgW+EnElnVMs1B+uoNqi3AZ+6TyfCTGMe3XOqm7PA2a+TR6hjMzagHX4JuF3UvFsPGgnmJtBrtP88gAojTYNU4mKR6P0Oj5PRrvBtY7c=
Message-ID: <4609A0DF.6030302@googlemail.com>
Date: Wed, 28 Mar 2007 00:55:27 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc5
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <6bffcb0e0703271134i328af6feu47a780d143ebe046@mail.gmail.com> <20070327222921.GA6752@elf.ucw.cz>
In-Reply-To: <20070327222921.GA6752@elf.ucw.cz>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek napisał(a):
> Hi!
>>> There's various fixes here, ranging from some architecture updates (ia64,
>>> ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
>>>
>> Suspend to disk doesn't work for me with this patch. It hangs after
>> PM: Preparing devices for restore.
>> Suspending console(s)
>> during resuming.
>>
>> a504e64ab42bcc27074ea37405d06833ed6e0820 is first bad commit
>> commit a504e64ab42bcc27074ea37405d06833ed6e0820
>> Author: Stephen Hemminger <shemminger@linux-foundation.org>
>> Date:   Fri Feb 2 08:22:53 2007 -0800
>>
>>    skge: WOL support
>>
>>    Add WOL support for Yukon chipsets in skge device.
>>
>>    Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
>>    Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>
>> :040000 040000 d3d4335e6cba330b7880b4787fbe48733e69f8fc
>> 5845b004228d811de912a55da6a7843b72f23f81 M      drivers
>>
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/git-config2
> 
> Do you use skge as your network device?

Yes, I have a Marvell based onboard NIC.

02:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)
        Subsystem: ASUSTeK Computer Inc. A7V600/P4P800/K8V motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (5750ns min, 7750ns max), Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f7ffc000 (32-bit, non-prefetchable) [size=16K]
        Region 1: I/O ports at e800 [size=256]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data


> 									Pavel

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
