Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbYIWJMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbYIWJMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYIWJMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:12:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYIWJMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:12:16 -0400
Date: Tue, 23 Sep 2008 11:11:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Steigerwald <ms@teamix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
Message-ID: <20080923091159.GE31189@elte.hu>
References: <200809231101.41624.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231101.41624.ms@teamix.de>
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


* Martin Steigerwald <ms@teamix.de> wrote:

> The documentation about the CFS scheduler is scarse when it comes to 
> scheduling policies. This patch adds a chapter about the scheduling policies 
> it supports. Peter Zijlstra provided most of the information for it in
> 
> http://marc.info/?l=linux-kernel&m=122210038326356&w=2
> 
> This patch is based on 2.6.27-rc7.
> 
> Signed-off-by: Martin Steigerwald <ms@teamix.de>

looks good to me - but could you please do the patch against the latest 
scheduler tree, which has already updated this file (and which made your 
patch not apply cleanly):

  http://people.redhat.com/mingo/tip.git/README

also:

> --- sched-design-CFS.txt-2.6.27-rc7     2008-07-13 23:51:29.000000000 +0200
> +++ sched-design-CFS.txt        2008-09-23 10:33:01.107393509 +0200

please use -p1 to create patches - or since you've just set up the 
tip/master tracking, do something like:

  <modify Documentation/scheduler/sched-design-CFS.txt>

  git-commit Documentation/scheduler/sched-design-CFS.txt

  <add commit log>

and then export the commit you just created for use in emailing, via:

  git log --pretty=email --stat -1 -p > mail.txt

	Ingo
