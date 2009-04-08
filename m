Return-Path: <linux-kernel-owner+w=401wt.eu-S1765406AbZDHNKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765406AbZDHNKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765436AbZDHNGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:06:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765315AbZDHNGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:06:14 -0400
Date: Wed, 8 Apr 2009 15:05:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] build fix for generic debug pagealloc
Message-ID: <20090408130510.GM18581@elte.hu>
References: <a4423d670904020421k7395e11dwe70d4223cb817e0a@mail.gmail.com> <20090402094522.b29004c8.akpm@linux-foundation.org> <20090403164450.GC3047@elte.hu> <200904032238.55438.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904032238.55438.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Friday 03 April 2009, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > +config DEBUG_PAGEALLOC
> > > > +	bool "Debug page memory allocations"
> > > > +	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
> > > > +	depends on !HIBERNATION || !PPC && !SPARC
> > > > +	---help---
> > > > +	  Unmap pages from the kernel linear mapping after free_pages().
> > > > +	  This results in a large slowdown, but helps to find certain types
> > > > +	  of memory corruptions.
> > > > +
> > > 
> > > I guess this is why it wasn't discovered in my compile testing.  
> > > It's quite regrettable that `make allmodconfig' didn't enable the 
> > > feature. That's what allmodconfig is for.
> > 
> > Hm, i _do_ remember some hibernation magic fix from Rafael, in the 
> > area of debugalloc. Many months ago.
> > 
> > Rafael, is it supposed to work? If yes, i think we should unblock 
> > it.
> 
> Yes, it is, at least on x86.
> 
> ISTR using DEBUG_PAGEALLOC with hibernation quite some time ago 
> already.

Could you please send a patch to Andrew then to remove the above 
dependency?

	Ingo
