Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYLDJS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYLDJS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYLDJSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:18:14 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:35089 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYLDJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:18:12 -0500
Date: Thu, 4 Dec 2008 10:18:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Yet more ARM breakage in linux-next
In-Reply-To: <20081203124109.79f8f15b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812041017470.10635@anakin>
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
 <20081203124109.79f8f15b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Andrew Morton wrote:
> On Wed, 3 Dec 2008 19:29:05 +0000
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > This seems to be causing lots of ARM breakage:
> > 
> > lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
> > 
> > Whoever's responsible,
> 
> git-blame?
> 
> > please fix this ASAP so I can see whether my fixes
> > I merged on Monday fix the previous set of ARM build errors in linux-next.
> 
> commit b032dfc80921daa9c957810fb2e2ff253aaf2ac4
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed Dec 3 11:16:59 2008 +1100
> 
>     bitmap:find_last_bit

Also broke m68k (a bit more hidden due to other build failures).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
