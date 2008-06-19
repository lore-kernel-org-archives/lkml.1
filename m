Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYFSMSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYFSMSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYFSMSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:18:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52126 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbYFSMSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:18:04 -0400
Date: Thu, 19 Jun 2008 14:17:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: bharathravi1@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, vatsa@in.ibm.com, balbir@in.ibm.com,
       Madhava K R <madhavakr@gmail.com>
Subject: Re: [PATCH] Delay accounting, fix incorrect delay time when
	constantly waiting on runqueue
Message-ID: <20080619121740.GF7640@elte.hu>
References: <1213609261-9554-1-git-send-email-bharathravi1@gmail.com> <1213869682.10476.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213869682.10476.2.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > The patch was tested on 2.6.26-rc6 using two simple CPU hog 
> > programs. The values noted prior to the fix did not account for the 
> > time spent on the runqueue waiting. After the fix, the correct 
> > values were reported back to user space.
> > 
> > Signed-off-by: Bharath Ravi <bharathravi1@gmail.com>
> > Signed-off-by: Madhava K R  <madhavakr@gmail.com>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/urgent - thanks.

	Ingo
