Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXLJJbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXLJJbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXLJJaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:30:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbXLJJay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:30:54 -0500
Date: Mon, 10 Dec 2007 10:29:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071210092948.GA18184@elte.hu>
References: <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com> <20071209074647.GE22981@elte.hu> <20071210081952.GA7215@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210081952.GA7215@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> Further more this can cause a deadlock since we're calling 
> get_online_cpus() from the watchdog thread's context, which is going 
> to be kthread_stop'ed from a cpu-hotplug context. This is what I think 
> was happening in the case reported by Jiri.
> 
> Please find the patch below.

thanks, and i've updated sched-devel.git.

	Ingo
