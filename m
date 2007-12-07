Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXLGGCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXLGGCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 01:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXLGGCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 01:02:03 -0500
Received: from ns1.primeinteractive.net ([195.95.205.253]:56086 "EHLO
	mail.primeinteractive.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXLGGCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 01:02:01 -0500
X-Quarantine-ID: <Lv-vRAXmxGC0>
From: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
Organization: Prime Interactive Ltd.
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: ICH9 & Core2 Duo - kernel crash
Date: Fri, 7 Dec 2007 07:01:55 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200712041331.24678.pavol.cvengros@primeinteractive.net> <47585879.7010305@tmr.com>
In-Reply-To: <47585879.7010305@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712070701.55283.pavol.cvengros@primeinteractive.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 21:15:53 Bill Davidsen wrote:
> Pavol Cvengros wrote:
> > Hello,
> >
> > I am trying LKML to get some help on one linux kernel related problem.
> > Lately we got a machine with new HW from Intel. CPU is Intel Core2 Duo
> > E6850 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with G33 chipset.
> >
> > After long fight with kernel crashes on different things, we figured out
> > that if the multicore is disabled in bios, everything is ok and machine
> > is running good. No kernel crashes no problems, but with one core only.
> >
> > This small table will maybe explain:
> >
> > Cores   -     kernel   -   state
> >    2  -   nonsmp or smp  - crash
> >    1  -  smp or nonsmp  - ok
> >
> > All crashes have been different (swaper, rcu, irq, init.....) or we just
> > got internal gcc compiler error while compiling kernel/glibc/.... and the
> > machine was frozen.
> >
> > Please can somebody advise what to do to identify that problem more
> > precisely. (debug kernel options?)
> >
> > Our immpresion - ICH9 & ICH9R support in kernel is bad... sorry to say..
>
> I have seen unusual memory behavior under heavy load, in the cases I saw
> it was heavy DMA load from multiple SCSI controllers, and one case with
> FFT on the CPU and heavy network load with gigE. Have you run memtest on
> this hardware? Just a thought, but I see people running Linux on that
> chipset, if not that particular board.
>
> A cheap test even if it shows nothing. Of course it could be a CPU cache
> issue in that one CPU, although that's unlikely.

yes, memtest was running all his tests without problems. The wierd thing is 
that all kernel crashes we have seen were different (as stated in original 
mail)....

-- 
-----------[ Signature ]---------
Name: Pavol Cvengros
Company: Prime Interactive, Ltd.
E-mail: pavol.cvengros@primeinteractive.net
Web: http://www.primeinteractive.net
Personal web: http://orpheus.grass.sk
