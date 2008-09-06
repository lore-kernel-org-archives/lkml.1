Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYIFQl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYIFQl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYIFQlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:41:20 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:48044 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYIFQlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:41:19 -0400
Date: Sat, 6 Sep 2008 18:41:17 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Buesch <mb@bu3sch.de>, Stefano Brivio <stefano.brivio@polimi.it>
cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: b43 build error on m68k (was: Re: linux-next: Tree for September 5)
In-Reply-To: <20080905190941.0f86ebac.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0809061837400.4138@anakin>
References: <20080905190941.0f86ebac.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

http://kisskb.ellerman.id.au/kisskb/buildresult/45949/:

| drivers/net/wireless/b43/phy_g.c:388: error: implicit declaration of function 'mmiowb'
| distcc[4257] ERROR: compile drivers/net/wireless/b43/phy_g.c on localhost failed
| make[5]: *** [drivers/net/wireless/b43/phy_g.o] Error 1

Missing #include <asm/io.h>?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
