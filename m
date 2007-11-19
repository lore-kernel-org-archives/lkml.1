Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXKSIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXKSIyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXKSIyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:54:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXKSIyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:54:44 -0500
Date: Mon, 19 Nov 2007 09:54:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] new TSC based delay_tsc()
Message-ID: <20071119085424.GA10760@elte.hu>
References: <200711181120.27459.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711181120.27459.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi all,
> 
> This is a patch based on the Ingo's idea/patch to track delay_tsc() 
> migration to another cpu by comparing smp_processor_id(). It is 
> against kernel-2.6.24-rc3.
> 
> What is different:
> 1. Using unsigned (instead of long) to unify for i386/x86_64.
> 2. Minimal preempt_disable/enable() critical sections
>    (more room for preemption)
> 3. some statements have been rearranged, to account for
>     possible under/overflow of left/TSC
> 
> Tested on both: 32/64 bit SMP PREEMPT kernel-2.6.24-rc3
> 
> Hope it is correct. Comments, please.

thanks! The changes look certainly good to me.

> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

Signed-off-by: Ingo Molnar <mingo@elte.hu>

	Ingo
