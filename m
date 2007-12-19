Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXLSHqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXLSHqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 02:46:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbXLSHpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 02:45:53 -0500
Received: from jupiter.malva.ua ([62.244.5.114]:44907 "EHLO jupiter.malva.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXLSHpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 02:45:52 -0500
X-Greylist: delayed 977 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2007 02:45:51 EST
Message-ID: <00fc01c84210$f20dcdc0$3304200a@vadimtmp>
Reply-To: "Vadim Yatsenko" <vadim.yatsenko@malva.ua>
From: "Vadim Yatsenko" <vadim.yatsenko@malva.ua>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>, <kernel@avr32linux.org>,
       <linux-kernel@vger.kernel.org>, "Remy Bohmer" <linux@bohmer.net>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com>
Subject: Re: [PATCH 0/5] atmel_serial: Cleanups, irq handler splitup & DMA
Date: Wed, 19 Dec 2007 09:29:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
X-OriginalArrivalTime: 19 Dec 2007 07:29:30.0877 (UTC) FILETIME=[E4FD3AD0:01C84210]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What prepatches one need to aply to what kernel version (vanila, git, ...) 
before these?

With best regards, Vadim Yatsenko.

----- Original Message ----- 
From: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
To: "Andrew Victor" <linux@maxim.org.za>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>; "Haavard 
Skinnemoen" <hskinnemoen@atmel.com>; <kernel@avr32linux.org>; 
<linux-kernel@vger.kernel.org>; "Remy Bohmer" <linux@bohmer.net>; "ARM Linux 
Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>
Sent: Tuesday, December 18, 2007 7:06 PM
Subject: [PATCH 0/5] atmel_serial: Cleanups, irq handler splitup & DMA


> The following patchset cleans up the atmel_serial driver a bit,
> moves a significant portion of the interrupt handler into a tasklet,
> and adds DMA support. This is the result of a combined effort by Chip
> Coldwell, Remy Bohmer and me. The patches should apply cleanly onto
> Linus' latest git tree.
>
> It all seems to behave both with and without DMA enabled, but I'll do
> some more testing tomorrow.
>
> Note that break and error handling doesn't work too well with DMA
> enabled. This is a common problem with all the efforts I've seen
> adding DMA support to this driver (including my own). I'm tempted to
> just ignore the problem for now and hopefully come up with a solution
> later.
>
> Everyone, please give it a try and/or review the code.
>
> PS: Andrew, I'm sending it to you because I believe you're the
> maintainer of this driver, although MAINTAINERS doesn't say anything
> about it. Please let me know if this isn't how you want it.
>
> Chip Coldwell (1):
>      atmel_serial: Add DMA support
>
> Haavard Skinnemoen (2):
>      atmel_serial: Use cpu_relax() when busy-waiting
>      atmel_serial: Use existing console options only if BRG is running
>
> Remy Bohmer (2):
>      atmel_serial: Clean up the code
>      atmel_serial: Split the interrupt handler
>
> drivers/serial/atmel_serial.c |  881 
> ++++++++++++++++++++++++++++++++---------
> 1 files changed, 700 insertions(+), 181 deletions(-)
>
> -------------------------------------------------------------------
> List admin: 
> http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
> 

