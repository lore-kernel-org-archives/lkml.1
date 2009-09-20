Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZITVbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZITVbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZITVbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:31:55 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48860 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZITVby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aRTcU+G5HNOsHXjqrnRm1CDl/3fmNLrS/MqPUBeZ1FDchawJyoErPJa1/1rNkqqZPt
         ESBuaA+3JyJQFbRMihGjxyJRW+DvPVFmRxZY7RCL76vxfAInGo8F0d2PXIm/bbeQlGma
         3jOB0CZqNY6V0dJImwXKIB2HXWxZ1GmexTDrc=
MIME-Version: 1.0
In-Reply-To: <200909201637.52514.gene.heskett@verizon.net>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	 <200909201637.52514.gene.heskett@verizon.net>
Date: Sun, 20 Sep 2009 23:31:56 +0200
Message-ID: <68676e00909201431j43402470g70df5519a963097b@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: wixor <wixorpeek@gmail.com>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 10:37 PM, Gene Heskett <gene.heskett@verizon.net> wrote:
> On Sunday 20 September 2009, Luca Tettamanti wrote:
>>On Sun, Sep 20, 2009 at 10:20 AM, wixor <wixorpeek@gmail.com> wrote:
>>> Hello,
>>> with recent upgrade to 2.6.31 I get
>>>
>>> it87: Found IT8712F chip at 0x290, revision 7
>>> it87: in3 is VCC (+5V)
>>> it87: in7 is VCCH (+5V Stand-By)
>>> ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
>>> [0x295-0x296]
>>> ACPI: Device needs an ACPI driver
>>> FATAL: Error inserting it87
>>> (/lib/modules/2.6.31/kernel/drivers/hwmon/it87.ko): Device or resource
>>> busy
>>
>>[...]
>>
>>> I have also discovered that dsdt contains description of what is
>>> connected to each it87 input. Maybe it has also some code to access
>>> the chip? In /proc/acpi I can read only one temperature, while the
>>> chip measures three temperatures, fan speeds and voltages. This is
>>> desktop pc with ASUS A8N1-E maniboard, athlon64 and nforce4 chipset.
>>
>>Try the asus_atk0110 driver, it handles the ACPI hwmon interface on
>>Asus motherboards. If it does not work then please send a dump of your
>>DSDT (/sys/firmware/acpi/tables/DSDT).
>>
> Jumping in the middle of this, I am another that it87 doesn't work very well
> for,  ASUS M2N SLI Deluxe board.

Please define "doesn't work well". asus_atk0110 should handle that
board. In case of troubles enable CONFIG_HWMON_DEBUG_CHIP, load
asus_atk0110 and post the content of the kernel log.

Luca
