Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYKFKWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYKFKWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYKFKWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:22:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36275 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYKFKWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:22:35 -0500
Date: Thu, 6 Nov 2008 11:22:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] change CONFIG_NUMA description
Message-ID: <20081106102218.GB4022@elte.hu>
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081106085301.GB4890@elte.hu> <84144f020811060215n25bf1e3ah5ad17e664b146764@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020811060215n25bf1e3ah5ad17e664b146764@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Thu, Nov 6, 2008 at 10:53 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > From fd51b2d7d5df932767b89e00d0871a38a2c53e74 Mon Sep 17 00:00:00 2001
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date: Wed, 5 Nov 2008 02:27:19 +0900
> > Subject: [PATCH] x86: update CONFIG_NUMA description
> >
> > Impact: clarify/update CONFIG_NUMA text
> >
> > CONFIG_NUMA description talk about a bit old thing.
> > So, following changes are better.
> >
> >  o CONFIG_NUMA is no longer EXPERIMENTAL
> >
> >  o Opteron is not the only processor of NUMA topology on x86_64 no longer,
> >   but also Intel Core7i has it.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/Kconfig |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 350bee1..38ae04b 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -951,22 +951,26 @@ config ARCH_PHYS_ADDR_T_64BIT
> >
> >  # Common NUMA Features
> >  config NUMA
> > -       bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
> > +       bool "Numa Memory Allocation and Scheduler Support"
> >        depends on SMP
> >        depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
> 
> Why does this depend on CONFIG_EXPERIMENTAL still?

Good point, i've just removed that too. 32-bit NUMA used to have 
stability problems (nobody really tested it systematically), but we've 
fixed those bugs and can now remove the restrictions in v2.6.29.

	Ingo
