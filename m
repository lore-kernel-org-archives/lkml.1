Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYKCJA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYKCJA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYKCJAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:00:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbYKCJAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:00:11 -0500
Date: Mon, 3 Nov 2008 09:59:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH-linux-next] ia64: fix build breakage in smp.h
Message-ID: <20081103085955.GF11730@elte.hu>
References: <200810311856.m9VIuQ0q009450@agluck-lia64.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810311856.m9VIuQ0q009450@agluck-lia64.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0333]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The commit:
>  "cpumask: switch over to cpu_online/possible/active/present_mask"
> provides a define for cpu_online_map but did not delete the
> declaration in arch/ia64/include/asm/smp.h resulting in this
> build error:
> 
>   CC      arch/ia64/kernel/asm-offsets.s
> In file included from include/linux/smp.h:30,
>                  from include/linux/sched.h:68,
>                  from arch/ia64/kernel/asm-offsets.c:9:
> arch/ia64/include/asm/smp.h:60: error: expected ')' before '*' token
> arch/ia64/include/asm/smp.h:60: error: expected ')' before 'cpu_online_mask'
> 
> Fix: just delete the declaration, it is no longer needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

applied to tip/cpus4096, thanks Tony!

> Ingo: I think this belongs in the auto-cpus4096-next branch of the 
> tip tree

yes, thanks. I've pushed out a new version of auto-cpus4096-next.

	Ingo
