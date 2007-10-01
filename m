Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbXJAGLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbXJAGLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 02:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXJAGLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 02:11:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXJAGLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 02:11:38 -0400
Date: Mon, 1 Oct 2007 08:11:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20071001061126.GA32750@elte.hu>
References: <1191179594.6417.8.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191179594.6417.8.camel@earth>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> here is a few patches on top of the recent 'sched-dev':
> 
> (1) [ proposal ] make timeslices of SCHED_RR tasks constant and not
> dependent on task's static_prio;
> 
> (2) [ cleanup ] calc_weighted() is obsolete, remove it;
> 
> (3) [ refactoring ] make dequeue_entity() / enqueue_entity() 
> and update_stats_dequeue() / update_stats_enqueue() look similar, structure-wise.

thanks - i've applied all 3 patches of yours.

> (compiles well, not functionally tested yet)

(it boots fine here and SCHED_RR seems to work - but i've not tested 
getinterval.)

	Ingo
