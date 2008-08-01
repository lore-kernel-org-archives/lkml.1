Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbYHANwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbYHANwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYHANw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:52:27 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:57889 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYHANw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:52:26 -0400
Date: Fri, 1 Aug 2008 15:52:22 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: m68k build failure
In-Reply-To: <20080801153710.815bbb74.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0808011551120.30950@anakin>
References: <20080730175233.02dbf021.sfr@canb.auug.org.au>
 <20080730.010234.193703201.davem@davemloft.net> <20080730084935.GA18545@uranus.ravnborg.org>
 <20080801153710.815bbb74.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Stephen,

On Fri, 1 Aug 2008, Stephen Rothwell wrote:
> On Wed, 30 Jul 2008 10:49:35 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > Full list of relevant files:
> > include/asm-m68k/contregs.h:#include <asm-sparc/contregs.h>
> > include/asm-m68k/fbio.h:#include <asm-sparc/fbio.h>
> > include/asm-m68k/idprom.h:#include <asm-sparc/idprom.h>
> 
> I applied the following patch to today's linux-next.

Thanks!

BTW, is there a (good) way to have this without duplicating those header files?

I hope to move to arch/m68k/include soon, too.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
