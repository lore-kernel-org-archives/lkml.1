Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZEFGgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZEFGgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZEFGfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:35:54 -0400
Received: from smtp27.orange.fr ([80.12.242.96]:61646 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbZEFGfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:35:53 -0400
X-ME-UUID: 20090506063552628.995841C00092@mwinf2726.orange.fr
Message-ID: <4A012FC8.3020304@free.fr>
Date: Wed, 06 May 2009 08:35:52 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: DMA debug trace pointing to rtl8187
References: <49FDB9F8.3080400@free.fr> <20090506133131F.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090506133131F.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> CC'ed linux-usb,
> 
> The ehci_hcd driver uses buffers on the stack for DMA?
> 
> On Sun, 03 May 2009 17:36:24 +0200
> Eric Valette <eric.valette@free.fr> wrote:
> 
>> ------------[ cut here ]------------
>>
>> WARNING: at /usr/src/linux-2.6.22.9/lib/dma-debug.c:609
> 
> Hmm, the kernel version is wired. lib/dma-debug.c was added in
> 2.6.30-rc.

No that's the file path.  I use ketchup to apply patches...

> 
>> check_for_stack+0x6b/0x8b()
>> Hardware name: P5W DH Deluxe
>>
>> ehci_hcd 0000:00:1d.7: DMA-API: device driver maps memory fromstack
>> [addr=ffff88007fa79968]
>> Modules linked in:
>>
>> Pid: 297, comm: khubd Not tainted 2.6.30-rc4-git1 #32

Here is the real version.

-- eric

