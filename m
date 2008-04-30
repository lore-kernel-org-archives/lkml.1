Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbYD3NnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbYD3NnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbYD3Nmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:42:52 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:58874 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYD3Nmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:42:51 -0400
Date: Wed, 30 Apr 2008 15:42:48 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Cc: eric.moore@lsi.com
Subject: Re: HP server and atto driver from hell
Message-ID: <20080430134248.GD15819@charite.de>
Mail-Followup-To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>,
	eric.moore@lsi.com
References: <20080429201727.GV8066@charite.de> <Pine.LNX.4.64.0804291425260.23575@filesrv1.baby-dragons.com> <20080430131607.GX15819@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430131607.GX15819@charite.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:

> Well, something seems to work:
> 
> [    3.571216] Fusion MPT base driver 3.04.06
> [    3.571274] Copyright (c) 1999-2007 LSI Corporation
> [    3.577292] Fusion MPT SPI Host driver 3.04.06
> [    3.577389] ACPI: PCI Interrupt 0000:14:04.0[A] -> GSI 17 (level, low) -> IRQ 17
> [    3.577512] mptbase: ioc0: Initiating bringup
> [    3.836271] ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
> [    3.992277] scsi0 : ioc0: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=17
> [    3.992277] ACPI: PCI Interrupt 0000:14:04.1[B] -> GSI 18 (level, low) -> IRQ 18
> [    3.992277] mptbase: ioc1: Initiating bringup
> [    4.244297] ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
> [    4.408304] scsi1 : ioc1: LSI53C1030 C0, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=18
> 
> # lspci -v -s 14:04.0
> 14:04.0 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
>         Subsystem: Atto Technology Unknown device 802f
>         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
>         I/O ports at 5000 [size=256]
>         Memory at fdfc0000 (64-bit, non-prefetchable) [size=256K]
>         Memory at fdf80000 (64-bit, non-prefetchable) [size=256K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
> 	Capabilities: [68] PCI-X non-bridge device
> 	Kernel driver in use: mptspi
> 	Kernel modules: mptspi

According to http://lwn.net/Articles/254394, Eric Moore added the ATTO
4LD support:

mpt fusion: Add support for ATTO 4LD: Rebranded LSI

And the HP U320e SCSI Bus Adapter seesm to be a rebranded ATTO 4LD.
But I cannot be sure.

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to snickebo@charite.de
