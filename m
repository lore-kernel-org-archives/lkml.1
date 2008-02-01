Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbYBALB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbYBALB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760326AbYBALBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:01:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198AbYBALBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:01:35 -0500
Date: Fri, 1 Feb 2008 12:01:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
Message-ID: <20080201110123.GF27178@elte.hu>
References: <20080131221436.GA3760@elte.hu> <20080201084056.GH15220@kernel.dk> <20080201104537.GA27178@elte.hu> <20080201104733.GM15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201104733.GM15220@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Feb 01 2008, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > Are you sure this triggered with the as fixup in place? It looks like 
> > > the same bug.
> > 
> > most definitely a separate bug.
> 
> yeah, I didn't read it carefully enough. Nikanth found the reason.

/me processes his mbox some more and sees the mails

am i right that lockdep complained about real lockup potential here? 
(i.e. it caught a real bug) So there's no need to change anything on the 
lockdep side, right?

	Ingo
