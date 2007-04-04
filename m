Return-Path: <linux-kernel-owner+w=401wt.eu-S2992715AbXDDHEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992715AbXDDHEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 03:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992714AbXDDHEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 03:04:44 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:48103 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992715AbXDDHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 03:04:43 -0400
Date: Wed, 4 Apr 2007 09:04:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <20070403.225006.119275067.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0704040903470.20803@anakin>
References: <20070404022544.59b022a6@the-village.bc.nu>
 <17939.10130.687893.167511@cargo.ozlabs.ibm.com> <1175663999.2932.8.camel@shinybook.infradead.org>
 <20070403.225006.119275067.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Wed, 04 Apr 2007 01:19:59 -0400
> 
> > I don't see why that 'should' be the case. Certainly it _isn't_ the case
> > on most supported platforms -- we have separate device numbers, and
> > names, for most types of ports. There's only one or two drivers which
> > abuse ttySn for anything other than 8250 ports.
> 
> sunsu, sunzilog, pmac_zilog, sunsab, etc.

amiserial.

> The list is longer than you think.  In fact the convention is
> very well established.

And I guess the recently revived Atari serial driver, too.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
