Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZLZL5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZLZL5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 06:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZLZL5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 06:57:53 -0500
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:31586
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbZLZL5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 06:57:53 -0500
X-Trace: 280300443/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.4 (Linux/2.6.33-rc2; KDE/4.3.4; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8EAJ6INUtTQwwf/2dsb2JhbACBStFLhDMEgWU
X-IronPort-AV: E=Sophos;i="4.47,455,1257120000"; 
   d="scan'208";a="280300443"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.33-rc1: 6 Processors exceeds NR_CPUS limit of 4
Date: Sat, 26 Dec 2009 11:57:44 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc2; KDE/4.3.4; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200912251744.43987.tvrtko@ursulin.net> <86802c440912252147t5891e00bka386ab44da5afbf@mail.gmail.com>
In-Reply-To: <86802c440912252147t5891e00bka386ab44da5afbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912261157.44469.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 Dec 2009 05:47:34 Yinghai Lu wrote:
> On Fri, Dec 25, 2009 at 9:44 AM, Tvrtko Ursulin <tvrtko@ursulin.net> wrote:
> > Hi,
> >
> > Just noticed this message in dmesg. What is this about? Machine is
> > supposed to have a dual core CPU "unlocked" to four cores and it works
> > like that without any visible problems so far:
> 
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI
>  0-23 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl
>  dfl) [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low
>  level) [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
> [    0.000000] 6 Processors exceeds NR_CPUS limit of 4
> 
> MADT has two disable entries...

I see. Does this mean ACPI is designed to support up to six CPUs, lets say 
some future models? Anyway I recompiled the kernel with 6 MAX_CPUS just to 
shut up this warning.

Tvrtko
