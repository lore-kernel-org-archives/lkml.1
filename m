Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZITJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZITJRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZITJRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 05:17:20 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42427 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbZITJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 05:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B45lhB4CE4EfLrVtgDDiI6gqekVmM8IZn7xjWOq69ym/7B9nfF9keaOfqz51njQYzS
         jImZCVzvmcrOwmTNxwvjFbemkuHxaDK+XR/bJu50MXZNz1HwJqPZtt5+TS19Ny129uRO
         RuYyT5xylIcJ1xQ/NdoHI/YlCly00lEYoDe+c=
MIME-Version: 1.0
In-Reply-To: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
Date: Sun, 20 Sep 2009 10:17:21 +0100
Message-ID: <9b2b86520909200217v71c9529ax3dbbd2341049295e@mail.gmail.com>
Subject: Re: it87 sensors need an ACPI driver (2.6.31)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: wixor <wixorpeek@gmail.com>
Cc: lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC linux-acpi]

On 9/20/09, wixor <wixorpeek@gmail.com> wrote:
> Hello,
> with recent upgrade to 2.6.31 I get
>
> it87: Found IT8712F chip at 0x290, revision 7
> it87: in3 is VCC (+5V)
> it87: in7 is VCCH (+5V Stand-By)
> ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
> [0x295-0x296]
> ACPI: Device needs an ACPI driver
> FATAL: Error inserting it87
> (/lib/modules/2.6.31/kernel/drivers/hwmon/it87.ko): Device or resource
> busy
>
> when trying to load it87 module. On previous kernels the module worked
> fine. I tried grepping for IP__ in acpi dump and found this:
>
> OperationRegion (IP, SystemIO, 0x0295, 0x02)
> Field (IP, ByteAcc, NoLock, Preserve)
> {
>     INDX,   8,
>     DAT0,   8
> }
>
> I have also discovered that dsdt contains description of what is
> connected to each it87 input. Maybe it has also some code to access
> the chip? In /proc/acpi I can read only one temperature, while the
> chip measures three temperatures, fan speeds and voltages. This is
> desktop pc with ASUS A8N1-E maniboard, athlon64 and nforce4 chipset.
>
> Thanks for your time.
