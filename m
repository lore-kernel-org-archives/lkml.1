Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZFLHwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZFLHwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761769AbZFLHv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:51:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759765AbZFLHv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:51:57 -0400
Date: Fri, 12 Jun 2009 09:51:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mpm@selenic.com, npiggin@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com
Subject: Re: [GIT PULL v3] Early boot SLAB for 2.6.31
Message-ID: <20090612075127.GA32755@elte.hu>
References: <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110954030.29827@gentwo.org> <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com> <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com> <4A3143E3.3090705@kernel.org> <Pine.LNX.4.64.0906112101020.21593@melkki.cs.Helsinki.FI> <20090611214342.GA12762@elte.hu> <20090611220307.GA16180@elte.hu> <20090612071703.GA29679@elte.hu> <1244791788.30512.2.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244791788.30512.2.camel@penberg-laptop>
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

> Hi Ingo,
> 
> On Fri, 2009-06-12 at 09:17 +0200, Ingo Molnar wrote:
> > Plus i quickly got this crash too:
> > 
> > [    0.000000] console [tty0] enabled
> > [    0.000000] allocation of page_cgroup was failed.
> > [    0.000000] please try cgroup_disable=memory boot option
> > [    0.000000] Kernel panic - not syncing: Out of memory
> > [    0.000000] Rebooting in 1 seconds..<1>BUG: unable to handle kernel NULL pointer dereference at 0000004c
> > [    0.000000] IP: [<c16ec708>] klist_next+0x10/0x8f
> > [    0.000000] *pdpt = 0000000001a8a001 *pde = 0000000000000000 
> > [    0.000000] Thread overran stack, or stack corrupted
> 
> Hmm, does this patch fix it? [...]

Thanks, this fixed it.

	Ingo
