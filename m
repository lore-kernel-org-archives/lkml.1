Return-Path: <linux-kernel-owner+w=401wt.eu-S936772AbXFFWeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936772AbXFFWeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936495AbXFFWcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:32:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:44584 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936491AbXFFWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=epiIvg+djOBSKKupNcp9VAxr+rWCLmp1v+5ML7fJpcDER+5GnXLaYCeUyfDgv9nrrvxTTq6kqa83SjCTV39Hau2QOIii+DA4o95ghrysG62fSz1KnFshrXAIGYC1He34lqagH9GepZGpJTvff8nST9tVErd0OMcAhhaUv+F61pE=
Message-ID: <4667362A.8040200@gmail.com>
Date: Wed, 06 Jun 2007 19:33:14 -0300
From: Reinaldo de Carvalho <reinaldow@gmail.com>
User-Agent: IceDove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Another missing RAM on x86_64
References: <fa.tF0YmfAYyv6X2INP3hwTgQ2Z2Pw@ifi.uio.no> <4664DB42.2050401@shaw.ca>
In-Reply-To: <4664DB42.2050401@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This laptop have a nVidia 10de:0244 with 256Mb of RAM. No shared memory.


Reinaldo de Carvalho



00:05.0 VGA compatible controller: nVidia Corporation C51 PCI Express 
Bridge (rev a2) (prog-if 00 [VGA])
         Subsystem: Hewlett-Packard Company Unknown device 30b5
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 21
         Region 0: Memory at c2000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
         Region 3: Memory at c1000000 (64-bit, non-prefetchable) [size=16M]
         [virtual] Expansion ROM at 50000000 [disabled] [size=128K]
         Capabilities: [48] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000


Robert Hancock escreveu:
> Reinaldo de Carvalho wrote:
>> 1024MB dont detected on Notebook HP 2125 with kernel 2.6.21.3
>>
> 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
>  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003bf10000 (usable)
>  BIOS-e820: 000000003bf10000 - 000000003bf19000 (ACPI data)
>  BIOS-e820: 000000003bf19000 - 000000003bf80000 (ACPI NVS)
>  BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> 
> This shows that memory from 0 to 631K and 1MB to 959MB are usable. Does 
> this laptop have integrated graphics that could be using the rest?
> 
