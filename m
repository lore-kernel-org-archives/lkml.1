Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZHHP2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZHHP2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZHHP2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:28:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbZHHP2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:28:47 -0400
Date: Sat, 8 Aug 2009 17:27:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "lkml," <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] fixup pi_state in futex_requeue on lock steal
Message-ID: <20090808152756.GH28892@elte.hu>
References: <4A7A1D48.7040309@us.ibm.com> <1249576660.32113.585.camel@twins> <4A7B5D46.7080109@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7B5D46.7080109@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhltc@us.ibm.com> wrote:

> So, I think we're fine with respect to the pi_state ownership!  In 
> fact I finally managed to catch the lock steal in the requeue loop 
> in my tracing, and everything worked fine.  Going to go rerun a 
> bunch more tests and see if I hit any other issues, if I do, I 
> suspect they are unrelated to this.
>
> Thanks for the help in thinking this through.

i've got these queued up:

 00235fe: futex: Update woken requeued futex_q lock_ptr
 1bbf208: rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()

should i drop them?

	Ingo
