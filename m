Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZJGAHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZJGAHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbZJGAHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:07:02 -0400
Received: from trinity.develer.com ([83.149.158.210]:43843 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250AbZJGAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:07:00 -0400
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
From: Bernie Innocenti <bernie@codewiz.org>
To: Mark Lord <liml@rtr.ca>
Cc: Harri Olin <harri.olin@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
In-Reply-To: <4ACBA33C.7090606@rtr.ca>
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>
	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>
	 <4ACBA33C.7090606@rtr.ca>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Tue, 06 Oct 2009 20:06:18 -0400
Message-Id: <1254873978.1471.463.camel@giskard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 06-10-2009 a las 16:06 -0400, Mark Lord escribió:
> If you could also send me the output of "lspci -vv" for the cards
> then I can also have a quick look at chipset errata for possibilities.

See below.

Looking at the Status field, is it correct to say that the cards are
definitely running at 133MHz?  Is there a way to force them to a
different speed from Linux or from the BIOS?


> The early revs of these chips did have a number of errata specific to PCI-X.

I checked the revision (09) against the sata_mv source and I couldn't
spot anything relevant to us.


03:04.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
	Subsystem: Marvell Technology Group Ltd. Device 11ab
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at feb00000 (64-bit, non-prefetchable) [size=1M]
	Region 2: I/O ports at e800 [size=256]
	Region 3: [virtual] Memory at fdc00000 (32-bit, non-prefetchable) [size=4M]
	[virtual] Expansion ROM at fd800000 [disabled] [size=4M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=4
		Status: Dev=03:04.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=4 DMCRS=8 RSCEM- 266MHz- 533MHz-
	Kernel driver in use: sata_mv
	Kernel modules: sata_mv

03:06.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
	Subsystem: Marvell Technology Group Ltd. Device 11ab
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=1M]
	Region 2: I/O ports at e400 [size=256]
	Region 3: [virtual] Memory at fd400000 (32-bit, non-prefetchable) [size=4M]
	[virtual] Expansion ROM at fd000000 [disabled] [size=4M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=4
		Status: Dev=03:06.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512 DMOST=4 DMCRS=8 RSCEM- 266MHz- 533MHz-
	Kernel driver in use: sata_mv
	Kernel modules: sata_mv


-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

