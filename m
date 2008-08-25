Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYHYT1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYHYT1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYHYT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:27:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbYHYT1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:27:16 -0400
Subject: Re: [BUG] cpufreq: constant cpu_khz
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@codemonkey.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080825112244.34b2fe67@infradead.org>
References: <1219646032.20732.10.camel@twins>
	 <1219664106.8515.50.camel@twins> <20080825123926.GC8663@elte.hu>
	 <20080825175547.GA26131@codemonkey.org.uk> <20080825175712.GA10848@elte.hu>
	 <20080825112244.34b2fe67@infradead.org>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 21:27:10 +0200
Message-Id: <1219692430.8515.125.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 11:22 -0700, Arjan van de Ven wrote:
> On Mon, 25 Aug 2008 19:57:12 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Dave Jones <davej@codemonkey.org.uk> wrote:
> > 
> > >  > hm, that too is due to the tsc.c unification - Alok Cc:-ed.
> > >  > Applied your fix to x86/urgent.
> > > 
> > > ACKed-by: Dave Jones <davej@redhat.com>
> > > 
> > > Good catch Peter.  I'm puzzled how that bug was latent on 64bit for
> > > so long with no-one realising though.
> > 
> > i think it's the combination of these two factors:
> > 
> >  - bootup frequently is typically full-speed, so we calibrate things 
> >    right
> > 
> >  - cpufreq events are relatively slow-scale - and when they trigger
> > the system is definitely not under load. So how precisely the
> > scheduler functions isnt all that important in such scenarios -
> > there's tons of CPU power available.
> > 
> 
> - many many of the 64 bit capable cpus are constant-tsc anyway

Ironically I noticed it first on 64bit ;-)



