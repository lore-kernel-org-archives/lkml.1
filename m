Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0CHTH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:07:28 -0500
Received: from mail-px0-f181.google.com ([209.85.216.181]:52414 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0CHTHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kbtzwwhG78JjjcCjZAP6vjTM3XtEeEPif9p6rXbjbQTy4kNYG+9wqdIiUWrAF8daLg
         vWmrfPoMKL09z2YJCkr6bHE1rZrsm5gKIVy5ALyPZBzLyNkDg7yNPyBKRfokeTSGwDnP
         6conlNH3ddj6v18VWVVWrxC1ocNJLWdjJeRtE=
MIME-Version: 1.0
Date: Mon, 8 Mar 2010 11:07:21 -0800
Message-ID: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com>
Subject: SIIG DP CyberSerial 4S PCIe Support
From: James Lamanna <jlamanna@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I recently purchased a SIIG DP CyberSerial 4S PCIe card, however the
kernel doesn't seem to recognize it.
There are no messages in dmesg or anything about it.
Currently I'm at 2.6.24, but looking at drivers/serial/8250_pci.c
between 2.6.24 and 2.6.32 there doesn't
seem to be real changes with SIIG cards.
Seems like other SIIG cards are supported, so are we just missing the
PCI IDs for this card?

Here's the lspci -nnvvvvvv output:

01:00.0 Serial controller [0700]: Oxford Semiconductor Ltd Unknown
device [1415:c208] (prog-if 06 [16950])
        Subsystem: Siig Inc Unknown device [131f:2250]
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe8fc000 (32-bit, non-prefetchable) [size=16K]
        Region 1: Memory at fe600000 (32-bit, non-prefetchable) [size=2M]
        Region 2: Memory at fe400000 (32-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [70] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <128ns, L1 <2us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <512ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=16
                Vector table: BAR=1 offset=001b3000
                PBA: BAR=1 offset=001b2000

Please CC me for I am not subscribed.

Thanks.

-- James
