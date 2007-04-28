Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXD1JvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXD1JvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXD1JvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:51:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:37081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXD1JvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:51:09 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 28 Apr 2007 12:48:55 +0200
In-Reply-To: <20070427221803.2a117c23.akpm@linux-foundation.org>
Message-ID: <p73tzv022qw.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> box:/usr/src/25> ~/checkpatch.pl patches/slub-core.patch
> Checking patches/slub-core.patch:  signoffs = 30        
> Use WARN_ON & Recovery code rather than BUG() and BUG_ON()

The warning is bogus imho. How do you write recovery code for internal
broken code logic? 

-Andi


> 1588:+  VM_BUG_ON(!irqs_disabled());
> 1834:+  BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
> 2538:+  BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
> 2544:+  BUG_ON(!page);
> 2546:+  BUG_ON(!n);
> 2736:+          BUG_ON(err);
> 2762:+  BUG_ON(flags & SLUB_UNIMPLEMENTED);
> 2777:+          BUG_ON(flags & (SLAB_RED_ZONE | SLAB_POISON |
> 2779:+          BUG_ON(ctor || dtor);
> 3054:+  BUG_ON(index < 0);
> 3118:+  BUG_ON(!page);
> 3120:+  BUG_ON(!s);
> 4062:+  BUG_ON(!name);
> 4083:+  BUG_ON(p > name + ID_STR_LENGTH - 1);
> 4188:+          BUG_ON(err);
> 
