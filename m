Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZAGNdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZAGNdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbZAGNc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:32:57 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:54023 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZAGNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:32:56 -0500
Date: Wed, 7 Jan 2009 14:34:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, kosaki.motohiro@jp.fujitsu.com,
       yinghai@kernel.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, tglx@linutronix.de
Subject: Re: irqnr fallout in gpiolib on sparc32
Message-ID: <20090107133436.GB2289@uranus.ravnborg.org>
References: <20090105135508.GB4190@elte.hu> <20090105.123734.137888898.davem@davemloft.net> <20090106125704.GC20407@elte.hu> <20090106.082913.97432854.davem@davemloft.net> <20090107130213.GB3529@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107130213.GB3529@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 02:02:13PM +0100, Ingo Molnar wrote:
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 6 Jan 2009 13:57:04 +0100
> > 
> > > Sparc32 on the other hand had a clean IRQ layer long before x86 found its 
> > > desire for a clean genirq layer - so genirq is a nuisance for Sparc32 at 
> > > best and it deserves none of the not nice actions. What i am hoping for is 
> > > that perhaps the Sparc unification changed that equation.
> > 
> > Not really, the unificiation didn't change much in this area. [...]
> 
> Yeah, i mean - "changed the equation" psychologically, the same way it did 
> it on x86.
> 
> There's now two files close to each other in the namespace:
> 
>  earth4:~/tip> ls -l arch/sparc/kernel/irq*.c
>  -rw-rw-r-- 1 mingo mingo 16122 2009-01-07 13:50 arch/sparc/kernel/irq_32.c
>  -rw-rw-r-- 1 mingo mingo 26556 2009-01-07 12:34 arch/sparc/kernel/irq_64.c
> 
> Each of them crying out loud to be unified. Every time you open irq_64.c 
> you'll think "why that ugly _64.c postfix, shouldnt this be irq.c 
> instead?" ;-)
> 
> That kind of gentle pressure to unify comes straight from the fact that 
> there's _32.c and _64.c postfixes around and the postfixes mess up command 
> completion when those files are opened, so we notice the non-unified-ness 
> again and again.

I most remind you how you eat an elephant ;-)
You eat it bite by bite.
And you start with the easy bits first to harden your stommach.

Try to do a:
git shortlog --since=2-months arch/sparc/

I for one is very happy with what we have achieved so far.

irq_* unification will come when we reach that part.

	Sam
