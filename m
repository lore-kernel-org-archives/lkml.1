Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbZFJVAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbZFJVAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbZFJVAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:00:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55966 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbZFJVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:00:15 -0400
Date: Thu, 11 Jun 2009 00:00:16 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
In-Reply-To: <20090610205026.GC8147@elte.hu>
Message-ID: <Pine.LNX.4.64.0906102357370.30933@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
 <4A3017D1.5010708@cs.helsinki.fi> <20090610204318.GA8147@elte.hu>
 <84144f020906101347y3e250f4bme2d1c60dd5993ffc@mail.gmail.com>
 <20090610205026.GC8147@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Ingo Molnar wrote:
> > > What kind of conflicts are there against -tip? The diffstat 
> > > suggests it's mostly in-SLAB code, right? There shouldnt be much 
> > > to conflict, except kmemcheck - which has more or less trivial 
> > > callbacks there.
> > 
> > The conflicting bits are the patches that remove bootmem allocator 
> > uses in arch/x86 and kernel/sched.c.
> 
> Give me an hour and i'll get some minimal testing done.

Thanks! By the time you're done, I am hopefully in deep sleep (stupid 
time-zones!) dreaming of better kernels. So I won't be able to send a new 
pull request until tomorrow morning. All the patches are in 'for-linus' 
and 'topic/slab/earlyboot' branches and so -tip ones (that are not rebased 
on top of this series) in 'topic/slab/earlyboot-topic' in case you're 
interested.

			Pekka
