Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbXE1KoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbXE1KoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXE1Knw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:43:52 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:56609 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXE1Knv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:43:51 -0400
Date: Mon, 28 May 2007 10:43:41 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Qi Yong <qiyong@fc-cn.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.22-rc3
Message-ID: <20070528104341.GA7171@fluff.org.uk>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <2cd57c900705272335l1cacaedfwd2972cbb8b458ad3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cd57c900705272335l1cacaedfwd2972cbb8b458ad3@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 02:35:12PM +0800, Qi Yong wrote:
> On 26/05/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >It's Friday evening, and the US is preparing for a long three-day weekend,
> >often considered the official start of summer here.
> >
> >So what's a pasty white nerd to do? You can't go out on the beach, because
> >the goodlooking people will laugh at you, and kick sand in your face.
> >
> >I'm not bitter.
> >
> >But now you _can_ do something: you can download the latest -rc kernel,
> >and smile smugly to yourself, knowing that you are running the latest and
> >greatest on your machine. And suddenly it doesn't even matter that summer
> >is coming, because you can just sit in the basement, and close the blinds,
> >and bask in the warm light from your LCD, rather than the harsh glare of
> >the daystar..
> >
> >The geeks with embedded hardware can consider themselves doubly special
> >(and not just because your mothers told you you are), because we've got
> >updates to ARM, SH and Blackfin.
> >
> >What more could you possibly want? Some ATA updates? USB suspend problem
> >solving? Infiniband? DVB and MMC updates? Network drivers and some fixes
> >for silly network problems? Yeah we got them!
> 
> Unfortunately MMC update get compiling breakages.

[snip]

> >
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

sorry about that, missed a file from the patch that adds this
and missed rmk's merge request, patch is in the patch system and
should be in as soon as possible.

fyi:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4402/1


-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
