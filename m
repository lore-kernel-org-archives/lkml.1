Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbXJWHTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbXJWHTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXJWHSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:18:53 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:44794 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXJWHSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:18:50 -0400
Date: Tue, 23 Oct 2007 09:18:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710230907370.7105@anakin>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
 <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
 <Pine.LNX.4.64.0710222137520.7105@anakin>
 <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
 <20071022211617.31f5c63d@the-village.bc.nu>
 <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
 <20071022224343.4abf3c96@the-village.bc.nu>
 <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Linus Torvalds wrote:
> On Mon, 22 Oct 2007, Alan Cox wrote:
> > For structures, not array elements or stack objects. Does gcc now get
> > aligned correct as an attribute on a stack object ?
> 
> I think m68k stack layout still guarantees 4-byte-alignment, no?

The stack pointer must be even (i.e. 2 byte-alignment).
But it looks like current gcc always allocates multiples of 4 bytes on
the stack, probably for performance reasons.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
