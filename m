Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbXIRVNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbXIRVNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbXIRVKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:10:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619AbXIRVKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:10:47 -0400
Date: Tue, 18 Sep 2007 22:18:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070918201803.GC1632@elte.hu>
References: <1190145390.5204.41.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190145390.5204.41.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> (3)
> 
> rework enqueue/dequeue_entity() to get rid of 
> sched_class::set_curr_task(). This simplifies sched_setscheduler(), 
> rt_mutex_setprio() and sched_move_tasks().

ah. This makes your ready-queue patch a code size win. Applied.

	Ingo
