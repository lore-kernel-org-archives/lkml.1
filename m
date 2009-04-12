Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZDLOJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZDLOJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZDLOJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:09:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZDLOJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:09:36 -0400
Date: Sun, 12 Apr 2009 16:09:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] lockdep: choose to continue lock debugging despite
	taint
Message-ID: <20090412140919.GE5246@elte.hu>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com> <1239312460-13396-2-git-send-email-fweisbec@gmail.com> <20090410121515.GP21506@elte.hu> <20090410133844.GD5988@nowhere> <20090410134520.GC17878@elte.hu> <20090411011505.GA5992@nowhere> <20090411013753.GB5992@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411013753.GB5992@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > Side request: do you think you could merge them on kill-the-BKL 
> > tree?
> 
> Sorry, forget about this side request. I thought merging 
> tip:master into tip:core/kill-the-BKL would make me suffer a rain 
> of conflicts but actually I've just tried and I only encountered a 
> very simple conflict in sched.c so it's very easy to manage it 
> locally. Then we can keep the history of kill-the-BKL, for now 
> it's good as is.

Ok - that's how we like topics anyway: as independent trees which 
happen to be mostly conflict-free when merged into tip:master.

	Ingo
