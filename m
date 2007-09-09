Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXIISp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXIISp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXIISpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:45:50 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:46760 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758633AbXIISpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:45:49 -0400
Date: Sun, 9 Sep 2007 20:45:47 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checksyscalls.sh: ignore restart_syscall
In-Reply-To: <20070909100719.GA17423@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709092045170.5149@anakin>
References: <Pine.LNX.4.64.0709091131550.6588@anakin>
 <20070909100719.GA17423@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007, Sam Ravnborg wrote:
> On Sun, Sep 09, 2007 at 11:34:11AM +0200, Geert Uytterhoeven wrote:
> > checksyscalls.sh: ignore restart_syscall, which is not needed on m68k and
> > blackfin.
> 
> If only these archs does not care then just stick that
> #define __IGNORE_...
> in the arch specifc unistd.h files.
> x86_64 and other do this already.
> 
> Try:
> ls include/asm*/unistd.h | xargs grep IGNORE

Ah, thanks, I didn't know this trick was being used...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
