Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0CLVod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:44:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:51391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0CLVob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:44:31 -0500
Message-ID: <4B9AB58D.4010305@kernel.org>
Date: Fri, 12 Mar 2010 13:43:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.34-rc1: pci 0000:00:00.0: address space collision / spontaenous
  reboots [now 2.6.34-rc1]
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>  <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>  <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan> <86802c441003121227j77edc017vd83b2ab866ec79d8@mail.gmail.com> <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan> <alpine.DEB.2.00.1003121538110.6929@p34.internal.lan> <alpine.DEB.2.00.1003121622470.6929@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003121622470.6929@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 01:30 PM, Justin Piszcz wrote:
> 
> 
> On Fri, 12 Mar 2010, Justin Piszcz wrote:
> 
>> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>>
> 
> # Disable Bootmem code (NO_BOOTMEM) [Y/n/?] (NEW)
> 
> I see this new option ^
> 
> Ok, booting 2.6.34-rc1:
> 
> [    0.132248] PCI: pci_cache_line_size set to 64 bytes
> [    0.132248] pci 0000:00:00.0: BAR 3: reserving [mem
> 0xe0000000-0xffffffff flags 0x120204] (d=0, p=0)
> [    0.132248] pci 0000:00:00.0: no compatible bridge window for [mem
> 0xe0000000-0xffffffff 64bit]
> [    0.132248] pci 0000:00:00.0: can't reserve [mem
> 0xe0000000-0xffffffff 64bit]
> 
> Full dmesg:
> http://home.comcast.net/~jpiszcz/20100312/dmesg-2.6.34-rc1.txt

so it boots well?

YH
