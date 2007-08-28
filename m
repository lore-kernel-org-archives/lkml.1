Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbXH1Hgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbXH1Hgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 03:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXH1Hgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 03:36:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXH1Hgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 03:36:35 -0400
Date: Tue, 28 Aug 2007 09:36:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Al Boldi <a1426z@gawab.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070828073619.GA8267@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708280737.53439.a1426z@gawab.com> <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org> <200708280823.53663.a1426z@gawab.com> <1188286097.6317.12.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188286097.6317.12.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > I like your analysis, but how do you explain that these stalls 
> > vanish when __update_curr is disabled?
> 
> When you disable __update_curr(), you're utterly destroying the
> scheduler.  There may well be a scheduler connection, but disabling
> __update_curr() doesn't tell you anything meaningful.  Basically, you're
> letting all tasks run uninterrupted for just as long as they please
> (which is why busy loops lock your box solid as a rock).  I'd suggest
> gathering some sched_debug stats or something... [...]

the output of the following would be nice:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

captured while the gears are running.

	Ingo
