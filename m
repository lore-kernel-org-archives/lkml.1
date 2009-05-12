Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZELQez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZELQez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZELQeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:34:46 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:27588 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZELQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:34:45 -0400
Message-ID: <4A09A525.4080107@sonarnerd.net>
Date: Tue, 12 May 2009 19:34:45 +0300
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net> <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net> <4A099670.5060902@nortel.com>
In-Reply-To: <4A099670.5060902@nortel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> If all you're trying to do is allow different threads to run at
> different nice levels, what about extending sys_setpriority() to take a
> "which" of PRIO_THREAD?  We'd probably have to call the syscall directly
> until/unless libc picks up the new option.

How would this be mapped to a POSIX standard API? I would like to see
something which works straight out with
pthread_setschedprio()/pthread_getschedparam(). In order it to work
correctly it also needs sys_sched_get_priority_min and
sys_sched_get_priority_max.


	- Jussi
