Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbZD3PfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbZD3PfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbZD3PfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:35:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbZD3PfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:35:04 -0400
Date: Thu, 30 Apr 2009 17:34:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [GIT PULL] tracing/workqueue: fix 32 bits unfriendly
	64 bits division
Message-ID: <20090430153414.GA2703@elte.hu>
References: <20090430145425.GA5974@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430145425.GA5974@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Ingo,
> 
> Here is a fix for the build error you reported. This branch can be 
> pulled independantly or on top of tracing/workqueue from the 
> previous pull-request.
> 
> Thanks.
> 
> 
> The following changes since commit 10c494ea1b75f96d5fca78178732d79e68129cc0:
>   Frederic Weisbecker (1):
>         tracing/workqueue: fix 32 bits unfriendly 64 bits division
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/workqueue-2

Thanks, i have pulled this into tip:tracing/workqueues - but that is 
a temporary branch, lets hold off on merging it into tracing/core, 
until some of the more fundamental criticisms of Andrew are 
addressed, ok?

	Ing
