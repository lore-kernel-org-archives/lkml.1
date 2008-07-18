Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYGRUFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYGRUFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYGRUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:05:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYGRUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:05:28 -0400
Date: Fri, 18 Jul 2008 22:04:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] cpumask: Replace/optimize cpumask_of_cpu &
	cpumask_t operations
Message-ID: <20080718200458.GA27176@elte.hu>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715211429.454823000@polaris-admin.engr.sgi.com>
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

>   * Patch 1 replaces the dangerous lvalue version of cpumask_of_cpu
>     with new cpumask_of_cpu_ptr macros.  These are patterned after the
>     node_to_cpumask_ptr macros.
> 
>   * Patches 2..6 optimizes various places where a pointer to the cpumask_of_cpu
>     value will result in reducing stack pressure.
> 
>   * Patch 7 provides a generic set of CPUMASK_ALLOC macros patterned after
>     the SCHED_CPUMASK_ALLOC macros.  This is used where multiple cpumask_t
>     variables are declared on the stack to reduce the amount of stack space
>     required.
> 
>   * Patch 8 uses the CPUMASK_ALLOC macros in the centrino_target() function.

applied to tip/cpus4096 for more testing, thanks Mike.

	Ingo
