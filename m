Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZGAIlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZGAIlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZGAIkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:40:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52572 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZGAIkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:40:51 -0400
Date: Wed, 1 Jul 2009 10:40:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       xen-devel@lists.xensource.com
Subject: Re: WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem
Message-ID: <20090701084044.GB8171@elte.hu>
References: <alpine.DEB.2.01.0906291950280.6439@bogon> <1246351243.8014.14.camel@penberg-laptop> <4A4A7C9B.9060409@goop.org> <1246427909.22417.7.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246427909.22417.7.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Jeremy,
> 
> On Tue, 2009-06-30 at 13:59 -0700, Jeremy Fitzhardinge wrote:
> > > >From dc231c59194a973b80e6932bb4c162f2076635cb Mon Sep 17 00:00:00 2001
> > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > > Date: Tue, 30 Jun 2009 11:35:19 +0300
> > > Subject: [PATCH] xen: Use kcalloc() in xen_init_IRQ()
> > >
> > > The init_IRQ() function is now called with slab allocator initialized.
> > > Therefore, we must not use the bootmem allocator in xen_init_IRQ().
> > > Fixes the following boot-time warning:
> > >
> > >   [    0.000000] Linux version 2.6.30 (dummy@sid) (gcc version 4.4.0 (Debian 4.4.0-8) ) #1 Tue Jun 23 02:13:42 CEST 2009
> > >   [    0.000000] Command line: root=/dev/xvda1 console=hvc0 init=/sbin/init
> > >   [    0.000000] KERNEL supported cpus:
> > >   [    0.000000]   Intel GenuineIntel
> > >   [    0.000000]   AMD AuthenticAMD
> > >   [    0.000000]   Centaur CentaurHauls
> > >   [    0.000000] BIOS-provided physical RAM map:
> > >   [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
> > >   [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
> > >   [    0.000000]  Xen: 0000000000100000 - 0000000008000000 (usable)
> > >   [    0.000000] DMI not present or invalid.
> > >   [    0.000000] last_pfn = 0x8000 max_arch_pfn = 0x400000000
> > >   [    0.000000] initial memory mapped : 0 - 20000000
> > >
> > > Reported-by: Christian Kujau <lists@nerdbynature.de>
> > > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Thanks! Who should pick this patch up, btw? I think it ought to go 
> to the xen subsystem tree (wherever that is).

Generally those fixes go via tip:x86/urgent - please send the patch 
with a full changelog, the signoff and acked-by lines, etc.

Thanks,

	Ingo
