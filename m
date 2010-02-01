Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0BAMO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:14:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50787 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab0BAMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:14:58 -0500
Date: Mon, 1 Feb 2010 13:14:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: About kernel decompressors (fwd)
Message-ID: <20100201121454.GA20387@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I guess Andrea wanted me  to forward this....

----- Forwarded message from Andrea Adami <andrea.adami@gmail.com> -----
Date: Mon, 1 Feb 2010 13:08:44 +0100
From: Andrea Adami <andrea.adami@gmail.com>
To: pavel@ucw.cz
Subject: About kernel decompressors

Pavel,

I'd like to add a couple of observations in the "Uncompressing broken
with commit e7db7b4270" thread.
Unfortunately I wasn't subscribed and I can't properly reply to the thread...

This is for kernels 2.6.33-rc5 and -rc6 on Sharp corgi (Zaurus
SL-C860, pxa255, 64M RAM)

1) after that commit neither gzip, nor lzo can decompress from NAND
2) I tested the LZMA patch and this also won't help the boot from nand
3) kernel size is uninfluent: I tested 930KiB-lzma kernels and 1240KiB
gzip-kernels.
4) I tried to set stack size to 8192, still no boot

5) all the 3 above kernels boot just fine from kexec (I launch them
with linux-kexecboot-2.6.26)

>From nand, the boot stops immediately after
**** JUMP to LINUX! ****


Cheers

Andrea

----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
