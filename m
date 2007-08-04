Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbXHDKkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbXHDKkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 06:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbXHDKk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 06:40:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46566 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873AbXHDKk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 06:40:26 -0400
Date: Sat, 4 Aug 2007 12:40:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Simplify move_tasks()
Message-ID: <20070804104016.GA3195@elte.hu>
References: <46B3E4FC.2010509@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B3E4FC.2010509@bigpond.net.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2627]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> NB Since move_tasks() gets called with two run queue locks held even 
> small reductions in overhead are worthwhile.

thanks, i've applied your patch. It also shaves off a bit of code from 
sched.o:

   text    data     bss     dec     hex filename
  39216    3618      24   42858    a76a sched.o.before
  39173    3618      24   42815    a73f sched.o.after

	Ingo
