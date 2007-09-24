Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXIXWBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXIXWBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbXIXWBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:01:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57188 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759825AbXIXWBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:01:03 -0400
Date: Tue, 25 Sep 2007 00:00:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: cleanup adjusting sched_class
Message-ID: <20070924220051.GA24757@elte.hu>
References: <46F8236B.9020902@ct.jp.nec.com> <b647ffbd0709241451r23a8f12fld9d5cccc987ed57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0709241451r23a8f12fld9d5cccc987ed57@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0103]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> On 24/09/2007, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> > Hi Ingo and Dmitry,
> >
> > I made a clean-up patch about fixing invalid sched_class use.
> 
> thanks!
> 
> >
> > Dmitry, could you please review and sign it?
> >
> >
> > The adjusting sched_class is a missing part of the already existing
> > "do not leak PI boosting priority to the child" at the sched_fork().
> > This patch moves the adjusting sched_class from wake_up_new_task()
> > to sched_fork().
> >
> > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

thanks - i've picked up Hiroshi's cleanup.

	Ingo
