Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYLaVBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYLaVBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 16:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYLaVBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 16:01:44 -0500
Received: from lucidpixels.com ([75.144.35.66]:43651 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYLaVBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 16:01:44 -0500
Date: Wed, 31 Dec 2008 16:01:42 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Grant Grundler <grundler@google.com>
cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.28: Is there a way to disable sata probing for certain
 ports?
In-Reply-To: <da824cf30812300908x3ff6061cn569203d5163664ea@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812311601130.25367@p34.internal.lan>
References: <alpine.DEB.1.10.0812300605250.11356@p34.internal.lan> <da824cf30812300908x3ff6061cn569203d5163664ea@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Dec 2008, Grant Grundler wrote:

> On Tue, Dec 30, 2008 at 4:24 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> When I boot from an Intel X25-E SSD, it takes roughly a few seconds;
>> however, items such as:
>>
>> $ dmesg|grep link\ down
>> [    2.447030] ata4: SATA link down (SStatus 0 SControl 300)
>> [    4.481288] ata5: SATA link down (SStatus 0 SControl 0)
>> [    6.501288] ata6: SATA link down (SStatus 0 SControl 0)
>> [    8.522038] ata7: SATA link down (SStatus 0 SControl 0)
>> [   10.552288] ata8: SATA link down (SStatus 0 SControl 0)
>>
>> Scanning for devices on channels that have nothing connected adds to the
>> boot time, is there anyway to turn off/disable scanning for certain ports to
>> help speed the boot process?
>
> Some BIOSs allow one to enable/disable each port individually.
> Have you checked the BIOS config menus for such an option?
>
> drivers/ata/libata-core.c declares "ata_force_param_buf" but I don't
> see any documentation for it despite the reference to
> Documentation/kernel-parameters.txt .
>
> hth,
> grant
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Disabling the additional controllers helped a bit but for AHCI on a few 
boards its all or nothing, AHCI enabled/disabled.

Justin.
