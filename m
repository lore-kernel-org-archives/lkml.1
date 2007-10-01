Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbXJAJdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbXJAJdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbXJAJdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:33:05 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:53752 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbXJAJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:33:03 -0400
Date: Mon, 1 Oct 2007 11:33:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roel <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] removes array_size duplicates
In-Reply-To: <20071001022653.40bd5714.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710011132470.20679@anakin>
References: <46FC33E1.8010309@tiscali.nl> <20071001022653.40bd5714.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andrew Morton wrote:
> On Fri, 28 Sep 2007 00:51:13 +0200 roel <12o3l@tiscali.nl> wrote:
> > This patch removes some ARRAY_SIZE macro duplicates. There is also one in
> > arch/um/include/user.h, which isn't fixed here because comments in that file
> > explicitly state a preference for the 'less fancy' version. If that's the
> > case as well for any of the other replacements please comment.
> 
> I got a bunch of rejects against various development trees, a 
> build error in net/ipv4/ipvs/ip_vs_proto_udp.c and now
> 
> net/netfilter/xt_sctp.c: In function 'match_packet':
> net/netfilter/xt_sctp.c:58: error: size of array 'type name' is negative
> net/netfilter/xt_sctp.c:106: error: size of array 'type name' is negative

However, arch/m68k/amiga/amisound.c:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
