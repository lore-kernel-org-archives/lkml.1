Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZL2M2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZL2M2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZL2M2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:28:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZL2M2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:28:39 -0500
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
Date: Tue, 29 Dec 2009 13:27:29 +0100
Message-ID: <1262089649.7135.140.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> +       if (unlikely(task_has_deadline_policy(p) || task_has_rt_policy(p))) {

small nit, since both task_has_{deadline,rt}_policy() already have
unlikely()s in, this extra unlikely is not needed.

