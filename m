Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbYI3I7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbYI3I7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYI3I7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:59:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYI3I7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:59:05 -0400
Date: Tue, 30 Sep 2008 10:58:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH -tip] sched: fix using uninilialzed rq in
	task_delta_exec()
Message-ID: <20080930085850.GA27452@elte.hu>
References: <48E11D0D.3040000@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E11D0D.3040000@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2643]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> compiler warnings;
> 
>   CC      kernel/sched.o
> kernel/sched.c: In function 'task_delta_exec':
> kernel/sched.c:4055: warning: unused variable 'flags'
> kernel/sched.c:4054: warning: 'rq' is used uninitialized in this function
> 
> calling task_delta_exec() may cause unexpected pointer access.

heh, just fixed that as well, latest tip/master should have the fix.

Have you seen any weirdness due to this uninitialized variable?

	Ingo
