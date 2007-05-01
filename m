Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXEAQOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXEAQOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXEAQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:14:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbXEAQOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:14:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0705011734410.27246@anakin> 
References: <Pine.LNX.4.64.0705011734410.27246@anakin>  <200704271707.l3RH7H5Z032671@hera.kernel.org> 
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC. 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 01 May 2007 17:14:43 +0100
Message-ID: <9374.1178036083@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> This causes a compile failure on m68k:

Hmmm... I couldn't actually test m68k as I couldn't get it to compile.  Can
you give me a good config I can use as a base?

> | linux/fs/afs/fsclient.c: In function 'afs_deliver_fs_fetch_data':
> | linux/fs/afs/fsclient.c:269: warning: dereferencing 'void *' pointer
> | linux/fs/afs/fsclient.c:269: error: request for member 'virtual' in something not a structure or union

Ummm...  Maybe m68k kmap_atomic() should cast it...  I think everywhere else
it must be an inline function or something.

However, I'll subsume your patch into mine if you don't mind.

David
