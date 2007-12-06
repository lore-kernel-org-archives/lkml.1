Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXLFT7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXLFT7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXLFT6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:58:53 -0500
Received: from mail.tmr.com ([64.65.253.246]:43871 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXLFT6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:58:52 -0500
Message-ID: <47585879.7010305@tmr.com>
Date: Thu, 06 Dec 2007 15:15:53 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: ICH9 & Core2 Duo - kernel crash
References: <200712041331.24678.pavol.cvengros@primeinteractive.net>
In-Reply-To: <200712041331.24678.pavol.cvengros@primeinteractive.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavol Cvengros wrote:
> Hello,
> 
> I am trying LKML to get some help on one linux kernel related problem.
> Lately we got a machine with new HW from Intel. CPU is Intel Core2 Duo E6850 
> 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with G33 chipset.
> 
> After long fight with kernel crashes on different things, we figured out that 
> if the multicore is disabled in bios, everything is ok and machine is running 
> good. No kernel crashes no problems, but with one core only.
> 
> This small table will maybe explain:
> 
> Cores   -     kernel   -   state
>    2  -   nonsmp or smp  - crash
>    1  -  smp or nonsmp  - ok
> 
> All crashes have been different (swaper, rcu, irq, init.....) or we just got 
> internal gcc compiler error while compiling kernel/glibc/.... and the machine 
> was frozen.
> 
> Please can somebody advise what to do to identify that problem more precisely.
> (debug kernel options?)
> 
> Our immpresion - ICH9 & ICH9R support in kernel is bad... sorry to say..
> 
I have seen unusual memory behavior under heavy load, in the cases I saw 
it was heavy DMA load from multiple SCSI controllers, and one case with 
FFT on the CPU and heavy network load with gigE. Have you run memtest on 
this hardware? Just a thought, but I see people running Linux on that 
chipset, if not that particular board.

A cheap test even if it shows nothing. Of course it could be a CPU cache 
issue in that one CPU, although that's unlikely.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
