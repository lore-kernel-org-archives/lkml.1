Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbZDALqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbZDALqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZDALqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:46:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbZDALqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:46:19 -0400
Date: Wed, 1 Apr 2009 13:45:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 0/21] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
Message-ID: <20090401114557.GC23678@elte.hu>
References: <20090331144229.A11867@sedona.ch.intel.com> <20090331233958.GA28228@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E926D4FDE@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E926D4FDE@irsmsx504.ger.corp.intel.com>
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Oleg Nesterov [mailto:oleg@redhat.com]
> >Sent: Wednesday, April 01, 2009 1:40 AM
> >To: Metzger, Markus T
> 
> 
> >> The first 5 patches apply to .29 with the small preparation patch below.
> >
> >Tried to review these patches.
> >
> >As I said, I don't understand ds.c, but I _think_ these changes are good.
> >
> >I only have a couple of really minor nitpicks...
> 
> Thanks for your review!
> I will address the nitpicks in separate patches, if that's OK with everyone.

Please dont forget to propagate Oleg's Reviewed-by (or Acked-by) 
tags into the commits.

> Regarding bisecting, I split the patches to attract reviewers to 
> the smaller parts rather than scare them off with one big patch.
>
> I hope that the bisecting tool can cope with broken builds between 
> patches.

It cannot, and even if it did we dont want a single intentionally 
broken bisection point in the kernel. Please do small patches that 
build fine at each step. We've got more than 100,000 bisectable 
commits in the kernel to look at. If you think it's not possible in 
a specific case then please describe the situation to us so that we 
can suggest a solution.

	Ingo
