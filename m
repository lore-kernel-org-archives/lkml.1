Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab0CHVNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:13:16 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44861 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab0CHVNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:13:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ha4LoPVO7ny4d2Tir9l4WPvH6N4/3znimo1bvswOiA4fhVlaHusN0zrB5xNAfsNryT
         688YsFEMXxIIECwHzyuG9y5GeM9wwOImWxqkeXTEPMwlOI2DXvmVKLPQZ/OTxz6fNEnS
         dQE15dor0ekN/2LLTk9mLK3DRnAQ5KcYc/Iqc=
MIME-Version: 1.0
In-Reply-To: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com>
References: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com>
Date: Mon, 8 Mar 2010 13:13:10 -0800
Message-ID: <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com>
Subject: Re: SIIG DP CyberSerial 4S PCIe Support
From: James Lamanna <jlamanna@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 11:07 AM, James Lamanna <jlamanna@gmail.com> wrote:
> Hi,
> I recently purchased a SIIG DP CyberSerial 4S PCIe card, however the
> kernel doesn't seem to recognize it.
> There are no messages in dmesg or anything about it.
> Currently I'm at 2.6.24, but looking at drivers/serial/8250_pci.c
> between 2.6.24 and 2.6.32 there doesn't
> seem to be real changes with SIIG cards.
> Seems like other SIIG cards are supported, so are we just missing the
> PCI IDs for this card?
>
> Here's the lspci -nnvvvvvv output:
>
> 01:00.0 Serial controller [0700]: Oxford Semiconductor Ltd Unknown
> device [1415:c208] (prog-if 06 [16950])
>        Subsystem: Siig Inc Unknown device [131f:2250]
>        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at fe8fc000 (32-bit, non-prefetchable) [size=16K]
>        Region 1: Memory at fe600000 (32-bit, non-prefetchable) [size=2M]
>        Region 2: Memory at fe400000 (32-bit, non-prefetchable) [size=2M]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA
> PME(D0-,D1+,D2+,D3hot+,D3cold+)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [70] Express Endpoint IRQ 0
>                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>                Device: Latency L0s <128ns, L1 <2us
>                Device: AtnBtn- AtnInd- PwrInd-
>                Device: Errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
>                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
>                Link: Latency L0s <512ns, L1 <64us
>                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>                Link: Speed 2.5Gb/s, Width x1
>        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=16
>                Vector table: BAR=1 offset=001b3000
>                PBA: BAR=1 offset=001b2000

After some more digging I found these messages in dmesg which doesn't
exactly sound good:

[   52.104180] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   52.104189] ACPI: PCI interrupt for device 0000:01:00.0 disabled

01:00.0 is the device ID of the SIIG card.
Any reason ACPI would disable interrupts for this card?

Thanks.

-- James

>
> Please CC me for I am not subscribed.
>
> Thanks.
>
> -- James
>
