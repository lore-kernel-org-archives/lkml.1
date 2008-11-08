Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYKHXWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYKHXWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 18:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKHXV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 18:21:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56888 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYKHXV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 18:21:56 -0500
Date: Sat, 8 Nov 2008 23:21:11 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Pavel Machek <pavel@suse.cz>,
       Eric Miao <eric.y.miao@gmail.com>, Cyril Hrubis <metan@ucw.cz>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, pavel.urban@ct.cz,
       thommycheck@gmail.com
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Message-ID: <20081108232111.GD14351@flint.arm.linux.org.uk>
References: <20081105173303.GC2038@elf.ucw.cz> <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com> <20081106080416.GA1531@ucw.cz> <20081106191424.GA2273@atrey.karlin.mff.cuni.cz> <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com> <20081107142923.GA1616@ucw.cz> <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com> <20081107182311.GA28600@flint.arm.linux.org.uk> <1226155540.5379.5.camel@dax.rpnet.com> <bc64b4640811081512ta8bfd90m921760839bdf8ffa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640811081512ta8bfd90m921760839bdf8ffa@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 02:12:47AM +0300, Dmitry wrote:
> 2008/11/8 Richard Purdie <rpurdie@rpsys.net>:
> > Firstly, I don't think that patch should ever make it into a mainline
> > kernel. I can perhaps give some clues why its required though. I think
> > the bootloader on the zaurus truncates the image when writing the kernel
> > into flash using the standard flashing process. By having that much
> > extra padding on the end of the kernel, nothing important is lost.
...
> 
> I did rewrote your patch in a bit cleaner way (to apply the hack to
> vmlinux.lds.in
> in a cleaner way and only on PXA_SHARPSL), however I'm not submitting it
> till I find what's the real reason for this problem.

Even if the reason is found, I don't think it's something that should
concern the kernel, especially as there is a script which writes the
kernel image into the flash.  If it's a case that the boot loader needs
an extra 4K tacked on the end of the kernel image, that should be easy
enough for this 'updater.sh' shell script to do.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
