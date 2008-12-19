Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYLSVmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYLSVmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYLSVmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:42:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYLSVmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:42:37 -0500
Date: Fri, 19 Dec 2008 22:42:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 19 (new
	CONFIG_NUMA_MIGRATE_IRQ_DESC option)
Message-ID: <20081219214221.GE2351@elte.hu>
References: <20081219235757.6b94d9ef.sfr@canb.auug.org.au> <200812192201.28665.bzolnier@gmail.com> <494C0D28.6040002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494C0D28.6040002@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> > +++ b/kernel/irq/numa_migrate.c
> > @@ -0,0 +1,127 @@
> > +/*
> > + * linux/kernel/irq/handle.c
> > + *
> > + * Copyright (C) 1992, 1998-2006 Linus Torvalds, Ingo Molnar
> > + * Copyright (C) 2005-2006, Thomas Gleixner, Russell King
> > + *
> > + * This file contains the core interrupt handling code.
> > + *
> > + * Detailed information is available in Documentation/DocBook/genericirq
> > + *
> > + */
> > 
> > hmmm? ;-)
> 
> seperated from irq/handle.c
> 
> oh, will remove those lines.

Yeah, replace them with something like:

/*
 * NUMA irq-desc migration code
 *
 * Migrate IRQ data structures (irq_desc, chip_data, etc.) over to
 * the new "home node" of the IRQ.
 */

	Ingo
