Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZEKMGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZEKMGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZEKMFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:05:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZEKMFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:05:54 -0400
Date: Mon, 11 May 2009 14:05:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
	X86_FEATURE_ARCH_PERFMON flag for AMD cpus
Message-ID: <20090511120514.GA13954@elte.hu>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com> <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org> <1241931753.4796.15.camel@localhost.localdomain> <1241934795.4796.55.camel@localhost.localdomain> <20090510063047.GD30778@elte.hu> <1241938310.4796.67.camel@localhost.localdomain> <20090511100226.GA31041@elte.hu> <1242037652.3114.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242037652.3114.6.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Mon, 2009-05-11 at 12:02 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > There is one more way to check performance monitor support for 
> > > Intel by using IA32_MISC_ENABLE MSR (0x1A0) bit 7 tells whether 
> > > performance monitoring is available or not.
> > > 
> > > But IA32_MISC_ENABLE MSR (0x1A0) is not available for Pentium and 
> > > P6.
> > > 
> > > So better I will add new cpufeature for performance monitoring for 
> > > x86:
> > > 
> > > X86_FEATURE_PERFMON : Performance monitor support
> > 
> > What is the exact wording of IA32_MISC_ENABLE bit 7 in the Intel 
> > documents?
> > 
> 
> Bit 7: Performance Monitoring Available. (R)
>        1 = Performance monitoring enabled
>        0 = Performance monitoring disabled

i guess, if 'perfmon' is not used yet ('arch_perfmon' is), we could 
add this as a separate, new cpu features flag.

Although the confusion factor is high ...

	Ingo
