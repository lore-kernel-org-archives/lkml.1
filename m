Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZEPJmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZEPJmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbZEPJmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:42:06 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:50217 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599AbZEPJmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aqwW2hGnMYjW/c49SQkUn7VA6sPLgHpA6SKrgFLlOmGkKxUtL/T2zLCZaG6Zo3IBMv
         XmXtva0GxF+H8XUzJYLQpp6cTbEiAS70kcfOFNKmtukLKe4F69fOOGu+ZTlXXGJRNPOU
         ox99st7d83KlhGIAtEDP/no4t1XcL1SI5LLkM=
MIME-Version: 1.0
In-Reply-To: <200905152350.27270.rjw@sisk.pl>
References: <38b2ab8a0905030922x722a45f3gf0790b5b90b0f2b3@mail.gmail.com>
	 <200905031828.14468.florian@openwrt.org>
	 <38b2ab8a0905031012m5d50b68es22e3c80cfa72fd60@mail.gmail.com>
	 <200905152350.27270.rjw@sisk.pl>
Date: Sat, 16 May 2009 11:42:01 +0200
Message-ID: <8db1092f0905160242v7264a642m9978dd761c160e0c@mail.gmail.com>
Subject: Re: v2.6.30-rc4: b44: eth0: BUG! Timeout waiting for bit 00000002 of 
	register 42c to clear.
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Francis Moreau <francis.moro@gmail.com>,
       Florian Fainelli <florian@openwrt.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/15 Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday 03 May 2009, Francis Moreau wrote:
>> Hello Florian,
>>
>> On Sun, May 3, 2009 at 6:28 PM, Florian Fainelli <florian@openwrt.org> wrote:
>> >> I got this since I updated my kernel from 2.6.29 to 2.6.30-rc4.
>> >>
>> >> Let me know if you need more information.
>> >
>> > Is this seen on a Broadcom 47xx/53xx platform or on a computer with a PCI b44
>> > card ?
>> >
>>
>> $ lspci -vv
>>
>> 06:01.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
>>         Subsystem: Acer Incorporated [ALI] Device 0090
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64
>>         Interrupt: pin A routed to IRQ 21
>>         Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=8K]
>>         Capabilities: <access denied>
>>         Kernel driver in use: b44
>>
>>
>> Let me know if you need more details.
>
> Can anyone please tell me what the status of this report is?
>

Hmm. I also have this message in dmesg when always back to Linux from
Windows XP, but only in this case and as long as I remember.

02:0e.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
