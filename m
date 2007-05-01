Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXEAQ6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXEAQ6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXEAQ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:58:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834AbXEAQ6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:58:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0705011820180.27246@anakin> 
References: <Pine.LNX.4.64.0705011820180.27246@anakin>  <Pine.LNX.4.64.0705011734410.27246@anakin> <200704271707.l3RH7H5Z032671@hera.kernel.org> <9374.1178036083@redhat.com> 
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC. 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 01 May 2007 17:58:35 +0100
Message-ID: <10918.1178038715@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On architectures that #define WANT_PAGE_VIRTUAL (frv/m68k/mips/extensa),
> page_address(page) expands to (page)->virtual, which fails if page is a
> void *.

On FRV, kmap_atomic() should always be an inline function (I wrote it:-):

	static inline void *kmap_atomic(struct page *page, enum km_type type)
	{
	...
	}

David
