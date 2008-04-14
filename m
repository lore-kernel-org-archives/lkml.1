Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYDNIte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYDNIte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYDNIt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:49:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbYDNItZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:49:25 -0400
Date: Mon, 14 Apr 2008 10:48:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Erik Bosman <ejbosman@cs.vu.nl>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3-REVISED] x86: Implement prctl PR_GET_TSC and
	PR_SET_TSC
Message-ID: <20080414084850.GF19865@elte.hu>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <Pine.GSO.4.56.0804140014000.6537@keg.few.vu.nl> <20080413205821.61d6c85b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413205821.61d6c85b@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> I like this a whole lot more than the previous version; in fact I like 
> how it gets rid of various ifdefs. It's a bit unfortunate that it 
> duplicates for 32/64 bit but this code isn't unified yet, and at least 
> your 2 functions are identical, making it not hard to deal with in the 
> unification. (so .. not your fault you did all the right things)
> 
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

thanks everyone for all the review - i've applied all three patches of 
Erik to x86.git and it's looking good so far in my testing as well.

	Ingo
