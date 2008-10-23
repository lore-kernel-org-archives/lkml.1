Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbYJWPHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbYJWPHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYJWPGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:06:20 -0400
Received: from ozlabs.org ([203.10.76.45]:37630 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYJWPGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:06:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 35/35] x86: clean up speedctep-centrino and reduce cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 24 Oct 2008 02:06:22 +1100
User-Agent: KMail/1.9.10
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <200810231636.30722.rusty@rustcorp.com.au> <20081023120444.GD25132@elte.hu>
In-Reply-To: <20081023120444.GD25132@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240206.22933.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 23:04:44 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Thursday 23 October 2008 13:09:01 Mike Travis wrote:
> > > 1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
> > > 2) The loop can simply skip over offline cpus, rather than creating a
> > > tmp mask.
> > > 3) set_mask is set to either a single cpu or all online cpus in a
> > > policy. Since it's just used for set_cpus_allowed(), any offline cpus
> > > in a policy don't matter, so we can just use cpumask_of_cpu() or the
> > > policy->cpus.
> >
> > Note that this cleanup stands alone; it's just that I read this code I
> > couldn't help but tidy it up.
> >
> > Ingo: do you just want to put this in your normal tree for sending to
> > Linus?
>
> hm, cpufreq stuff belongs into davej's tree.
>
> i skipped #34 and #35 for now, we can live without them, correct?

Definitely, they were tacked on and don't belong with the others.

Cheers,
Rusty.
