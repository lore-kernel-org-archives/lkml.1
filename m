Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab0CLUcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:32:20 -0500
Received: from lucidpixels.com ([75.144.35.66]:46676 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934558Ab0CLUcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:32:18 -0500
Date: Fri, 12 Mar 2010 15:32:17 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
  reboots
In-Reply-To: <86802c441003121144y24e763e6n16f237928df1f676@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003121520120.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan> 
 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan> <86802c441003121144y24e763e6n16f237928df1f676@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-904432220-1268425937=:6929"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-904432220-1268425937=:6929
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 12 Mar 2010, Yinghai Lu wrote:

> On Fri, Mar 12, 2010 at 4:56 AM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>>
>>
>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>
>>>
>>>
>>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>>
>>> Problem persists.
>>>
>>> Others seem to have similar issues:
>>> http://lkml.org/lkml/2010/1/9/157
>>>
>>> Some boards not compatible it appears..
>>>
>>> Justin.
>>>
>>>
>>
>> Even with all boards removed:
>> [ =A0 =A00.133537] pci 0000:00:00.0: address space collision: [mem
>> 0xe0000000-0xffffffff 64bit] already in use
>>
>> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual sl=
ot
>> PCI-e_GFX and HT3 K8 part
>>
>
> how about current linus' tree with pci=3Dnocrs or pci=3Duse_crs?

Hi, I saw your second e-mail, so it sounds like a bad board or something
that Linux does not have a quirk for yet, but in any case, per your
recommendations:

pci=3Dnocrs:
http://home.comcast.net/~jpiszcz/20100312/dmesg-pci-nocrs.txt

pci=3Duse_crs:
http://home.comcast.net/~jpiszcz/20100312/dmesg-use-crs.txt

No collision when pci=3Duse_crs is used, BUT the system still crashes.

Instead of collision, it says this:

[    0.133598] PCI: pci_cache_line_size set to 64 bytes
[    0.133603] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xfffffff=
f flags 0x120204] (d=3D0, p=3D0)
[    0.133606] pci 0000:00:00.0: no compatible bridge window for [mem 0xe00=
00000-0xffffffff 64bit]
[    0.133610] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 6=
4bit]
[    0.133617] pci 0000:00:11.0: BAR 0: reserving [io  0xff00-0xff07 flags =
0x20101] (d=3D0, p=3D0)

[    0.133735] Expanded resource reserved due to conflict with PCI Bus 0000=
:00

Ideas?

Justin.


---1463747160-904432220-1268425937=:6929--
