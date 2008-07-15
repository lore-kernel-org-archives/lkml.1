Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYGOXHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYGOXHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYGOXHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:07:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYGOXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:07:10 -0400
Date: Wed, 16 Jul 2008 01:06:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com, a.p.zijlstra@chello.nl,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [git pull] RCU updates for v2.6.27
Message-ID: <20080715230646.GB31249@elte.hu>
References: <20080714152045.GA29159@elte.hu> <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org> <20080715131515.ebdc53d8.akpm@linux-foundation.org> <alpine.LFD.1.10.0807151319360.2867@woody.linux-foundation.org> <84144f020807151401s2e37b892q2df007c9e1e3464a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020807151401s2e37b892q2df007c9e1e3464a@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> There are now three commits in your tree that fix a real bug reported 
> by kmemcheck: 8410565f540db87ca938f56f92780d251e4f157d ("ACPICA: Fix 
> for access to deleted object <regression>"), 
> adeed48090fc370afa0db8d007748ee72a40b578 ("rc80211_pid: Fix fast_start 
> parameter handling"), and 62f75532b583c03840f31e40386ce2df73be9ca0 
> ("slub: Initialize per-cpu stats").

there's a fourth one that i found via kmemcheck and which got fixed by 
Jens but the commit log doesnt mention that it was found via kmemcheck:

 | commit 63a7138671c50a6f2c27bbd1a308dc75967062a3
 | Author: Jens Axboe <jens.axboe@oracle.com>
 | Date:   Fri Feb 8 12:41:03 2008 +0100
 |
 |     block: fixup rq_init() a bit

> So I think it has been helpful and that the infrastructure it adds is 
> valuable for future debugging aids.

even if it was not finding any bugs it would be useful to us - it has 
already cleaned up a few dusty aspects of x86 code. (it might be similar 
for SLUB)

Oh, and kmemcheck got Vegard to hack Linux ;-)

	Ingo
