Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZIAXMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZIAXMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 19:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZIAXMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 19:12:02 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:47881 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbZIAXMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 19:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EOJTD2AubSx7e7yB2HapYDdDx1mkQ7s6hUjRqnwmuh8GKFSLmyq6EmJlePEKhxdq9S
         d5Uov91XqEqA+FctbwY0Ib9TpkLmnJ3SI7Qxon0RETj00cLdhg2ywvWI8iJIlajFQmj1
         1QI4AjhjLCXGxaccvcRFbTwgWQTPAGBAJDjPI=
Date: Wed, 2 Sep 2009 01:12:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing: block-able ring_buffer consumer
Message-ID: <20090901231200.GD6108@nowhere>
References: <4A95F768.7070701@cn.fujitsu.com> <20090829102100.GB6418@nowhere> <4A9D192F.8080907@cn.fujitsu.com> <20090901230508.GC6108@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901230508.GC6108@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 01:05:10AM +0200, Frederic Weisbecker wrote:
> void poll_wait_pipe(struct trace_iterator *iter)
> {
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	/* sleep for 100 msecs, and try again. */
> 	schedule_timeout(HZ / 10);
> }
> 
> On the worst case the reader will wait for 1/100 secs
> (the comment is wrong).


No the comment is not wrong. It's just that I really suck in math :-)


> 
> You can probably use the same thing for ring buffer splice
> and poll waiters.
> 
> 	Frederic.
> 

