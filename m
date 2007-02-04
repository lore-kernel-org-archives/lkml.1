Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbXBDVGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbXBDVGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXBDVGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:06:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:39610 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXBDVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:06:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Po0ey32YX6vl20RZGS7YZcWHmOSJRT9ljs1Sn5OJCb+8ZmicXrcnkPuU/E2ef+xKRcABWN6Ge16IqIwDff6gNpVf5/3y21ap1xjIoVohx6rW42wn+DLN6Q641nctzQEZseFUPUCeB/KTYhynUMWwgFo5xdh30j2RLBr6jqeihyE=
Message-ID: <1a297b360702041306x73b4be24j32922aed2a95f7d4@mail.gmail.com>
Date: Mon, 5 Feb 2007 01:06:09 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: PCI BIST is running
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have 3 similar PCI cards all 32 bit in 32 bit PCI slots on a x86 (32 bit) CPU

On booting up 2.6.17.7, i get this message,

PCI: Unable to handle 64-bit address space for device 02:0a.0

i get one more message stating that an address could not be mapped for
the same slot.

running lspci, i get thus ..

All the 3 PCI cards are the same except that the first one is Rev 08
card and the others Rev 01


can somebody point me as to what's happening on the first card ? I
understand that some Built In Self Test is Running, but syill don't
understand why it doesn't terminate or so


Thanks,
Manu

02:0a.0 4e35: 1800:4e35 (rev 08) (prog-if 18)
	Subsystem: 002c:c200
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR+ <PERR+
	Latency: 0, Cache Line Size 0c
	BIST is running
	Region 0: Memory at f7ee0000 (32-bit, non-prefetchable) [disabled] [size=4K]
	Region 2: Memory at e9b00000 (32-bit, prefetchable) [disabled] [size=4K]
	Region 3: Memory at <unassigned> (32-bit, prefetchable) [disabled]
	Region 4: Memory at <ignored> (32-bit, non-prefetchable) [disabled]
	Region 5: Memory at <invalid-64bit-slot> (64-bit, non-prefetchable) [disabled]
	Expansion ROM at e9b01000 [disabled] [size=4K]

02:0c.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1822:0014
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at e9bfe000 (32-bit, prefetchable) [size=4K]

02:0d.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1822:0024
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e9bfd000 (32-bit, prefetchable) [size=4K]
