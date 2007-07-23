Return-Path: <linux-kernel-owner+w=401wt.eu-S1764953AbXGWSXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764953AbXGWSXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbXGWSXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:23:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48516 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXGWSX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:23:29 -0400
Date: Mon, 23 Jul 2007 20:23:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] release quicklist before free_page
Message-ID: <20070723182301.GA27789@elte.hu>
References: <20070723152129.036573829@mvista.com> <1185208378.8197.20.camel@twins> <1185207979.2573.55.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185207979.2573.55.camel@imap.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > Not quite, it uses preempt_disable() to avoid migration and stick to 
> > a cpu. Without that it might end up freeing pages from another 
> > quicklist.

i.e. the patch hides a debug warning and there's possibly silent data 
corruption - not good.

> > How about this - compile tested only
> 
> How about a comment to go with it ?  Which says something like what's 
> above, notes on how the locking is getting used..

how about: "if you've got some time then please also add a few comments, 
because the code was quite non-obvious to me and I misunderstood it when 
I tried to fix it. Thanks."

ok?

	Ingo
