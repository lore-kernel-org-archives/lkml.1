Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbXLCVsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbXLCVsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXLCVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:48:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbXLCVs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:48:27 -0500
Date: Mon, 3 Dec 2007 22:48:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Chris Friesen <cfriesen@nortel.com>, davids@webmaster.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203214803.GA8989@elte.hu>
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com> <47545F88.6070609@nortel.com> <4754777F.7020302@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4754777F.7020302@rtr.ca>
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


* Mark Lord <lkml@rtr.ca> wrote:

> That's not the same thing at all. I think that David is suggesting 
> that the reinsertion logic should pretend that the task used up all of 
> the CPU time it was offered in the slot leading up to the 
> sched_yield() call.

we have tried this too, and this has problems too (artificial inflation 
of the vruntime metric and a domino effects on other portions of the 
scheduler). So this is a worse solution than what we have now. (and this 
has all been pointed out in past discussions in which David 
participated. I'll certainly reply to any genuinely new idea.)

	Ingo
