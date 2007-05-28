Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbXE1JPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbXE1JPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbXE1JPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:15:04 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3965 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbXE1JPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:15:02 -0400
Date: Mon, 28 May 2007 10:14:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Qi Yong <qiyong@fc-cn.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.22-rc3
Message-ID: <20070528091453.GB26046@flint.arm.linux.org.uk>
Mail-Followup-To: Qi Yong <qiyong@fc-cn.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <2cd57c900705272335l1cacaedfwd2972cbb8b458ad3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cd57c900705272335l1cacaedfwd2972cbb8b458ad3@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 02:35:12PM +0800, Qi Yong wrote:
> >Ben Dooks (6):
> >      [ARM] 4395/1: S3C24XX: add include of <linux/sysdev.h> to relevant 
> >      machines
> >      [ARM] 4396/1: S3C2443: Add missing HCLK clocks
> >      [ARM] 4397/1: S3C2443: remove SDI0/1 IRQ ambiguity
> >      [ARM] 4398/1: S3C2443: Fix watchdog IRQ number
> >      [ARM] 4399/2: S3C2443: Fix SMDK2443 nand timings
> >      [ARM] 4400/1: S3C24XX: Add high-speed MMC device definition
> 
>   CC      arch/arm/plat-s3c24xx/devs.o
> /home/qiyong/linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:410: error:
> 'S3C2443_PA_HSMMC' undeclared here (not in a function)
> /home/qiyong/linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:411: error:
> 'S3C2443_SZ_HSMMC' undeclared here (not in a function)

There's a fix already pending (from a day after -rc3) in my tree.
You'll have to wait until the end of the week before I push it to
Linus, or alternatively grab it from the patch system.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
