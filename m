Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbXJQHlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbXJQHlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJQHk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:40:58 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:41137 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbXJQHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:40:57 -0400
Date: Wed, 17 Oct 2007 09:40:52 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Brownell <david-b@pacbell.net>
Cc: viro@ftp.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] missing include in mmc
In-Reply-To: <20071017032139.17D6323A687@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Message-ID: <Pine.LNX.4.64.0710170937290.29643@anakin>
References: <20071017000907.GF8181@ftp.linux.org.uk>
 <20071017002551.3577B23B309@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071017020445.GG8181@ftp.linux.org.uk>
 <20071017032139.17D6323A687@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, David Brownell wrote:
> > > > AFAICS, fallout from repacing include of blkdev.h with include of bio.h.
> > > 
> > > Out of curiousity, which architecture(s) need this?
> >
> > Umm...   IIRC, m32r had been the first build to step into that, at which point
> > the missing include had been added; the rest had reached that point later, so
> > I'm not sure which ones would trigger the same crap.  Not hard to test,
> > though...
> >
> > Aha.  m68k as well.

Yesterday I saw a similar issue with drivers/md/dm-mpath-rdac.c, but it
disappeared during the night, and I didn't see an obvious change that
fixed it...

> Every time I seee a case where architectures don't act the same
> with respect to #includes, I count it as an unpleasant surprise.
> Not one that's very easy to avoid, unfortunately, but I think it's
> been happening less often lately.

Simple rule of thumb: he who uses fields of struct xxx should include
the header file that defines struct xxx...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
