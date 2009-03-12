Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZCLKCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZCLKCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZCLKCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:02:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZCLKCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:02:24 -0400
Date: Thu, 12 Mar 2009 11:02:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix off-by-one in __iterator_load_balance
Message-ID: <20090312100205.GA30095@elte.hu>
References: <49B7CF67.5070604@davidnewall.com> <49B8D730.4030708@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8D730.4030708@davidnewall.com>
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


* David Newall <davidn@davidnewall.com> wrote:

> David Newall wrote:
> > An off-by-one bug in __iterator_load_balance causes it to erroneously
> > return NULL if the next task on the list is also the last entry in the
> > list.  This patch corrects that fault.
> >   
> 
> Patch withdrawn.  Who'd have thought 2.6.27.19 was so out of date?

Yeah, the 2.6.27 -> latest-sched-devel distance is more than 250 
commits already - that's a lot of commits for the scheduler 
which is only 15 KLOC. Patches done on .27 are unlikely to apply 
- and bugs are often fixed already.

	Ingo
