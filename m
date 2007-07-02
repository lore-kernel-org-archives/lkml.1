Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXGBSNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXGBSNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 14:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXGBSNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 14:13:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43956 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbXGBSNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 14:13:35 -0400
Date: Mon, 2 Jul 2007 20:13:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070702181329.GA13064@elte.hu>
References: <20070622220202.GA16872@elte.hu> <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com> <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com> <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com> <20070702155029.GA13241@elte.hu> <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> > thx. As an initial matter, could you double-check whether your v18
> > kernel source has the patch below applied already?
> 
> It does.

ok. Does the xterm slowdown get any better if you do:

  echo 46 > /proc/sys/kernel/sched_features

? The default on v18 is:

  echo 14 > /proc/sys/kernel/sched_features

	Ingo
