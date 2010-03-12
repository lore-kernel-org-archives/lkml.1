Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab0CLUC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:02:56 -0500
Received: from lucidpixels.com ([75.144.35.66]:56282 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432Ab0CLUCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:02:54 -0500
Date: Fri, 12 Mar 2010 15:02:52 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
  reboots [full dmesg]
In-Reply-To: <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan> 
 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan> <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-300828902-1268424172=:6929"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-300828902-1268424172=:6929
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 12 Mar 2010, Yinghai Lu wrote:

> On Fri, Mar 12, 2010 at 5:10 AM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>> [ =A0 =A00.112379] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff =
64bit]
>
>> [ =A0 =A00.133510] PCI: pci_cache_line_size set to 64 bytes
>> [ =A0 =A00.133515] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0x=
ffffffff
>> flags 0x120204] (d=3D0, p=3D0)
>> [ =A0 =A00.133518] pci 0000:00:00.0: address space collision: [mem
>> 0xe0000000-0xffffffff 64bit] already in use
>> [ =A0 =A00.133522] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xfff=
fffff
>> 64bit]
>> [ =A0 =A00.137020] system 00:09: [mem 0xe0000000-0xefffffff] has been re=
served
>> [ =A0 =A00.172034] pci_bus 0000:00: resource 0 [io =A00x0000-0xffff]
>> [ =A0 =A00.172035] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffff=
f]
>
> looks like the silicon report wrong size in that BAR3
>
> YH

Hi,

Is there anyway to work around this?  Or is it a bad motherboard?

Justin.

---1463747160-300828902-1268424172=:6929--
