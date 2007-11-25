Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXKYLQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXKYLQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 06:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXKYLQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 06:16:14 -0500
Received: from adicia.telenet-ops.be ([195.130.132.56]:42578 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXKYLQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 06:16:13 -0500
Date: Sun, 25 Nov 2007 12:16:08 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
In-Reply-To: <20071123114329.GG7681@zakalwe.fi>
Message-ID: <Pine.LNX.4.64.0711251215380.5532@anakin>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
 <20071123114329.GG7681@zakalwe.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007, Heikki Orsila wrote:
> On Fri, Nov 23, 2007 at 12:15:53AM +0000, Daniel Drake wrote:
> > Why unaligned access is bad
> > ===========================
> > 
> > Most architectures are unable to perform unaligned memory accesses. Any
> > unaligned access causes a processor exception.
> 
> "Some architectures are unable to perform unaligned memory accesses, 
> either an exception is generated, or the data 
> access is silently invalid. In architectures that allow unaligned 
> access, natural aligned accesses are usually faster than non-aligned."
> 
> > In summary: if your code causes unaligned memory accesses to happen, your code
> > will not work on some platforms, and will perform *very* badly on others.
> 
> *very* -> *slower*
> 
> > Natural alignment
> > =================
> 
> Please move this definition before "Why unaligned access is bad".
> 
> Also, it would be nice to have a table of ISAs:
> 
> ISA		Need		Need
> 		natural		alignment
> 		alignment	by x
> --------------------------------------------
> m68k		No		2

`No' for >= 68020.
`Yes' for < 68020.

> powerpc/ppc	Yes		Word size
> x86		No		No
> x86_64		No		No

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
