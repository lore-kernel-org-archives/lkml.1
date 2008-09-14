Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYINPH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYINPH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYINPHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:07:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42698 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYINPHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:07:12 -0400
Date: Sun, 14 Sep 2008 17:06:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080914150651.GK12522@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
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


* Frank Mayhar <fmayhar@google.com> wrote:

> This is a resubmission of the posix timer rework patch, posted a few 
> days ago. This addresses Oleg Nesterov's comments, removing the RCU 
> stuff from the patch and un-inlining the thread_group_cputime() 
> function for SMP.  I left the function itself as an inline defined in 
> sched.h but the SMP version just calls thread_group_cputime_smp() 
> which is defined in posix-cpu-timers.c.  (The UP version was a 
> one-liner; I left it as an inline.)

i've applied it to tip/timers/posixtimers for more testing, thanks 
Frank.

	Ingo
