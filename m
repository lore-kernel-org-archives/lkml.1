Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654Ab0CLVa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:30:26 -0500
Received: from lucidpixels.com ([75.144.35.66]:35284 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934620Ab0CLVaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:30:25 -0500
Date: Fri, 12 Mar 2010 16:30:24 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Yinghai Lu <yinghai@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: 2.6.34-rc1: pci 0000:00:00.0: address space collision / spontaenous
  reboots [now 2.6.34-rc1]
In-Reply-To: <alpine.DEB.2.00.1003121538110.6929@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003121622470.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120548551.6420@p34.internal.lan>  <alpine.DEB.2.00.1003120556590.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120743530.15732@p34.internal.lan> 
 <alpine.DEB.2.00.1003120755340.15732@p34.internal.lan>  <alpine.DEB.2.00.1003120809030.15732@p34.internal.lan>  <86802c441003121201y4c946fecrda5463b056f1ba58@mail.gmail.com>  <alpine.DEB.2.00.1003121502160.6929@p34.internal.lan>
 <86802c441003121227j77edc017vd83b2ab866ec79d8@mail.gmail.com> <alpine.DEB.2.00.1003121532300.6929@p34.internal.lan> <alpine.DEB.2.00.1003121538110.6929@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Mar 2010, Justin Piszcz wrote:

> On Fri, 12 Mar 2010, Justin Piszcz wrote:
>

# Disable Bootmem code (NO_BOOTMEM) [Y/n/?] (NEW)

I see this new option ^

Ok, booting 2.6.34-rc1:

[    0.132248] PCI: pci_cache_line_size set to 64 bytes
[    0.132248] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xffffffff flags 0x120204] (d=0, p=0)
[    0.132248] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.132248] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]

Full dmesg:
http://home.comcast.net/~jpiszcz/20100312/dmesg-2.6.34-rc1.txt

Justin.

