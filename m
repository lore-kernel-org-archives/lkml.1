Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZL2Om4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZL2Om4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZL2Om4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:42:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZL2Omz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:42:55 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: core of the scheduling class
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
In-Reply-To: <1255707614.6228.453.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 15:41:39 +0100
Message-ID: <1262097699.7135.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> +static unsigned long
> +load_balance_deadline(struct rq *this_rq, int this_cpu, struct rq *busiest,
> +                unsigned long max_load_move,
> +                struct sched_domain *sd, enum cpu_idle_type idle,
> +                int *all_pinned, int *this_best_prio)
> +{
> +       /* for now, don't touch SCHED_DEADLINE tasks */
> +       return 0;
> +}
> +
> +static int
> +move_one_task_deadline(struct rq *this_rq, int this_cpu, struct rq *busiest,
> +                 struct sched_domain *sd, enum cpu_idle_type idle)
> +{
> +       return 0;
> +} 

The good news is that I've killed all that :-)

