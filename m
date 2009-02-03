Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZBCVvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZBCVvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbZBCVva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:51:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38859 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZBCVv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:51:29 -0500
Date: Tue, 3 Feb 2009 22:51:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: do_each_pid_task() needs rcu lock
Message-ID: <20090203215123.GA12123@elte.hu>
References: <20090203193904.GA23695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203193904.GA23695@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> "ftrace: use struct pid" commit 978f3a45d9499c7a447ca7615455cefb63d44165
> converted ftrace_pid_trace to "struct pid*". But we can't use
> do_each_pid_task() without rcu_read_lock() even if we know the pid
> itself can't go away (it was pinned in ftrace_pid_write). The exiting
> task can detach itself from this pid at any moment.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Applied to tip/tracing/urgent (for v2.6.29), thanks Oleg!

	Ingo
