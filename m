Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYGYHdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYGYHdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYGYHdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:33:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYGYHdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:33:02 -0400
Date: Fri, 25 Jul 2008 09:32:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: benh@kernel.crashing.org, Michael Brown <mbrown@fensystems.co.uk>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sfx.c driver build failure
Message-ID: <20080725073225.GB21824@elte.hu>
References: <1216966559.11188.85.camel@pasglop> <20080725171715.9287c823.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080725171715.9287c823.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Fri, 25 Jul 2008 16:15:59 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> > The sfx driver (which happens to be part of some of our test configs)
> > fails to build in current Linus tree on powerpc with this error:
> > 
> > /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c: In function ‘efx_probe_interrupts’:
> > /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c:845: error: lvalue required as unary ‘&’ operand
> 
> Commit 695a6b456307455a10059512208e8ed0d376ecd3 "topology: work around 
> topology_core_siblings() breakage" in linux-next (from the cpus4096 
> tree) comments out the offending lines ...  With the comment "the 
> topology API is a mess right now".

there's a patch from Mike Travis that solves it all from grounds up and 
which approach has the ack of Rusty as well, but it's not fully tested 
through yet - i will get to it later today.

	Ingo
