Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0BYDTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:19:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:59572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865Ab0BYDTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:19:16 -0500
Message-ID: <4B85EE88.5050506@kernel.org>
Date: Thu, 25 Feb 2010 12:29:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: hancockrwd@gmail.com, david-b@pacbell.net, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com>	 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>	 <201002192139.46189.david-b@pacbell.net>	 <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>	 <SNT125-W457447CBE941D2703E98D0C3420@phx.gbl> <51f3faa71002231626q1eb62adeo660c282418f0e01@mail.gmail.com>,<4B85E038.20905@kernel.org> <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl>
In-Reply-To: <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 03:19:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/25/2010 12:15 PM, Yuhong Bao wrote:
>> (following thread from the ATA side) I'm with Greg on this. USB2.0 is
>> quite slow on today's standard and most 64bit machines now have IOMMU
>> of some kind anyway. 
> 
> Except that unfortunately, Intel with Lynnfield and Clarkdale decided 
> to do market segmentation on the VT-d feature. 
> This could be done because both have an integrated northbridge.
> With Lynnfield, the very common Core i5 750 CPU do not support VT-d,
> but the Core i7 800 series does.
> With Clarkdale, the very common Core i3 500 series do not support VT-d,
> but the Core i5 600 series does, except the 661.
> Not to mention that in the Core 2 generation, VT-d was available only
> on Q35/Q45/X38/X48 chipsets.

Arghhh.... I hate when intel pulls this type of 'product
differentiation' stunts.  At any rate, I'm doubtful swiotlb'ing for
usb2.0 would be noticeable at all.

Thanks.

-- 
tejun
