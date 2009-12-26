Return-Path: <linux-kernel-owner+w=401wt.eu-S1751411AbZLZFrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbZLZFrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 00:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZLZFrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 00:47:36 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:59577 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZLZFrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 00:47:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CPdp8hJIoiuvCIO7JIznKa2s2U3zdq+sjPedzQ6xXwxxLQ4XEhgsCzbNzkIZO9VwtR
         zA7+TxUgoO3mjoGzDIV7GA/uxsxL+tZzpgXnZS2AJmxhzD62oykf8Q+6ayzlE2sQHAp4
         QTTXVk2UmLmBG4kQ7wOm5m5JGGHcHSJXGxwzw=
MIME-Version: 1.0
In-Reply-To: <200912251744.43987.tvrtko@ursulin.net>
References: <200912251744.43987.tvrtko@ursulin.net>
Date: Fri, 25 Dec 2009 21:47:34 -0800
X-Google-Sender-Auth: f08f5a7678a1bb16
Message-ID: <86802c440912252147t5891e00bka386ab44da5afbf@mail.gmail.com>
Subject: Re: 2.6.33-rc1: 6 Processors exceeds NR_CPUS limit of 4
From: Yinghai Lu <yinghai@kernel.org>
To: Tvrtko Ursulin <tvrtko@ursulin.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 9:44 AM, Tvrtko Ursulin <tvrtko@ursulin.net> wrote:
>
> Hi,
>
> Just noticed this message in dmesg. What is this about? Machine is supposed to
> have a dual core CPU "unlocked" to four cores and it works like that without
> any visible problems so far:

[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] 6 Processors exceeds NR_CPUS limit of 4

MADT has two disable entries...

YH
