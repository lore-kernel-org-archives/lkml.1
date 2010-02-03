Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0BCNT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 08:19:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59554 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab0BCNTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 08:19:25 -0500
Date: Wed, 3 Feb 2010 14:19:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: using O_LARGEFILE to open perf data file  -
 fix
Message-ID: <20100203131911.GA25223@elte.hu>
References: <4B68F32A.9040203@cn.fujitsu.com>
 <4B6958B8.3000606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6958B8.3000606@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Setting _FILE_OFFSET_BITS and using O_LARGEFILE, lseek64, etc, is
> redundant. Thanks H. Peter Anvin for point out
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  tools/perf/builtin-record.c        |    3 +--
>  tools/perf/util/header.c           |   21 ++++++++++-----------
>  tools/perf/util/session.c          |    3 +--
>  tools/perf/util/trace-event-read.c |   14 +++++++-------
>  4 files changed, 19 insertions(+), 22 deletions(-)

i already applied the v1 patch - mind sending a delta patch that removes the 
redundant definitions?

Thanks,

	Ingo
