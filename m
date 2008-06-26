Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbYFZHLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbYFZHLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYFZHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:11:14 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:42289 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYFZHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:11:13 -0400
Date: Thu, 26 Jun 2008 09:11:06 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
cc: Adrian Bunk <bunk@kernel.org>, zippel@linux-m68k.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [2.6 patch] remove the dead ATARI_SCC{,_DMA} options
In-Reply-To: <alpine.DEB.1.00.0806260644080.30738@zirkon.biophys.uni-duesseldorf.de>
Message-ID: <Pine.LNX.4.64.0806260909490.30924@anakin>
References: <20080625162536.GH10285@cs181140183.pp.htv.fi>
 <alpine.DEB.1.00.0806260644080.30738@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Michael Schmitz wrote:
> > It seems the driver was removed back in kernel 2.3 but the options were
> > forgotten.
> > 
> > Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> A revived Atari SCC serial driver should be in Geert's patch queue, or in the

... which needs some rework before it can be submitted, I'm afraid (I can
take care of the checkpatch warnings, though ;-)

> m68k kernel tree. The SCC_DMA option, however, is dead and can be removed.

So I think it's safe to apply the whole patch, and readd
CONFIG_ATARI_SCC together with the new driver.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
