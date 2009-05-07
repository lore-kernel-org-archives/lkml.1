Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbZEGIvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbZEGIvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbZEGIvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:51:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58196 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZEGIvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:51:37 -0400
Date: Thu, 7 May 2009 10:51:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Bird <tim.bird@am.sony.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to use a different sched_clock() for ftrace on omap?
Message-ID: <20090507085116.GC19133@elte.hu>
References: <4A022333.8030200@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A022333.8030200@am.sony.com>
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


* Tim Bird <tim.bird@am.sony.com> wrote:

> Hi all,
> 
> I've worked up a replacement sched_clock for ftrace on my omap 
> platform. The current sched_clock, based on the 32K timer, has low 
> resolution and doesn't provide very useful results.

hm, why dont you replace the real sched_clock() with it? High 
resolution sched_clock() gives (much!) better scheduling, better 
fairness, etc.

	Ingo
