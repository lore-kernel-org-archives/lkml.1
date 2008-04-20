Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYDTHnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYDTHnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 03:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYDTHmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 03:42:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48595 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYDTHmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 03:42:51 -0400
Date: Sun, 20 Apr 2008 10:42:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: x86: 4kstacks default
Message-ID: <20080420074228.GE1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com> <20080419151911.GB1595@cs181133002.pp.htv.fi> <480AA2B9.10305@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <480AA2B9.10305@sandeen.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 08:56:09PM -0500, Eric Sandeen wrote:
> Adrian Bunk wrote:
> > On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
> >> ...
> >> with the older kernel is typical: xfs+nfs+4k stack(+lvm)
> > 
> > Does anyone still experience problems with 2.6.25?
> 
> There are always problems.  You can always come up with something that
> will crash in 4k, IMHO.

We are going from 6k to 4k.

Your "You can always come up with something that will crash in" point 
would be invariant to this change (although it might be harder to 
trigger in real life).

> Rather than foisting this upon everyone, I'd rather see work put into
> making stack size a boot parameter or something, so that people can
> choose what's appropriate for their workload (or their IO stack, if you
> prefer).

Why should users have to poke with such deeply internal things?
That doesn't sound right.

Excessive stack usage in the kernel is considered to be a bug.

We should identify and fix all remaining problems (if any).

> -Eric

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

