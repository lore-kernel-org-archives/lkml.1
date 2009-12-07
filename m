Return-Path: <linux-kernel-owner+w=401wt.eu-S965153AbZLGWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbZLGWDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965110AbZLGWDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:03:24 -0500
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:50153 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965111AbZLGWDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:03:24 -0500
Message-ID: <4B1D7BB1.5040709@gmail.com>
Date: Mon, 07 Dec 2009 23:03:29 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091205 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ivo van Doorn <IvDoorn@gmail.com>, linux-wireless@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
References: <Pine.LNX.4.44L0.0912061705050.9883-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912061705050.9883-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2009 22:03:29.0708 (UTC) FILETIME=[1BFA16C0:01CA7789]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/09 23:12, Alan Stern wrote:
> Sorry for the late notice; I haven't tried running new kernels on this 
> computer in a long time.
> 
> When I use 2.6.32 (or indeed 2.6.32-rc1), it works fine up until the 
> point where the wireless card is ifconfig'ed.  Then not long afterward 
> (a few seconds to a minute) the system hangs.
> 
> # lspci -vv -s d.0
> 00:0d.0 Network controller: RaLink RT2561/RT61 802.11g PCI
>         Subsystem: Linksys WMP54G ver 4.1
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at cfff0000 (32-bit, non-prefetchable) [size=32K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: rt61pci
>         Kernel modules: rt61pci
> 
> While the system is hung, Alt-SysRq-keys still work but nothing else
> shows up when I type (using a VT console, not X).  However I don't know
> what debugging to do or what to look for.
> 
> Under 2.6.31 everything works okay.
> 

Hmmm, that's odd. I haven't seen any other reports on this (on full system hangs that is).

It would be very hard to figure out what is going wrong without any form of logging of
an oops or something. Is there any way you can find out if any oops information is present?

What does Alt-SysRq-l tell us, what are the CPU's doing when the system is hung?

---
Gertjan.
