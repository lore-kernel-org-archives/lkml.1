Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYJ1KEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYJ1KEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJ1KEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:04:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58487 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYJ1KEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:04:22 -0400
Date: Tue, 28 Oct 2008 11:04:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
	optimization
Message-ID: <20081028100403.GC15734@elte.hu>
References: <20081006102640.481acd23@infradead.org> <20081027155920.GS5704@elte.hu> <20081027110522.6cb7b142@infradead.org> <y0m3aihx1kd.fsf@ton.toronto.redhat.com> <20081027140630.521f933d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027140630.521f933d@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 27 Oct 2008 15:47:30 -0400
> fche@redhat.com (Frank Ch. Eigler) wrote:
> 
> > 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > [...]
> > > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > [...]
> > > @@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct
> > > cpufreq_policy *policy, }
> > >  	}
> > >  
> > > +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> > > +
> > >  	switch (data->cpu_feature) {
> > >  	case SYSTEM_INTEL_MSR_CAPABLE:
> > >  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> > > [...]
> > 
> > Is there some reason that this doesn't use tracepoints instead
> > of such a single-backend hook?
> 
> because it's a ton simpler this way? do simple things simpe and all 
> that....

correct.

	Ingo
