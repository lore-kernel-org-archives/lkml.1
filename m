Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYHVDwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYHVDwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYHVDwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:52:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYHVDwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:52:01 -0400
Date: Fri, 22 Aug 2008 05:51:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822035144.GC30284@elte.hu>
References: <bug-11388-27@http.bugzilla.kernel.org/> <20080820180405.7f164450.akpm@linux-foundation.org> <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com> <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com> <20080821114430.GC30667@elte.hu> <20080821115642.GA2270@elte.hu> <86802c440808210839u452d9440kd7d12694db515411@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808210839u452d9440kd7d12694db515411@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Thu, Aug 21, 2008 at 4:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >>
> >> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >>
> >> > [PATCH] x86_64: printout msr
> >>
> >> looks rather useful - added it to tip/x86/debug.
> >
> > fails to build with the attached config:
> >
> > arch/x86/kernel/cpu/common_64.c: In function 'print_cpu_msr':
> > arch/x86/kernel/cpu/common_64.c:456: error: implicit declaration of function 'rdmsrl_amd_safe'
> > arch/x86/kernel/cpu/common_64.c: In function 'print_cpu_info':
> > arch/x86/kernel/cpu/common_64.c:486: error: 'struct cpuinfo_x86' has no member named 'cpu_index'
> >
> > i realize that this wasnt sent for inclusion, but i think it would make
> > sense to tidy it up and integrate it.
> 
> that was one tool to verify if BIOS does right thing about some special bits.
> 
> it seems it doesn't compile when xen etc is enable in config.

yeah - but would be nice to fix it, as it's a useful diagnostic patch. 
If people have similar problems in the future they can boot their distro 
kernels with show_mtrr=x to get a MTRR dump.

	Ingo
