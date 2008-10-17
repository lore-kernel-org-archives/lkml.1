Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYJQNhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYJQNhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYJQNg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:36:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48945 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbYJQNgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:36:55 -0400
Date: Fri, 17 Oct 2008 15:36:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patchlet] sched: minor fast-path overhead reduction
Message-ID: <20081017133645.GB28600@elte.hu>
References: <1224250401.5226.7.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224250401.5226.7.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0495]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Greetings,
> 
> 103638d added a bit of avoidable overhead to the fast-path.
> 
> Use sysctl_sched_min_granularity instead of sched_slice() to restrict buddy wakeups.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

applied to tip/sched/urgent, thanks Mike!

	Ingo
