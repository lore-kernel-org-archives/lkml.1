Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710Ab0ASVKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0ASVKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679Ab0ASVKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:10:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0ASVKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:10:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=LvvgB44tUwgA:10 a=pvDITCcdRQcHJGLfHHIA:9 a=Kfv6qxW47aoRq1WCzj0TKPz3iBUA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
From: Steven Rostedt <rostedt@goodmis.org>
To: Julia Lawall <julia@diku.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>
In-Reply-To: <Pine.LNX.4.64.1001192155490.28583@ask.diku.dk>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>
	 <Pine.LNX.4.64.1001192155490.28583@ask.diku.dk>
Content-Type: text/plain
Date: Tue, 19 Jan 2010 16:08:53 -0500
Message-Id: <1263935333.4561.26.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 21:58 +0100, Julia Lawall wrote:
> > Anyway, this looks like a good janitorial work. Anything that assigns
> > state outside the rq locks to something other than TASK_RUNNING and that
> > is not before a schedule() (perhaps even those) should be converted to:
> > 
> > 	set_current_task(<state>).
> 
> Does "not before a schedule" mean not before a schedule_timeout as well?

Yep.

> 
> Also, I assume you mean set_current_state?

Yep!

Thanks!

-- Steve


