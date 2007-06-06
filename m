Return-Path: <linux-kernel-owner+w=401wt.eu-S966140AbXFFXsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966140AbXFFXsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXFFXsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:48:30 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:37695 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbXFFXsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:48:30 -0400
Date: Wed, 06 Jun 2007 17:47:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Another missing RAM on x86_64
In-reply-to: <4667362A.8040200@gmail.com>
To: Reinaldo de Carvalho <reinaldow@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <466747AC.1080606@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tF0YmfAYyv6X2INP3hwTgQ2Z2Pw@ifi.uio.no>
 <4664DB42.2050401@shaw.ca> <4667362A.8040200@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reinaldo de Carvalho wrote:
> This laptop have a nVidia 10de:0244 with 256Mb of RAM. No shared memory.
> 
> 
> Reinaldo de Carvalho
> 
> 
> 
> 00:05.0 VGA compatible controller: nVidia Corporation C51 PCI Express 
> Bridge (rev a2) (prog-if 00 [VGA])
>         Subsystem: Hewlett-Packard Company Unknown device 30b5
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 21
>         Region 0: Memory at c2000000 (32-bit, non-prefetchable) [size=16M]
>         Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
>         Region 3: Memory at c1000000 (64-bit, non-prefetchable) [size=16M]
>         [virtual] Expansion ROM at 50000000 [disabled] [size=128K]
>         Capabilities: [48] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
> Queue=0/0 Enable-
>                 Address: 0000000000000000  Data: 0000

It's a bit mysterious, then, where the extra 40-some MB of RAM has gone. 
However, there's not much the kernel can do about it, as the BIOS is not 
telling us about that memory..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

