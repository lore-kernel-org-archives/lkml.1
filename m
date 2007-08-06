Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbXHFLhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbXHFLhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbXHFLhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:37:21 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:57594 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbXHFLhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:37:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=lebsBJ7GFpsUKtzTc5xc0a01UDNx4VLOZSa/npwf/4GAALcLcFTaESWW7hXPW4/iFLbw5fUOSF4fKLdsiiXsQvmTJ2qW5YQ/i8a5jSzVBHXQnWkcHD7OkbRvPK4z6qdH;
Message-ID: <1977.simon.1186400234@5ec7c279.invalid>
In-Reply-To: <20070806104456.GA1901@elf.ucw.cz>
References: <46B58FB4.6050207@simon.arlott.org.uk> <46B68F08.60106@intel.com>
    <20070806104456.GA1901@elf.ucw.cz>
Date: Mon, 6 Aug 2007 12:37:14 +0100
Subject: Re: e1000 doesn't resume properly from standby (2.6.23-rc2)
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       linux-pm@lists.linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 6, 2007 11:44, Pavel Machek wrote:
> Hi!
>
>> >00:0a.0 Ethernet controller: Intel Corp. 82546EB Gigabit Ethernet
>> >Controller (Copper) (rev 01)
>> >        Subsystem: Intel Corp.: Unknown device 1012
>> >        Flags: bus master, 66Mhz, medium devsel, latency 32, IRQ 5
>> >        Memory at e3020000 (64-bit, non-prefetchable) [size=128K]
>> >        I/O ports at b000 [size=64]
>> >        Capabilities: [dc] Power Management version 2
>> >        Capabilities: [e4] PCI-X non-bridge device.
>> >        Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0
>> >        Enable-
>> >
>> >00:0a.1 Ethernet controller: Intel Corp. 82546EB Gigabit Ethernet
>> >Controller (Copper) (rev 01)
>> >        Subsystem: Intel Corp.: Unknown device 1012
>> >        Flags: bus master, 66Mhz, medium devsel, latency 32, IRQ 12
>> >        Memory at e3000000 (64-bit, non-prefetchable) [size=128K]
>> >        I/O ports at b400 [size=64]
>> >        Capabilities: [dc] Power Management version 2
>> >        Capabilities: [e4] PCI-X non-bridge device.
>> >        Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0
>> >        Enable-
>> >
>> >[  950.132046] Stopping tasks ... done.
>> >[  950.459794] Suspending console(s)
>> >[  951.776277] pnp: Device 00:0c disabled.
>> >[  951.776673] pnp: Device 00:0a disabled.
>> >[  951.776984] pnp: Device 00:09 disabled.
>> >[  951.777306] pnp: Device 00:08 disabled.
>> >[  951.777786] ACPI: PCI interrupt for device 0000:00:11.5 disabled
>> >[  951.995359] ACPI: PCI interrupt for device 0000:00:11.3 disabled
>> >[  952.006094] ACPI: PCI interrupt for device 0000:00:11.2 disabled
>> >[  952.022243] ACPI handle has no context!
>> >[  952.033068] ACPI: PCI interrupt for device 0000:00:0c.2 disabled
>> >[  952.044086] ACPI: PCI interrupt for device 0000:00:0c.1 disabled
>> >[  952.055083] ACPI: PCI interrupt for device 0000:00:0c.0 disabled
>> >[  952.282211] ACPI: PCI interrupt for device 0000:00:0a.1 disabled
>> >[  952.282221] ACPI handle has no context!
>> >[  952.537474] ACPI: PCI interrupt for device 0000:00:0a.0 disabled
>> >[  952.537495] ACPI handle has no context!
>> >
>> >[  956.857085] Back to C!
>
> Are you sure that is standby? Looks like suspend-to-RAM to me.

It's S1 (power-on suspend/standby), my BIOS/motherboard doesn't support S2 or S3.

-- 
Simon Arlott
