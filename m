Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXIXWEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXIXWEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbXIXWD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:03:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49572 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760117AbXIXWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:03:55 -0400
Date: Tue, 25 Sep 2007 00:03:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: cleanup adjusting sched_class
Message-ID: <20070924220346.GB24757@elte.hu>
References: <46F8236B.9020902@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F8236B.9020902@ct.jp.nec.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0846]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Hi Ingo and Dmitry,
> 
> I made a clean-up patch about fixing invalid sched_class use.
> 
> Dmitry, could you please review and sign it?
> 
> 
> The adjusting sched_class is a missing part of the already existing 
> "do not leak PI boosting priority to the child" at the sched_fork(). 
> This patch moves the adjusting sched_class from wake_up_new_task() to 
> sched_fork().

thanks. Note that your cleanup also shrinks the code a bit:

   text    data     bss     dec     hex filename
  40111    4018     292   44421    ad85 sched.o.before
  40102    4018     292   44412    ad7c sched.o.after

which never hurts :)

	Ingo
