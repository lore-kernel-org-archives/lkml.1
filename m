Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbXE1GfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbXE1GfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 02:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbXE1GfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 02:35:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:17533 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXE1GfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 02:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XIYYePDxk0JiPaLHKMdhevLCaJ4Bbd9PkkSHfoqYD6ZKh2Smvfo/imlDGS16OIqJRJOgq7q+PSGPHUNb3Rc/Udd4h5Ln5syn9AJneC6uxHaiOYvjBT95R/woRAg7viSLUjBtYVbWczIQxV32ieB1JCsvCtRxZ2aNjvenNxjRXN8=
Message-ID: <2cd57c900705272335l1cacaedfwd2972cbb8b458ad3@mail.gmail.com>
Date: Mon, 28 May 2007 14:35:12 +0800
From: "Qi Yong" <qiyong@fc-cn.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.22-rc3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
X-Google-Sender-Auth: 42d1d29bd38e63cf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/05/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> It's Friday evening, and the US is preparing for a long three-day weekend,
> often considered the official start of summer here.
>
> So what's a pasty white nerd to do? You can't go out on the beach, because
> the goodlooking people will laugh at you, and kick sand in your face.
>
> I'm not bitter.
>
> But now you _can_ do something: you can download the latest -rc kernel,
> and smile smugly to yourself, knowing that you are running the latest and
> greatest on your machine. And suddenly it doesn't even matter that summer
> is coming, because you can just sit in the basement, and close the blinds,
> and bask in the warm light from your LCD, rather than the harsh glare of
> the daystar..
>
> The geeks with embedded hardware can consider themselves doubly special
> (and not just because your mothers told you you are), because we've got
> updates to ARM, SH and Blackfin.
>
> What more could you possibly want? Some ATA updates? USB suspend problem
> solving? Infiniband? DVB and MMC updates? Network drivers and some fixes
> for silly network problems? Yeah we got them!

Unfortunately MMC update get compiling breakages.

>
> So stop worrying about those dangerous ultraviolet rays, and instead get
> your Vitamin D in the form God (and the pharmaceutical industry) intended:
> small easily swallowed pills. Beaches are overrated anyway, the sand gets
> into the laptop fan and soon it won't work.
>
> May you have a great summer,
>
>                 Linus
>


>
> Ben Dooks (6):
>       [ARM] 4395/1: S3C24XX: add include of <linux/sysdev.h> to relevant machines
>       [ARM] 4396/1: S3C2443: Add missing HCLK clocks
>       [ARM] 4397/1: S3C2443: remove SDI0/1 IRQ ambiguity
>       [ARM] 4398/1: S3C2443: Fix watchdog IRQ number
>       [ARM] 4399/2: S3C2443: Fix SMDK2443 nand timings
>       [ARM] 4400/1: S3C24XX: Add high-speed MMC device definition

   CC      arch/arm/plat-s3c24xx/devs.o
/home/qiyong/linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:410: error:
'S3C2443_PA_HSMMC' undeclared here (not in a function)
/home/qiyong/linux/linux-2.6/arch/arm/plat-s3c24xx/devs.c:411: error:
'S3C2443_SZ_HSMMC' undeclared here (not in a function)

-- 
Qi Yong
