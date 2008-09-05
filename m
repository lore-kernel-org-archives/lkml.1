Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYIEQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYIEQyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYIEQyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:54:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57882 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYIEQyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:54:10 -0400
Date: Fri, 5 Sep 2008 18:53:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alex Nixon <alex.nixon@citrix.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0/3] Fix Xen cpu hotplug build
Message-ID: <20080905165354.GA20572@elte.hu>
References: <48BE912F.7090809@citrix.com> <20080905154526.GG10292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905154526.GG10292@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alex Nixon <alex.nixon@citrix.com> wrote:
> 
> > This patch series contains various build fixes against the Xen cpu hotplug series currently in tip/x86/xen
> > 
> > Diff stats:
> > 
> >  arch/x86/kernel/cpu/common.c |    7 -------
> >  arch/x86/kernel/process_32.c |    7 +++++++
> >  arch/x86/kernel/process_64.c |    7 +++++++
> >  arch/x86/kernel/tlb_32.c     |    8 ++++++++
> >  drivers/xen/Makefile         |    3 ++-
> >  drivers/xen/cpu_hotplug.c    |    2 +-
> >  include/asm-x86/smp.h        |    9 ---------
> >  include/asm-x86/tlbflush.h   |   10 ++++++++++
> >  8 files changed, 35 insertions(+), 18 deletions(-)
> 
> applied to tip/x86/xen, thanks Alex!

fails to build with this config:

http://redhat.com/~mingo/misc/config-Fri_Sep__5_18_51_13_CEST_2008.bad

arch/x86/xen/built-in.o: In function `xen_play_dead':
(.text+0x576a): undefined reference to `play_dead_common'
arch/x86/xen/built-in.o: In function `xen_cpu_disable':
(.text+0x57b1): undefined reference to `cpu_disable_common'

	Ingo
