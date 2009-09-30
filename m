Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZI3R7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZI3R7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZI3R7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:59:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZI3R7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:59:05 -0400
Subject: Re: 2.6.31.1 boot crash, compiled with ftrace
From: Steven Rostedt <rostedt@goodmis.org>
To: Dick Hollenbeck <dick@softplc.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4AC371C6.3050104@softplc.com>
References: <4AC22613.4090803@softplc.com>  <1254297804.2963.14.camel@frodo>
	 <1254301761.7286.4.camel@frodo>  <4AC371C6.3050104@softplc.com>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 13:57:36 -0400
Message-Id: <1254333456.2194.27.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 09:57 -0500, Dick Hollenbeck wrote:

> My real pursuit here is to find the reason for a nearly 1 second latency 
> when running a SCHED_RR userspace process.  The filesystem is ext3 off 
> the flash card via IDE. Linux is yanking the machine away from this 
> process sporadically for up to 1 second, no disk file calls in this 
> proces, only some serial port and networking (epoll) userspace calls in 
> a loop.  It is insane.  So I have to get either LTT or FTRACE enabled, 
> never used either before.  Its been a tough 2 weeks.  Just getting the 
> LTT patches in sync with a decent kernel has been nearly unbearable.
> 

Great to hear that you narrowed it down. BTW, if you want to learn some
more about ftrace, I just gave a 2 hour tutorial at LinuxCon last week.
You can download the slides in the link below. They show lots of
samples. I'll also start writing a howto for LWN real soon. So if you
don't already have a subscription, I suggest you get one ;-)

http://people.redhat.com/srostedt/ftrace-tutorial-linux-con-2009.odp

-- Steve


