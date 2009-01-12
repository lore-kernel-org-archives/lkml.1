Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZALI0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZALI0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZALIZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:25:54 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:47633 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZALIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:25:54 -0500
Date: Mon, 12 Jan 2009 09:25:49 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] STAGING patches for 2.6-git
In-Reply-To: <20090106221129.GB32689@kroah.com>
Message-ID: <Pine.LNX.4.64.0901120924290.30201@anakin>
References: <20090106221129.GB32689@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, Greg KH wrote:
> 		- Comedi core and some drivers

which requires PAGE_KERNEL_NOCACHE, which is defined on 4 out of 22 architectures
only (x86, frv, m32r, mn10300).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
