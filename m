Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYJWMFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYJWMFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYJWMFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:05:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYJWMFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:05:09 -0400
Date: Thu, 23 Oct 2008 14:04:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 35/35] x86: clean up speedctep-centrino and reduce
	cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>
Message-ID: <20081023120444.GD25132@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020833.302361000@polaris-admin.engr.sgi.com> <200810231636.30722.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810231636.30722.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 23 October 2008 13:09:01 Mike Travis wrote:
> > 1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
> > 2) The loop can simply skip over offline cpus, rather than creating a tmp
> > mask.
> > 3) set_mask is set to either a single cpu or all online cpus in a 
> > policy. Since it's just used for set_cpus_allowed(), any offline cpus in a
> > policy don't matter, so we can just use cpumask_of_cpu() or the
> > policy->cpus.
> 
> Note that this cleanup stands alone; it's just that I read this code I 
> couldn't help but tidy it up.
> 
> Ingo: do you just want to put this in your normal tree for sending to 
> Linus?

hm, cpufreq stuff belongs into davej's tree.

i skipped #34 and #35 for now, we can live without them, correct?

	Ingo
