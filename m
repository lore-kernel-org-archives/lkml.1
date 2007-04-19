Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXDSWFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXDSWFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXDSWFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:05:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:49219 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbXDSWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kPL//WDS3h0k7YBS8jfyeUCVEBV82BydTkyLPfEkA2Zk8fxAltd4GZHNsAPiZuD6LDqyni0R6PlfkiJ2r7bCws8gdEbehltHLfp726fR+duzzCCip5ovQiPj7RxinxfCEIibX833Z46V5XxsXzOATB3g1okNDYYxzZtzejZaAL4=
Message-ID: <4807377b0704191505n6241fb5ej90beac74e702bdc6@mail.gmail.com>
Date: Thu, 19 Apr 2007 15:05:02 -0700
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "David Ford" <firefighterblu3@gmail.com>
Subject: Re: [it really is text/plain :P] dual port onboard 82546EB checksum errors
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <523e55a00704191406s4442e32aw5f82bbe21affe2b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <523e55a00704191406s4442e32aw5f82bbe21affe2b8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

please copy netdev, or better yet e1000-devel@lists.sourceforge.net in
the future for e1000 issues like this.  Feel free to move the
conversation there, if you would like.

On 4/19/07, David Ford <firefighterblu3@gmail.com> wrote:
> I have a rackmount server that has a dual port onboard 82546EB card.
>
> I've googled and seen this card apparently active with other users but
> I seem to only get checksum errors.
>
> [    0.194129] Intel(R) PRO/1000 Network Driver - version 7.3.15-k2-NAPI
> [    0.194234] Copyright (c) 1999-2006 Intel Corporation.
>
> [    0.194405] ACPI: PCI Interrupt 0000:04:09.0[A] -> GSI 51 (level,
> low) -> IRQ 16
> [    0.458732] e1000: 0000:04:09.0: e1000_probe: (PCI:66MHz:64-bit)
> 00:04:23:cd:93:d2
> [    0.489766] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
>
> [    0.489889] ACPI: PCI Interrupt 0000:03:07.0[A] -> GSI 30 (level,
> low) -> IRQ 17
> [    0.721071] e1000: 0000:03:07.0: e1000_probe: The EEPROM Checksum
> Is Not Valid
> [    0.742509] ACPI: PCI interrupt for device 0000:03:07.0 disabled
> [    0.742614] e1000: probe of 0000:03:07.0 failed with error -5
>
> [    0.742731] ACPI: PCI Interrupt 0000:03:07.1[B] -> GSI 31 (level,
> low) -> IRQ 18
> [    0.973865] e1000: 0000:03:07.1: e1000_probe: The EEPROM Checksum
> Is Not Valid
> [    0.995304] ACPI: PCI interrupt for device 0000:03:07.1 disabled
> [    0.995405] e1000: probe of 0000:03:07.1 failed with error -5
>
>
> 03:07.0 Ethernet controller: Intel Corporation 82546EB Gigabit
> Ethernet Controller (Copper) (rev 01)
> 03:07.1 Ethernet controller: Intel Corporation 82546EB Gigabit
> Ethernet Controller (Copper) (rev 01)
> 04: 09.0 Ethernet controller: Intel Corporation 82545GM Gigabit
> Ethernet Controller (rev 04)
>
>
> 03:07.0 Ethernet controller: Intel Corporation 82546EB Gigabit
> Ethernet Controller (Copper) (rev 01)
>         Subsystem: Intel Corporation Unknown device 341a
>         Flags: 66MHz, medium devsel, IRQ 17
>         Memory at fe5c0000 (64-bit, non-prefetchable) [size=128K]
>         I/O ports at 2040 [size=64]
>         Capabilities: [dc] Power Management version 2
>         Capabilities: [e4] PCI-X non-bridge device
>         Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>
> 03:07.1 Ethernet controller: Intel Corporation 82546EB Gigabit
> Ethernet Controller (Copper) (rev 01)
>         Subsystem: Intel Corporation Unknown device 341a
>         Flags: 66MHz, medium devsel, IRQ 18
>         Memory at fe5e0000 (64-bit, non-prefetchable) [size=128K]
>         I/O ports at 2000 [size=64]
>         Capabilities: [dc] Power Management version 2
>         Capabilities: [e4] PCI-X non-bridge device
>         Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>
> 04:09.0 Ethernet controller: Intel Corporation 82545GM Gigabit
> Ethernet Controller (rev 04)
>         Subsystem: Intel Corporation PRO/1000 MT Server Adapter
>         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
>         Memory at fe8c0000 (64-bit, non-prefetchable) [size=128K]
>         Memory at fe880000 (64-bit, non-prefetchable) [size=256K]
>         I/O ports at 3000 [size=64]
>         Expansion ROM at fe840000 [disabled] [size=256K]
>         Capabilities: [dc] Power Management version 2
>         Capabilities: [e4] PCI-X non-bridge device
>
>
> The 82545GM card comes up fine but the 46EB card does not.
>
> This is 2.6.20-gentoo-r6
>
> I'll be happy to fulfill information request if needed.  Any
> suggestions that'd help me get the 46EB working?

We haven't heard of any reports about this, can you get us some more
information about the platform this is in?
lspci -vv
dmesg (full version)
you can comment out the eeprom check and mac address check, rebuild
the driver and load it, then run
ethtool -e ethX
on the ports that are failing, without bringing the interface 'up'

you may have a hardware failure, or you could be having bus issues.
The eeprom read is the first point that we try to read a register from
the adapter so if register reads are failing this is the symptom you
will see.
