Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYIVLxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYIVLxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYIVLxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:53:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbYIVLxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:53:21 -0400
Date: Mon, 22 Sep 2008 13:53:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] hrtimer: Remove
	hrtimer_clock_base::get_softirq_time()
Message-ID: <20080922115308.GC14301@elte.hu>
References: <1221826424.20993.4.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221826424.20993.4.camel@blaa>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0331]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark McLoughlin <markmc@redhat.com> wrote:

> Peter Zijlstra noticed this 8 months ago and I just noticed
> it again.
> 
> hrtimer_clock_base::get_softirq_time() is currently unused
> in the entire tree. In fact, looking at the logs, it appears
> as if it was never used. Remove it.

applied to tip/timers/hrtimers, thanks Mark.

Thomas, any objections?

	Ingo
