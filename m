Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbYFIGlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbYFIGlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbYFIGlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:41:00 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:32776 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbYFIGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:40:59 -0400
Date: Mon, 9 Jun 2008 08:40:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Luke -Jr <luke@dashjr.org>
cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Subject: Re: bcm33xx port
In-Reply-To: <200806081836.42351.luke@dashjr.org>
Message-ID: <Pine.LNX.4.64.0806090839100.25145@anakin>
References: <200806072113.26433.luke@dashjr.org> <200806081527.31221.luke@dashjr.org>
 <Pine.LNX.4.55.0806082249330.15673@cliff.in.clinika.pl> <200806081836.42351.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008, Luke -Jr wrote:
> On Sunday 08 June 2008, Maciej W. Rozycki wrote:
> > On Sun, 8 Jun 2008, Luke -Jr wrote:
> > > >  Not exactly.  Try harder -- this is simple arithmetic and you've got
> > > > all the data given above already. :)
> > >
> > > 200 / 2? I'm not really sure what a 'jiffy' is..
> >
> >  Hmm, I have thought it can be inferred from the code involved or failing
> > that -- Google...  Well, anyway, a jiffy is a tick of the kernel timer or,
> > specifically in this context and to be more precise, the interval between
> > such two consecutive ticks or, in other words, 1/HZ.
                                                     ^^
Look at CONFIG_HZ, which is probably 100, 250, or 1000.

> jiffy = 1 / 200000 HZ = 0.000005 sec/tick
> loop = 200000 instructions / 2 instructions per loop = 100000 loops/sec
> 
> So 0.00000000005 loops per jiffy? But it can't be, since loops_per_jiffy isn't 
> floating point... :/

So loops_per_jiffie is approx. CPU clock frequency / CONFIG_HZ.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
