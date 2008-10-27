Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYJ0VGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYJ0VGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYJ0VGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:06:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:39432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0VGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:06:23 -0400
Date: Mon, 27 Oct 2008 14:06:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
 optimization
Message-ID: <20081027140630.521f933d@infradead.org>
In-Reply-To: <y0m3aihx1kd.fsf@ton.toronto.redhat.com>
References: <20081006102640.481acd23@infradead.org>
	<20081027155920.GS5704@elte.hu>
	<20081027110522.6cb7b142@infradead.org>
	<y0m3aihx1kd.fsf@ton.toronto.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 15:47:30 -0400
fche@redhat.com (Frank Ch. Eigler) wrote:

> 
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > [...]
> > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > [...]
> > @@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct
> > cpufreq_policy *policy, }
> >  	}
> >  
> > +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> > +
> >  	switch (data->cpu_feature) {
> >  	case SYSTEM_INTEL_MSR_CAPABLE:
> >  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> > [...]
> 
> Is there some reason that this doesn't use tracepoints instead
> of such a single-backend hook?

because it's a ton simpler this way? do simple things simpe and all
that....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
