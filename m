Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYKDJQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYKDJQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYKDJQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:16:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbYKDJQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:16:11 -0500
Date: Tue, 4 Nov 2008 10:15:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
Message-ID: <20081104091556.GG23790@elte.hu>
References: <4910070C.8010807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4910070C.8010807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> this fix will increase about several hundred bytes to the kernel 
> text for rcuclassic.

hm, why is that, and is it true for the full vmlinux as well, for a 
reasonably large .config?

Do you get the size increase even if these two are enabled:

 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_OPTIMIZE_INLINING=y

?

i'd expect the opposite or same-size: given that an ugly 
quasi-inlining macro is replaced with a shared, out of line function.

	Ingo
