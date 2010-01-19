Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427Ab0ASU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0ASU6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088Ab0ASU6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:58:32 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:41181 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0ASU6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:58:31 -0500
Date: Tue, 19 Jan 2010 21:58:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
In-Reply-To: <1263932978.31321.53.camel@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.64.1001192155490.28583@ask.diku.dk>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, this looks like a good janitorial work. Anything that assigns
> state outside the rq locks to something other than TASK_RUNNING and that
> is not before a schedule() (perhaps even those) should be converted to:
> 
> 	set_current_task(<state>).

Does "not before a schedule" mean not before a schedule_timeout as well?

Also, I assume you mean set_current_state?

julia
