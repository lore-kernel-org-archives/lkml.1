Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYGSVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYGSVsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYGSVsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:48:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbYGSVsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:48:03 -0400
Date: Sat, 19 Jul 2008 23:47:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080719214742.GB836@elte.hu>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl> <20080718105259.GY6875@elte.hu> <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com> <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com> <20080718210348.GB24373@elte.hu> <20080718225835.GC4507@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718225835.GC4507@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Fri, Jul 18, 2008 at 02:03:48PM -0700, Ingo Molnar wrote:
> > 
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > 
> > > > git merge tip/x86/x2apic
> > > CONFLICT (content): Merge conflict in arch/x86/kernel/Makefile
> > > CONFLICT (content): Merge conflict in arch/x86/kernel/paravirt.c
> > > CONFLICT (content): Merge conflict in arch/x86/kernel/smpboot.c
> > > CONFLICT (content): Merge conflict in arch/x86/kernel/vmi_32.c
> > > CONFLICT (content): Merge conflict in arch/x86/xen/enlighten.c
> > > CONFLICT (content): Merge conflict in include/asm-x86/apic.h
> > > CONFLICT (content): Merge conflict in include/asm-x86/paravirt.h
> > 
> > that's due to the changes in tip/x86/apic and in tip/x86/uv.
> > 
> > ok, i've just merged x86/apic into x86/x2apic and x86/uv as well, and
> > pushed out the result.
> > 
> > Note: it's a first raw merge and completely untested. It will now merge
> > cleanly into tip/master. There are probably a few details missing.
> 
> Ingo, thanks for doing this. While I was testing my merge changes, you 
> posted yours... anyhow we need this piece, which is missing from your 
> merge.

thanks, applied and pushed out. Could you check whether the latest 
tip/x86/x2apic code, when git-merge-ed into tip/master, is sane on your 
box(en)?

	Ingo
