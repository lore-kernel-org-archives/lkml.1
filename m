Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYLDIKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYLDIKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYLDIKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:10:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbYLDIKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:10:30 -0500
Date: Thu, 4 Dec 2008 09:10:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 0/3] ftrace: clean ups for tip
Message-ID: <20081204081008.GC32594@elte.hu>
References: <20081204052638.425740534@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204052638.425740534@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The following patches are to have ftrace use the pid struct
> for filtering on pids.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (3):
>       fix the do_each_pid_task macro
>       ftrace: use struct pid
>       ftrace: add ability to only trace swapper tasks
> 
> ----
>  include/linux/pid.h   |    4 +-
>  kernel/trace/ftrace.c |  128 ++++++++++++++++++++++++++++++++++++------------
>  kernel/trace/trace.h  |    4 +-
>  3 files changed, 100 insertions(+), 36 deletions(-)

pulled, thanks Steve!

	Ingo
