Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXIRUrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXIRUrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbXIRUrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:47:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612AbXIRUrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:47:42 -0400
Date: Tue, 18 Sep 2007 22:16:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dimm <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070918201622.GA1632@elte.hu>
References: <1190144190.5204.24.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190144190.5204.24.camel@earth>
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


* dimm <dmitry.adamushko@gmail.com> wrote:

> (1)
> 
> due to the fact that we no longer keep the 'current' within the tree, 
> dequeue/enqueue_entity() is useless for the 'current' in 
> task_new_fair(). We are about to reschedule and 
> sched_class->put_prev_task() will put the 'current' back into the 
> tree, based on its new key.
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

thanks, applied.

	Ingo
