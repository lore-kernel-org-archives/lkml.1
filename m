Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbZALJPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbZALJPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbZALJPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:15:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbZALJO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:14:59 -0500
Date: Mon, 12 Jan 2009 10:14:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perf_counter: Always schedule all software counters in
Message-ID: <20090112091452.GH26750@elte.hu>
References: <18794.55122.441686.553409@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18794.55122.441686.553409@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Software counters aren't subject to the limitations imposed by the fixed 
> number of hardware counter registers, so there is no reason not to 
> enable them all in __perf_counter_sched_in.  Previously we used to break 
> out of the loop when we got to a group that wouldn't fit on the PMU; 
> with this we continue through the list but only schedule in software 
> counters (or groups containing only software counters) from there on.

yeah, makes sense.

> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> This is also available in my perfcounters git tree (master branch) at
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git

Pulled into tip/perfcounters/core, thanks Paul!

	Ingo
