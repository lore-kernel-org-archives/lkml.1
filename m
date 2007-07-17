Return-Path: <linux-kernel-owner+w=401wt.eu-S1764979AbXGQLny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764979AbXGQLny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbXGQLnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:43:47 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:52832 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbXGQLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:43:46 -0400
Date: Tue, 17 Jul 2007 13:43:43 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Hardlink Pitfalls (was: Patches for REALLY TINY 386 kernels)
In-Reply-To: <200707161722.53203.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0707171341420.10600@anakin>
References: <200707161722.53203.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Al Boldi wrote:
> Satyam Sharma wrote:
> > Or just "cp -al" to create multiple trees at (almost) no disk cost
> > that won't interfere with each other in any way, and makes the
> > development process / generating patchsets trifle easier as well ...
> 
> That would be correct if hardlinks would actually do a CoW on modify, instead 
> of misleading the user into thinking he is modifying an independent file.
> 
> Moral of the story:  try to avoid hardlinks as much as possible!

Or use a different user account.

I used to have `all' Linux kernel source trees hardlinked where possible, as
special user `src'. So I could create a `cp -rl' copy under my own account and
get an error when trying to modify a file.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
