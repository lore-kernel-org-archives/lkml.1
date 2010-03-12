Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0CLUjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:39:12 -0500
Received: from lucidpixels.com ([75.144.35.66]:46371 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab0CLUjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:39:10 -0500
Date: Fri, 12 Mar 2010 15:39:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
  reboots [full dmesg]
In-Reply-To: <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003121538110.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan> 
 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>  <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>  <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan>
 <86802c441003121227j77edc017vd83b2ab866ec79d8@mail.gmail.com> <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1882829651-1268426350=:6929"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1882829651-1268426350=:6929
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 12 Mar 2010, Justin Piszcz wrote:

>
>
> On Fri, 12 Mar 2010, Yinghai Lu wrote:
>>>>=20
>>>> looks like the silicon report wrong size in that BAR3
>>>>=20
>>>> YH
>>>=20
>>> Hi,
>>>=20
>>> Is there anyway to work around this? =A0Or is it a bad motherboard?
>>>=20
>>=20
>> maybe one new BIOS could hide that register
> Hi,
>
> It is using the latest F8c BIOS:
> http://www.gigabyte.us/Products/Motherboard/Products_Overview.aspx?Produc=
tID=3D3007
>
> Other (earlier) bios' have been tested, that did not help either.
>
> Is there anyway to to the kernel not to touch that range of memory?
> 0xe0000000-0xffffffff?
>
> Justin.
>
>>=20
>> or use pci quirk to hide that in OS.
>>=20
>> may need to access the chipset doc.
>>=20
>> YH
>

Here is the lshw output:

      *-pci:0
           description: Host bridge
           product: RD790 Northbridge only dual slot PCI-e_GFX and HT3 K8 p=
art
           vendor: ATI Technologies Inc
           physical id: 100
           bus info: pci@0000:00:00.0
           version: 00
           width: 64 bits
           clock: 66MHz
           configuration: latency=3D32
           resources: memory:0-1fffffff

Justin.

---1463747160-1882829651-1268426350=:6929--
