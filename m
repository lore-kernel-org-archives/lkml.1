Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYGGVBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYGGVBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYGGVBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:01:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:26995 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbYGGVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=G2MjJljbTgpd0uKQQfIMLXgVKWncX+obrfFSZkdpoZ4D4BLJOayIYb3z27Fj+405u7
         Mthuclime6eaFw5/dEnmoVBP93NKqObw2GW+O08XNVMoBaAokjS7NvamFeBgx1PEvLer
         X7XTy/FLUqMoGq82Erbx4KRwKIPILt+aE5UT4=
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:08:57 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072308.57529.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008, Stefan Bauer wrote:
> Hi,
> 
> 
> I'm not able to load rt2500pci from 2.6.26-rc9 under Gentoo.
> This card currently works under Debian Etch with 2.6.18 kernel and 
> rt2500-source 1.1.0+cvs20060620-3.
> 
> lspci -vvvv
> Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
> Subsystem: RaLink Unknown device 2560
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- 
> SERR+ FastB2B-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- 
> <MAbort- >SERR- <PERR-
> Latency: 64, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 185
> Region 0: Memory at fba00000 (32-bit, non-prefetchable) [size=8K]
> Capabilities: [40] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> dmesg 2.6.18
> PCI: Enabling device 0000:00:0c.0 (0110 -> 0112)
> ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 185
> rt2500 1.1.0 CVS 2005/07/10 http://rt2x00.serialmonkey.com
> 
> dmesg 2.6.26-rc9
> ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
> phy0: Selected rate control algorithm 'pid'
> phy0: Failed to initialize wep

Check if the arc4 and ecb modules are loaded before loading mac80211 & rt2500pci.

Ivo

