Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbXGNOhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbXGNOhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 10:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbXGNOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 10:37:30 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:24063 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbXGNOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 10:37:29 -0400
Date: Sat, 14 Jul 2007 17:36:15 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, alsa-user@lists.sourceforge.net
Subject: Re: Kernel 2.6.22 + ALSA + Intel HDA = hda_codec: Unknown model
Message-ID: <20070714143615.GA20527@localdomain>
References: <Pine.LNX.4.64.0707140614410.22713@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707140614410.22713@p34.internal.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 06:18:40AM -0400, Justin Piszcz wrote:
> Hi all,
> 
> I use an A-BIT AW9D-MAX motherboard and while the audio works fine using 
> the Intel HDA driver; however, I see this in dmesg:
> 
> [   29.188561] Advanced Linux Sound Architecture Driver Version 1.0.14 
> (Thu May 31 09:03:25 2007 UTC).
> [   29.188728] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) 
> -> IRQ 17
> [   29.188822] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [   29.240729] hda_codec: Unknown model for ALC882, trying auto-probe from 
> BIOS...
>                           ^^^^^^^^^^^^^
> [   29.280743] ALSA device list:
> [   29.280781]   #0: HDA Intel at 0xfdff8000 irq 17
> 
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
> Definition Audio Controller (rev 01)
> 
> Two lspci (-vx) listings attached.
> 
> Can we get the PCI ID added to the kernel source so it does not say 
> unknown model?

Actually, it is reported as unknown in a deeper probing level than
PCI. I once made a patch that among other thing identified that 
A-BIT board exactly. 

    http://mailman.alsa-project.org/pipermail/alsa-devel/2007-April/000441.html

It is possible to take this patch, drop the other bits and just
leave out the nice print that just tells it's A-BIT AW9D-MAX.

Though AFAIK, ALSA maintainers have plans to move most of the 
probing code to userspace somehow so I'm not sure if it is 
quite relevant.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
