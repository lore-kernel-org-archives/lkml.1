Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYEDQI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYEDQI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYEDQIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:08:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44326 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140AbYEDQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:08:49 -0400
Date: Sun, 4 May 2008 16:56:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bryan Wu" <cooloney@kernel.org>
Cc: "Yang, Graf" <Graf.Yang@analog.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Blackfin Serial Driver: Enable IR function when user
 application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line
 discipline N_IRDA
Message-ID: <20080504165625.083d3d22@core>
In-Reply-To: <386072610805040827w7a606ee2ld24e6752a6c745c7@mail.gmail.com>
References: <200804241929.m3OJToSE021045@hera.kernel.org>
	<20080424215004.34517136@the-village.bc.nu>
	<0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com>
	<20080425105545.77b8c5e8@core>
	<386072610805040827w7a606ee2ld24e6752a6c745c7@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, I got the compile failure now:
> --
>   CC      drivers/serial/bfin_5xx.o
> drivers/serial/bfin_5xx.c: In function 'bfin_serial_init':
> drivers/serial/bfin_5xx.c:1281: error: 'struct tty_driver' has no
> member named 'set_ldisc'
> make[2]: *** [drivers/serial/bfin_5xx.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> --
> 
> Obviously, it is no way to change code like this for passing compiling:

I've added the uart set_ldisc operator to my tree. I thought Andrew had
it as well, but if not I'll push it again Tuesday (Monday is a holiday
here)

Alan
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
