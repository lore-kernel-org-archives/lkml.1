Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYGZOmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYGZOmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 10:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGZOmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 10:42:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYGZOmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 10:42:00 -0400
Date: Sat, 26 Jul 2008 16:41:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cpumask: Change cpumask_of_cpu to use
	cpumask_of_cpu_map V2
Message-ID: <20080726144133.GA27011@elte.hu>
References: <20080725012128.805332000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725012128.805332000@polaris-admin.engr.sgi.com>
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

> V2: Use Rusty's cpumask initializer to statically initialize the
>     cpumask_of_cpu_map[].  In addition, create this map in the init
>     data section using NR_CPUS but replace it during boot up with
>     one sized by nr_cpu_ids (num possible cpus).
> 
> The following patch is submitted to resolve this problem...
> 
> (Based on tip/master.  I will generate a linux-next version if 
> requested since it now has generic code that will be executed for 
> non-x86 arch's.)

i've applied it to tip/cpus4096 and started testing it. This is the 
topic where the problem originates from, so we can reuse it for 
linux-next.

	Ingo
