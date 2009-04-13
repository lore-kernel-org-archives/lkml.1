Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZDMDly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZDMDly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZDMDlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:41:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZDMDlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:41:44 -0400
Date: Mon, 13 Apr 2009 05:40:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] use smp_call_function_single() in
	arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
Message-ID: <20090413034058.GB11652@elte.hu>
References: <20090413000630.21C09DE12A@ozlabs.org> <20090413001657.GA24946@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413001657.GA24946@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

> On Mon, Apr 13, 2009 at 09:30:02AM +0930, Rusty Russell wrote:
>  > From: Andrew Morton <akpm@linux-foundation.org>
>  > 
>  > Impact: fix sysbench(oltp)+mysql 10% regression with 2.6.30-rc1
>  > 
> 
> This, and the other cpufreq related patches in this series look 
> sound to me. Given the other non-cpufreq bits in the series, do 
> you want to just have these go through Andrew and onto Linus?

the other x86 bits look good to me too. It would be best to do this 
via -mm because the regression was introduced from there too so the 
'lets do a revert and these patches in the next cycle' versus 'lets 
do these fixes right now' decision should be driven from there too.

Thanks,

	Ingo
