Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZASR31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZASR31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZASR1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:27:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbZASR1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:27:00 -0500
Date: Mon, 19 Jan 2009 18:26:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cpu freq: fix problems with work_on_cpu usage in
	acpi-cpufreq [PULL request]
Message-ID: <20090119172639.GA8011@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <49711A64.3050103@sgi.com> <20090117220858.GA12374@elte.hu> <4974B437.6080004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974B437.6080004@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Hi Ingo,
> >>
> >> If you are ready for these, I've pushed them to the cpus4096-for-ingo 
> >> tree.  (Note it's been renamed.)
> > 
> > that might be fine for v2.6.30, but we need separate patches in a 
> > separate branch, for all -git relevant fixes - in as safe way as 
> > possible.
> > 
> > 	Ingo
> 
> So you want me to create a separate branch for each patch?
> 
> And don't you think the fix to work_on_cpu should be put into 2.6.29?

Getting it into v2.6.29 is precisely the point: please put the essential 
fixes (and only the fixes) into a separate (single), -git based (i.e. not 
tip/cpus4096 based) branch that i can pull. The work_on_cpu() commit(s) 
would be part of that branch.

	Ingo
