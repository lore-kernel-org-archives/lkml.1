Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbXJKHAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbXJKHAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXJKHAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:00:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbXJKHAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:00:00 -0400
Date: Thu, 11 Oct 2007 08:59:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
Message-ID: <20071011065946.GB32125@elte.hu>
References: <470D7055.4090000@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470D7055.4090000@bigpond.net.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> -#define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
> -#define DEF_TIMESLICE		(100 * HZ / 1000)

hm, this got removed by Dmitry quite some time ago. Could you please do 
this patch against the sched-devel git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

thanks,

	Ingo
