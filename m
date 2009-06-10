Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbZFJU6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbZFJU6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZFJU6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:58:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbZFJU6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:58:04 -0400
Date: Wed, 10 Jun 2009 22:57:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
Message-ID: <20090610205749.GA9321@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <4A3017D1.5010708@cs.helsinki.fi> <20090610204318.GA8147@elte.hu> <84144f020906101347y3e250f4bme2d1c60dd5993ffc@mail.gmail.com> <20090610205026.GC8147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610205026.GC8147@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > What kind of conflicts are there against -tip? The diffstat 
> > > suggests it's mostly in-SLAB code, right? There shouldnt be 
> > > much to conflict, except kmemcheck - which has more or less 
> > > trivial callbacks there.
> > 
> > The conflicting bits are the patches that remove bootmem 
> > allocator uses in arch/x86 and kernel/sched.c.
> 
> Give me an hour and i'll get some minimal testing done.

This tree doesnt conflict (not even with kmecheck) - and the older 
bits you sent against the scheduler and against x86 doesnt apply 
anymore - but they do look scary.

How about this: i can send the scheduler and x86 bits to Linus right 
now, that should make it possible to have a clean base for you and 
no interactions with anything pending?

	Ingo
