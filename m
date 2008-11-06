Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYKFKSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYKFKSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbYKFKS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:18:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35625 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbYKFKS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:18:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] change CONFIG_NUMA description
Cc: kosaki.motohiro@jp.fujitsu.com, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <84144f020811060215n25bf1e3ah5ad17e664b146764@mail.gmail.com>
References: <20081106085301.GB4890@elte.hu> <84144f020811060215n25bf1e3ah5ad17e664b146764@mail.gmail.com>
Message-Id: <20081106191655.0D43.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  6 Nov 2008 19:18:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

sorry, late resoponce.
In fact, x86_32 numa is still experimental.
and x86_64 is already NOT experimental.

So, I think depend-on don't need change.


