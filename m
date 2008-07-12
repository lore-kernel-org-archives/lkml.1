Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYGLTcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYGLTcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 15:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYGLTcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 15:32:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:52434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYGLTcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 15:32:08 -0400
Date: Sat, 12 Jul 2008 12:31:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: linux-next: Tree for July 11
Message-ID: <20080712123149.7e4ee346@infradead.org>
In-Reply-To: <19f34abd0807121221n75fd7bb8x24fa484239773201@mail.gmail.com>
References: <20080711182557.9b24df1f.sfr@canb.auug.org.au>
	<200807122051.50909.rjw@sisk.pl>
	<19f34abd0807121221n75fd7bb8x24fa484239773201@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 21:21:38 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> >  [<ffffffff8023d37f>] warn_on_slowpath+0x5f/0x80
> >  [<ffffffff80220030>] ? hpet_unregister_irq_handler+0x0/0x30
> >  [<ffffffff8022a8ae>] ? kmemcheck_mark_initialized+0xe/0x10
> >  [<ffffffff802b97fb>] ? kmemcheck_slab_alloc+0x2b/0x50
> >  [<ffffffff802b8610>] ? kmem_cache_alloc+0xc0/0x140
> >  [<ffffffff80291921>] ? mempool_alloc_slab+0x11/0x20
> >  [<ffffffff80291a8b>] ? mempool_alloc+0x5b/0x140
> >  [<ffffffff803575db>] blk_plug_device+0x9b/0xb0
> >  [<ffffffff80453d9f>] bitmap_startwrite+0xbf/0x1b0
> >  [<ffffffff802e87e4>] ? bio_alloc_bioset+0x54/0xb0
> >  [<ffffffffa004eafa>] make_request+0x39a/0x810 [raid1]
> >  [<ffffffff80291a8b>] ? mempool_alloc+0x5b/0x140
> >  [<ffffffff80291a8b>] ? mempool_alloc+0x5b/0x140
> >  [<ffffffff8035682d>] generic_make_request+0x17d/0x2b0
> >  [<ffffffff803581dc>] submit_bio+0x6c/0xf0
> Hm, even though there's kmemcheck in the stacktrace, I think it's
> unrelated. Probably it's just a call that returned and the addresses
> were left on the stack. 

more than "probably".. that's what the "?" in the trace is for ;)
