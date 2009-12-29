Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbZL2MQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbZL2MQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZL2MQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:16:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:50046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZL2MQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:16:25 -0500
Subject: Re: [RFC 1/12][PATCH] Extended scheduling parameters structure
 added.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255707535.6228.451.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707535.6228.451.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 13:15:43 +0100
Message-ID: <1262088943.7135.137.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:38 +0200, Raistlin wrote:

>  include/linux/sched.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 75e6e60..ac9837c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -94,6 +94,14 @@ struct sched_param {
>  
>  #include <asm/processor.h>
>  
> +struct sched_param_ex {
> +	int sched_priority;
> +	struct timespec sched_runtime;
> +	struct timespec sched_deadline;
> +	struct timespec sched_period;
> +	int sched_flags;
> +};
> +
>  struct exec_domain;
>  struct futex_pi_state;
>  struct robust_list_head;

Why separate this change from the introduction of the new system calls?


