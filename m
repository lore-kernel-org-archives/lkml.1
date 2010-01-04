Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221Ab0ADMtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0ADMtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378Ab0ADMtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:49:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:43719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752524Ab0ADMtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:49:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192NHoV7/l2fE4F7EQK+o1GLegruL/8T5WAsKjn8d
	np0Qe8X1Zpa6ap
Subject: Re: [RFC][PATCH] sched: avoid huge bonus to sleepers on busy
 machines
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Jayaraman <sjayaraman@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1262608597.6408.117.camel@laptop>
References: <1262596842-17392-1-git-send-email-sjayaraman@suse.de>
	 <1262603675.9734.36.camel@marge.simson.net>  <4B41D8E5.1000908@suse.de>
	 <1262608250.9734.50.camel@marge.simson.net>
	 <1262608597.6408.117.camel@laptop>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 13:49:18 +0100
Message-Id: <1262609358.9734.52.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6899999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 13:36 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-04 at 13:30 +0100, Mike Galbraith wrote:
> > Any diddling of sleeper fairness would have to be accompanied with a
> > preemption model change methinks. 
> 
> Just told jays the exact same thing on IRC ;-)
> 
> Also, workloads are interesting, the signal test thing is the easiest to
> test the preemption side, various things like QPID show the down-side
> iirc.

Best testcase for the downside in my arsenal is vmark.  It performs a
_lot_ better with no wakeup preemption.  'Course if you run your box
that way, you quickly find out what a horrible idea that is :)

	-Mike

