Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXHRGW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXHRGW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 02:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXHRGWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 02:22:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59145 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbXHRGWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 02:22:16 -0400
Date: Sat, 18 Aug 2007 08:23:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <bryan.wu@analog.com>,
       Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [draft] Blackfin Early Printk implmentation
Message-ID: <20070818062333.GA26416@uranus.ravnborg.org>
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <200708171336.40159.rgetz@blackfin.uclinux.org> <20070817175911.GA22046@uranus.ravnborg.org> <200708171607.32849.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708171607.32849.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > What was preventing you from just using the x86_64 code here?
> 
> Some was borrowed - but not much. since we don't support vga, or 16550 UARTs
> (Blackfin has it's own on-chip UART), I don't think this would work. 
> 
> Maybe I'm missing something - but I don't think so. Every one who implements
> implements direct IO to the hardware (except me, since I put it into the driver
> file, and force Sonic - the serial driver developer - to maintain it forever).
> 
> Most of the other early printks talks directly to the hardware.
I only looked at your version and it looked general thats why I brought
up the code sharing idea - which I agree is not possible.

> > Thinking that all should do the same so maybe alpha ought to change...
> 
> When I looked at all the printk implementations, I thought they were all
> kind of hokey, and not very common - but what do you want for a debug interface
> that lasts less than 5 seconds?
> 
> ./arch/x86_64/kernel/early_printk.c
> ./arch/blackfin/kernel/early_printk.c
> ./arch/sh64/kernel/early_printk.c
> ./arch/sh/kernel/early_printk.c
> ./arch/i386/kernel/early_printk.c
> ./arch/mips/kernel/early_printk.c
> 
> I didn't see an alpha implementation - where is it done?
Alpha uses the imlementation in lib/*print.c somehow.
And I think the right choice would be to implement
a private version of early_printk for alpha like the
other architectures do.

Thanks for the split-up. I could follow the changes now.

	Sam
