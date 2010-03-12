Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575Ab0CLU1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:27:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49199 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556Ab0CLU1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:27:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xXDsgLrIMvDEPwTylcdxxvwbx9fZHfVXehjbdo+GrwxHROQhHlHJ1v1Q4cgefVyf5k
         4CpAZlOaHxAYcSG+HbNqe4UO0qjZeENhvXmZq2IcpQligLsiNFpKxrJ6o1/9UZVaOOsT
         ewyIV9Jqz4LyZH23zT7El/3p6x2QmpxBPTiVA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>
	 <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>
	 <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>
	 <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>
	 <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>
	 <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan>
Date: Fri, 12 Mar 2010 12:27:16 -0800
X-Google-Sender-Auth: 5348238c385a8053
Message-ID: <86802c441003121227j77edc017vd83b2ab866ec79d8@mail.gmail.com>
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous 
	reboots [full dmesg]
From: Yinghai Lu <yinghai@kernel.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 12:02 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Fri, 12 Mar 2010, Yinghai Lu wrote:
>
>> On Fri, Mar 12, 2010 at 5:10 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
>> wrote:
>>>
>>> [    0.112379] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff
>>> 64bit]
>>
>>> [    0.133510] PCI: pci_cache_line_size set to 64 bytes
>>> [    0.133515] pci 0000:00:00.0: BAR 3: reserving [mem
>>> 0xe0000000-0xffffffff
>>> flags 0x120204] (d=0, p=0)
>>> [    0.133518] pci 0000:00:00.0: address space collision: [mem
>>> 0xe0000000-0xffffffff 64bit] already in use
>>> [    0.133522] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff
>>> 64bit]
>>> [    0.137020] system 00:09: [mem 0xe0000000-0xefffffff] has been
>>> reserved
>>> [    0.172034] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
>>> [    0.172035] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
>>
>> looks like the silicon report wrong size in that BAR3
>>
>> YH
>
> Hi,
>
> Is there anyway to work around this?  Or is it a bad motherboard?
>

maybe one new BIOS could hide that register

or use pci quirk to hide that in OS.

may need to access the chipset doc.

YH
