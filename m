Return-Path: <linux-kernel-owner+w=401wt.eu-S964786AbXGTRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbXGTRGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXGTRFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:05:55 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:38238 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765851AbXGTRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:05:52 -0400
Date: Fri, 20 Jul 2007 19:05:49 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
In-Reply-To: <1184950138.3455.42.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707201905340.18493@anakin>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg>
 <1184950138.3455.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, James Bottomley wrote:
> On Fri, 2007-07-20 at 18:40 +0200, Geert Uytterhoeven wrote:
> > plain text document attachment (m68k-wd33c93-needs-asm-irq.diff)
> > wd33c93 SCSI needs <asm/irq.h> on m68k
> > 
> > drivers/scsi/wd33c93.c: In function 'wd33c93_host_reset':
> > drivers/scsi/wd33c93.c:1582: error: implicit declaration of function 'disable_irq'
> > drivers/scsi/wd33c93.c:1603: error: implicit declaration of function 'enable_irq'
> > 
> > The driver still compiles on MIPS (CONFIG_SGIWD93_SCSI=y)
> 
> That's fixed here, isn't it:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=078dda95c521b1c78d1b5da69ac90d581abc9951

Indeed, thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
