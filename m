Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623Ab0CLVLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:11:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:46382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab0CLVLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:11:17 -0500
Message-ID: <4B9AADC1.1040808@kernel.org>
Date: Fri, 12 Mar 2010 13:10:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
  reboots
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan> <86802c441003121144y24e763e6n16f237928df1f676@mail.gmail.com> <alpine.DEB.2.00.1003121520120.6929@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003121520120.6929@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 12:32 PM, Justin Piszcz wrote:
> 
> 
> On Fri, 12 Mar 2010, Yinghai Lu wrote:
> 
>> On Fri, Mar 12, 2010 at 4:56 AM, Justin Piszcz
>> <jpiszcz@lucidpixels.com> wrote:
>>>
>>>
>>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>>
>>>>
>>>>
>>>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>>>
>>>> Problem persists.
>>>>
>>>> Others seem to have similar issues:
>>>> http://lkml.org/lkml/2010/1/9/157
>>>>
>>>> Some boards not compatible it appears..
>>>>
>>>> Justin.
>>>>
>>>>
>>>
>>> Even with all boards removed:
>>> [    0.133537] pci 0000:00:00.0: address space collision: [mem
>>> 0xe0000000-0xffffffff 64bit] already in use
>>>
>>> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual
>>> slot
>>> PCI-e_GFX and HT3 K8 part
>>>
>>
>> how about current linus' tree with pci=nocrs or pci=use_crs?
> 
> Hi, I saw your second e-mail, so it sounds like a bad board or something
> that Linux does not have a quirk for yet, but in any case, per your
> recommendations:
> 
> pci=nocrs:
> http://home.comcast.net/~jpiszcz/20100312/dmesg-pci-nocrs.txt
> 
> pci=use_crs:
> http://home.comcast.net/~jpiszcz/20100312/dmesg-use-crs.txt
> 
> No collision when pci=use_crs is used, BUT the system still crashes.
> 
> Instead of collision, it says this:
> 
> [    0.133598] PCI: pci_cache_line_size set to 64 bytes
> [    0.133603] pci 0000:00:00.0: BAR 3: reserving [mem
> 0xe0000000-0xffffffff flags 0x120204] (d=0, p=0)
> [    0.133606] pci 0000:00:00.0: no compatible bridge window for [mem
> 0xe0000000-0xffffffff 64bit]
> [    0.133610] pci 0000:00:00.0: can't reserve [mem
> 0xe0000000-0xffffffff 64bit]
> [    0.133617] pci 0000:00:11.0: BAR 0: reserving [io  0xff00-0xff07
> flags 0x20101] (d=0, p=0)
> 
> [    0.133735] Expanded resource reserved due to conflict with PCI Bus
> 0000:00
> 
> Ideas?

you are using 2.6.33, can you try linus today's git or 2.6.34-rc1?

Yinghai

