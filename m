Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXEARwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXEARwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbXEARwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:52:55 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:51595 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbXEARwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:52:54 -0400
Date: Tue, 1 May 2007 19:52:52 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC. 
In-Reply-To: <10918.1178038715@redhat.com>
Message-ID: <Pine.LNX.4.64.0705011951520.27246@anakin>
References: <Pine.LNX.4.64.0705011820180.27246@anakin>
 <Pine.LNX.4.64.0705011734410.27246@anakin> <200704271707.l3RH7H5Z032671@hera.kernel.org>
 <9374.1178036083@redhat.com>  <10918.1178038715@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, David Howells wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On architectures that #define WANT_PAGE_VIRTUAL (frv/m68k/mips/extensa),
> > page_address(page) expands to (page)->virtual, which fails if page is a
> > void *.
> 
> On FRV, kmap_atomic() should always be an inline function (I wrote it:-):
> 
> 	static inline void *kmap_atomic(struct page *page, enum km_type type)
> 	{
> 	...
> 	}
> 
> David

That's why I was actually surprised to find out frv has WANT_PAGE_VIRTUAL...

However, upon a closer look, have you tried without CONFIG_HIGHMEM? ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
