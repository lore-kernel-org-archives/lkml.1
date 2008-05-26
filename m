Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbYEZOrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbYEZOrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbYEZOqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:46:53 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:46778 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYEZOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:46:52 -0400
Date: Mon, 26 May 2008 16:46:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: drivers/char/dsp56k.c breakage [was: Re: linux-next: Tree for May
 26]
In-Reply-To: <20080526172222.b6979523.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0805261644230.4417@anakin>
References: <20080526172222.b6979523.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

commit	6fe28df6c14e7e02bfea6b2bebf42716176e6dff

    dsp56k: BKL pushdown

    Put explicit lock_kernel calls into dsp56k_open().

Broke the build of drivers/char/dsp56k.c by introducing a jump to a
non-existent label

http://kisskb.ellerman.id.au/kisskb/buildresult/29211/

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
