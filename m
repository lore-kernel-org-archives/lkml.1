Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYH1JIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYH1JIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYH1JIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:08:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYH1JIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:08:22 -0400
Date: Thu, 28 Aug 2008 11:08:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 27
Message-ID: <20080828090802.GE19422@elte.hu>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808271206.48370.bzolnier@gmail.com> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wed, Aug 27, 2008 at 12:06 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >
> > Hi,
> >
> > On Wednesday 27 August 2008, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> Changes since next-20080826:
> >
> > it fails to build here with:
> >
> > arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extended_topology':
> > arch/x86/kernel/cpu/addon_cpuid_features.c:119: error: 'struct cpuinfo_x86' hasno member named 'cpu_core_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:121: error: 'struct cpuinfo_x86' hasno member named 'phys_proc_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:130: error: 'struct cpuinfo_x86' hasno member named 'phys_proc_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:133: error: 'struct cpuinfo_x86' hasno member named 'cpu_core_id'
> > make[2]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> > make[1]: *** [arch/x86/kernel/cpu] Error 2
> > make: *** [arch/x86/kernel] Error 2
> 
> which is most likely already fixed in x86 tree by
> 
> http://lkml.org/lkml/2008/8/27/34

ok, i've propagated those commits to auto-x86-next as well, so that 
linux-next is fixed too.

	Ingo
