Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZHSQMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZHSQMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZHSQMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:12:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42053 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZHSQMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:12:43 -0400
Date: Wed, 19 Aug 2009 18:12:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Cohen <wcohen@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add minimal support for software performance counters
	for ia64
Message-ID: <20090819161234.GB31058@elte.hu>
References: <4A8C2290.3040707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8C2290.3040707@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* William Cohen <wcohen@redhat.com> wrote:

> The following patch adds minimal support for software 
> performance counters for ia64.

Nice!

> For the kernel the patch enables configuration of the 
> perf counter option, adds the perf_counter_open 
> syscall, and includes a minimal machine specific 
> asm/perf.h header file.
> 
> For the perf tool the header perf.h includes an ia64 
> specific section and the options used in the Makefile 
> were adjusted to allow compilation on ia64.  The 
> -Wcast-align gives "cast increases required alignment 
> of target type" warning for the list_for_each_entry() 
> macro. The "-fno-strict-aliasing" was used to avoid 
> warnings for "dereferencing type-punned pointer will 
> break strict-aliasing rules" warnings for sscanf() 
> functions in util/trace-event-parse.c

Tony, Fenghua Yu, this patch already depends on .32 
changes in the perfcounters tree - would be OK to you if 
we merged this patch into the perfcounters tree? Plus 
perhaps merge a syscall placeholder patch into the ia64 
tree?

Thanks,

	Ingo
