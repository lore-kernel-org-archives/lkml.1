Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYDUWcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYDUWcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYDUWcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:32:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57371 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbYDUWcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:32:04 -0400
Date: Tue, 22 Apr 2008 00:31:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421223142.GA18140@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <1208793533.3640.24.camel@localhost.localdomain> <20080421195148.GG8770@elte.hu> <20080421200949.GB2633@cs181133002.pp.htv.fi> <20080421201352.GM8770@elte.hu> <20080421202605.GC2633@cs181133002.pp.htv.fi> <20080421202919.GA28069@elte.hu> <20080421210232.GD2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421210232.GD2633@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Apr 21, 2008 at 10:29:19PM +0200, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Mon, Apr 21, 2008 at 10:13:52PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > > 
> > > > > > ok, that's good enough - that's why i excluded it from the 
> > > > > > auto-qa test-space as well. Adrian, could you please remove 
> > > > > > it from your config testset as well? If a user enables that 
> > > > > > config option it wont boot anyway so it's not a problem in 
> > > > > > practice.
> > > > > 
> > > > > Who said that Voyager won't boot?
> > > > 
> > > > Adrian, you build Voyager kernels so just try to boot it once on 
> > > > your PC and watch the show ...
> > > 
> > > Ingo, an ia64 kernel also won't boot on my computer, and I'll 
> > > still compile test my patches for ia64 ...
> > 
> > dont be silly... the ia64 kernel is not under arch/x86, it's not 
> > even the same instruction format. Voyager runs on x86 CPUs and is 
> > part of the x86 architecture tree.
> 
> Your point is?

my point is what i said and which you apparently did not understand:

| Adrian, could you please remove it from your config testset as well? 
| If a user enables that config option it wont boot anyway so it's not a 
| problem in practice.

> I'm compile testing 22 architectures (especially when sending my own 
> patches), and whether a kernel would boot on my computer doesn't make 
> any difference.

a user wont 'accidentally' install a crosscompiler toolchain to create 
an unbootable kernel...

	Ingo
