Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbXEYKeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbXEYKeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXEYKeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:34:09 -0400
Received: from mail.suse.de ([195.135.220.2]:55931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbXEYKeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:34:08 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Paprocki <andrew.m.paprocki@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 amd64 slab allocator bug reported at boot time
References: <76366b180705231851k42eba520jb07113a669c1e598@mail.gmail.com>
	<46556C85.8050204@s5r6.in-berlin.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 May 2007 13:30:59 +0200
In-Reply-To: <46556C85.8050204@s5r6.in-berlin.de>
Message-ID: <p73bqg9cf7w.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> Andrew Paprocki wrote:
> ...
> > BUG: at /usr/src/linux-2.6.22-rc2/mm/slab.c:777 __find_general_cachep()
> > 
> > Call Trace:
> >  [<ffffffff802743dc>] __kmalloc+0x3e/0xbe
> >  [<ffffffff8021d65f>] cache_k8_northbridges+0x7f/0xf0
> >  [<ffffffff8052bb53>] gart_iommu_init+0x13/0x4f8
> >  [<ffffffff802d15e1>] kobject_shadow_add+0xef/0x1a2
> >  [<ffffffff802d13fb>] kobject_get+0x12/0x17
> >  [<ffffffff8033b2a4>] class_register+0x10a/0x13d
> >  [<ffffffff80527964>] pci_iommu_init+0x9/0x12
> ...
> 
> This is a known "zero allocation" problem, patch available.
> http://kernelnewbies.org/known_regressions#line-249

It should be already fixed in mainline

-Andi
