Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYIDJkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYIDJkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYIDJkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:40:04 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:47733 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbYIDJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:40:03 -0400
Date: Thu, 4 Sep 2008 11:39:59 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/8] m68k: Remove unused atari_kbd_translate()
In-Reply-To: <alpine.DEB.1.00.0809041121030.12258@zirkon.biophys.uni-duesseldorf.de>
Message-ID: <Pine.LNX.4.64.0809041137160.11210@anakin>
References: <20080903071542.615137611@mail.of.borg> <20080903071742.326285837@mail.of.borg>
 <alpine.DEB.1.00.0809041121030.12258@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Michael Schmitz wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > If CONFIG_VT=n, I get:
> > 
> > | arch/m68k/atari/built-in.o: In function `atari_kbd_translate':
> > | arch/m68k/atari/atakeyb.c:640: undefined reference to `shift_state'
> > 
> > Just remove atari_kbd_translate(), as it's unused.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Thanks for cleaning this up! No need to ack these, is there?

Please do.  If you ack it, I'll add it to the patch for final submission.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
