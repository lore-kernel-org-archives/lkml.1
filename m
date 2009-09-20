Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZITMUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZITMUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 08:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZITMUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 08:20:32 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:43379 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZITMUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 08:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HGHkFNASmyV6d4vNqTgwXb4S0hhB3XvWOdyZCb1C1sups2RQsBG23Yl7O5qsQI7J3a
         uSeUVgeiWxroTbnoe+6TCmtpx52Al9ROwcO5s1Er7HlHKsH2erDXOGLMTq2vjea3p29T
         djDqGtnPz1JO8K1r1RXMZD8SnZ0DntwHAbWGE=
MIME-Version: 1.0
In-Reply-To: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
Date: Sun, 20 Sep 2009 14:20:34 +0200
Message-ID: <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: wixor <wixorpeek@gmail.com>
Cc: lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 10:20 AM, wixor <wixorpeek@gmail.com> wrote:
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
[...]
> I have also discovered that dsdt contains description of what is
> connected to each it87 input. Maybe it has also some code to access
> the chip? In /proc/acpi I can read only one temperature, while the
> chip measures three temperatures, fan speeds and voltages. This is
> desktop pc with ASUS A8N1-E maniboard, athlon64 and nforce4 chipset.

Try the asus_atk0110 driver, it handles the ACPI hwmon interface on
Asus motherboards. If it does not work then please send a dump of your
DSDT (/sys/firmware/acpi/tables/DSDT).

Luca
