Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0BAO1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:27:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:18018 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab0BAO1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ta1lVzoIzPfbt10Y5vk71dDuv2ZxNr/FIQDHzQwuDuS/oej15rqkImoOhsJZOEt6p9
         tu74JiO78A57fjZUnTxVmXgzzeaVqTAYp13AjpHFU7chwwyKmdi6gSSaEUzpmL3Lb+6t
         Hc7lQhKWZgTILoKczcy3Jj9QoPOr3vCHhwes8=
MIME-Version: 1.0
In-Reply-To: <20100201121454.GA20387@atrey.karlin.mff.cuni.cz>
References: <20100201121454.GA20387@atrey.karlin.mff.cuni.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 1 Feb 2010 22:27:27 +0800
Message-ID: <f17812d71002010627u795ff155l62c96bf64240b584@mail.gmail.com>
Subject: Re: About kernel decompressors (fwd)
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It sounds to me like this is because of the 1.4M (cannot
remember the exact size) constraint of the kernel size
on NAND that the bootloader is able to load?

On Mon, Feb 1, 2010 at 8:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> I guess Andrea wanted me  to forward this....
>
> ----- Forwarded message from Andrea Adami <andrea.adami@gmail.com> -----
> Date: Mon, 1 Feb 2010 13:08:44 +0100
> From: Andrea Adami <andrea.adami@gmail.com>
> To: pavel@ucw.cz
> Subject: About kernel decompressors
>
> Pavel,
>
> I'd like to add a couple of observations in the "Uncompressing broken
> with commit e7db7b4270" thread.
> Unfortunately I wasn't subscribed and I can't properly reply to the thread...
>
> This is for kernels 2.6.33-rc5 and -rc6 on Sharp corgi (Zaurus
> SL-C860, pxa255, 64M RAM)
>
> 1) after that commit neither gzip, nor lzo can decompress from NAND
> 2) I tested the LZMA patch and this also won't help the boot from nand
> 3) kernel size is uninfluent: I tested 930KiB-lzma kernels and 1240KiB
> gzip-kernels.
> 4) I tried to set stack size to 8192, still no boot
>
> 5) all the 3 above kernels boot just fine from kexec (I launch them
> with linux-kexecboot-2.6.26)
>
> >From nand, the boot stops immediately after
> **** JUMP to LINUX! ****
>
>
> Cheers
>
> Andrea
>
> ----- End forwarded message -----
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
