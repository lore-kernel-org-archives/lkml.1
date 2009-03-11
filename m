Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZCKQuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZCKQuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZCKQug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:50:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZCKQuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:50:35 -0400
Date: Wed, 11 Mar 2009 17:49:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] make dequeue_task less confusing
Message-ID: <20090311164951.GA29991@elte.hu>
References: <49B7D0D5.9070001@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B7D0D5.9070001@davidnewall.com>
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

> The dequeue_patch function in kernel/sched.c is complicated by 
> including a sleep parameter.  This parameter is always zero 
> except in one instance.  This patch clarifies the task of 
> dequeue_patch by removing the sleep parameter and moving the 
> code that handles non-zero sleep to that one place where it is 
> needed.

> --- linux-2.6.27.19/kernel/sched.c	2009-02-21 09:09:34.000000000 +1030
> +++ linux-2.6.27.19/kernel/sched.c.dn	2009-03-12 01:01:48.000000000 +1030

The patch does not apply cleanly to the latest scheduler tree:

  1 out of 5 hunks FAILED -- rejects in file kernel/sched.c

You can find it at:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
