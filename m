Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbXJBGI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbXJBGI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXJBGIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:08:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXJBGIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:08:51 -0400
Date: Tue, 2 Oct 2007 08:08:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071002060848.GB18588@elte.hu>
References: <20071001173159.GB2492@elte.hu> <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEOBHCAC.davids@webmaster.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Schwartz <davids@webmaster.com> wrote:

> > (user-space spinlocks are broken beyond words for anything but 
> > perhaps SCHED_FIFO tasks.)
> 
> User-space spinlocks are broken so spinlocks can only be implemented 
> in kernel-space? Even if you use the kernel to schedule/unschedule the 
> tasks, you still have to spin in user-space.

user-space spinlocks (in anything but SCHED_FIFO tasks) are pretty 
broken because they waste CPU time. (not as broken as yield, because 
"wasting CPU time" is a more deterministic act, but still broken) Could 
you cite a single example where user-space spinlocks are technically the 
best solution?

	Ingo
