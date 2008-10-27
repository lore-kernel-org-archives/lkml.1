Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYJ0QYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYJ0QYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYJ0QYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:24:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYJ0QYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:24:12 -0400
Date: Mon, 27 Oct 2008 17:23:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/35] x86: clean up speedctep-centrino and reduce
	cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>
Message-ID: <20081027162330.GB19476@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020833.302361000@polaris-admin.engr.sgi.com> <200810231636.30722.rusty@rustcorp.com.au> <20081023120444.GD25132@elte.hu> <20081023151002.GA15886@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023151002.GA15886@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

> On Thu, Oct 23, 2008 at 02:04:44PM +0200, Ingo Molnar wrote:
>  > 
>  > * Rusty Russell <rusty@rustcorp.com.au> wrote:
>  > 
>  > > On Thursday 23 October 2008 13:09:01 Mike Travis wrote:
>  > > > 1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
>  > > > 2) The loop can simply skip over offline cpus, rather than creating a tmp
>  > > > mask.
>  > > > 3) set_mask is set to either a single cpu or all online cpus in a 
>  > > > policy. Since it's just used for set_cpus_allowed(), any offline cpus in a
>  > > > policy don't matter, so we can just use cpumask_of_cpu() or the
>  > > > policy->cpus.
>  > > 
>  > > Note that this cleanup stands alone; it's just that I read this code I 
>  > > couldn't help but tidy it up.
>  > > 
>  > > Ingo: do you just want to put this in your normal tree for sending to 
>  > > Linus?
>  > 
>  > hm, cpufreq stuff belongs into davej's tree.
>  > 
>  > i skipped #34 and #35 for now, we can live without them, correct?
> 
> If those patches are dependant upon the others, I can live with them 
> going through another tree.  There's nothing pending for 
> speedstep-centrino in cpufreq anyway.

ok - although the cleanups Rusty did look independent to me. We can 
just keep it in mind for the future, the whole topic is complex enough 
already as-is.

	Ingo
