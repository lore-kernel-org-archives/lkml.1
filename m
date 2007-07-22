Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbXGVSv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbXGVSv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763001AbXGVSvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:51:35 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:48988 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762437AbXGVSve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:51:34 -0400
Date: Sun, 22 Jul 2007 20:51:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] take declarations of enable_irq() et.al. to
 linux/interrupt.h
In-Reply-To: <E1ICNRo-0000lx-G2@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0707222050590.18493@anakin>
References: <E1ICNRo-0000lx-G2@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Al Viro wrote:
> Now that the last inlined instances are gone, all that is left to do
> is turning disable_irq_nosync on arm26 and m68k from defines to aliases
> and we are all set - we can make these externs in linux/interrupt.h
> uncoditional and kill remaining instances in asm/irq.h

Looks great, thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
