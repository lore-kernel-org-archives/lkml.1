Return-Path: <linux-kernel-owner+w=401wt.eu-S966078AbXHaSWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966078AbXHaSWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965826AbXHaSWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:22:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964994AbXHaSWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:22:23 -0400
Date: Fri, 31 Aug 2007 20:22:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Message-ID: <20070831182212.GA3568@elte.hu>
References: <20070827215611.GA30396@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827215611.GA30396@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Current idle time in kstat is based on jiffies and is coarse grained. 
> tick_sched.idle_sleeptime is making some attempt to keep track of idle 
> time in a fine grained manner. But, it is not handling the time spent 
> in interrupts fully.
> 
> Make tick_sched.idle_sleeptime accurate with respect to time spent on 
> handling interrupts and also add tick_sched.idle_lastupdate, which 
> keeps track of last time when idle_sleeptime was updated.
> 
> This statistics will be crucial for cpufreq-ondemand governor, which 
> can shed some conservative gaurd band that is uses today while setting 
> the frequency. The ondemand changes that uses the exact idle time is 
> coming soon.

nice stuff! I've added your patch to the scheduler queue - but this will 
probably be 2.6.24 material.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
