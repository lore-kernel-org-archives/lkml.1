Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbYHRNU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYHRNU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYHRNUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:20:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYHRNUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:20:19 -0400
Date: Mon, 18 Aug 2008 10:16:56 -0300
From: Glauber Costa <gcosta@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT PULL] new shot at time.c integration
Message-ID: <20080818131656.GA13914@poweredge.glommer>
References: <200808151625.m7FGP3Gn027609@int-mx1.corp.redhat.com> <20080815165134.GB29956@elte.hu> <20080816151900.GA27040@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816151900.GA27040@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 05:19:00PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Ingo, please pull the latest master git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> > > 
> > > into your tree
> > > 
> > > It is based on your tip/master branch.
> > 
> > thanks, i've pulled it and rebased it to -git - as that's the best 
> > base this early in the cycle. I've pushed out the result into 
> > tip/x86/time - havent integrated it into tip/master yet.
> 
> have just tried a test-merge, and got a few crashes during -tip testing. 
> One is a hard lockup during bootup, with this config:
> 
>   http://redhat.com/~mingo/misc/config-Sat_Aug_16_16_49_05_CEST_2008.bad
> 
> no console output. I've pushed out this integrated tree into 
> tip/x86/time.broken: note that i had to do a few manual merges due to 
> the io_apic.c unification - maybe that interacted.
> 
> there's a 32-bit failure as well:
> 
>   http://redhat.com/~mingo/misc/config-Sat_Aug_16_15_51_57_CEST_2008.bad
> 
> i dont know anything about that, other that it didnt boot up after 
> x86/time integration.
> 
ok ingo. Will look at that ASAP.

> 	Ingo
