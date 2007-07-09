Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXGIRx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXGIRx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGIRxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:53:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:65050 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbXGIRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:53:46 -0400
Subject: Re: [PATCH] Two trivial whitespace fixes in lockdep/spinlock code
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070703171606.fb027c2b.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0707040213340.11634@jikos.suse.cz>
	 <20070703171606.fb027c2b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 10:45:46 -0700
Message-Id: <1184003146.2453.29.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 17:16 -0700, Andrew Morton wrote:
> On Wed, 4 Jul 2007 02:14:42 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > Two trivial whitespace fixes in lockdep/spinlock code
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > index 1a5ff22..12ca5fd 100644
> > --- a/kernel/lockdep.c
> > +++ b/kernel/lockdep.c
> > @@ -1222,7 +1222,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
> >  
> >  	/*
> >  	 * Debug-check: all keys must be persistent!
> > - 	 */
> > +	 */
> >  	if (!static_obj(lock->key)) {
> >  		debug_locks_off();
> >  		printk("INFO: trying to register non-static key.\n");
> > diff --git a/kernel/spinlock.c b/kernel/spinlock.c
> > index 2c6c2bf..5386d7e 100644
> > --- a/kernel/spinlock.c
> > +++ b/kernel/spinlock.c
> > @@ -28,7 +28,7 @@ int __lockfunc _spin_trylock(spinlock_t *lock)
> >  		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
> >  		return 1;
> >  	}
> > -	
> > +
> >  	preempt_enable();
> >  	return 0;
> >  }
> 
> Too trivial, sorry: we could generate 8 million patches like this.

Would you rather have one big patch that fixes a lot of this type of
stuff, or not have these types of patches at all ?

Daniel

