Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbXD1Wpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbXD1Wpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXD1Wpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:45:43 -0400
Received: from [70.254.190.220] ([70.254.190.220]:46449 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754367AbXD1WpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:45:04 -0400
Date: Sat, 28 Apr 2007 22:45:03 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Lee Revell <rlrevell@joe-job.com>
cc: tglx@linutronix.de, matthieu castet <castet.matthieu@free.fr>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: High Resolution Timer DOS
In-Reply-To: <75b66ecd0704281537s54134967ybc3ddef0b87b6bf5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704282244130.25153@server.thyself>
References: <4633C269.9050806@free.fr>  <1177798389.7646.320.camel@localhost.localdomain>
 <75b66ecd0704281537s54134967ybc3ddef0b87b6bf5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Lee Revell wrote:

> On 4/28/07, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>>  Well, it is not really a DoS. The rescheduling of the process is limited
>>  by the scheduler and the available CPU time (depending on the number of
>>  runnable tasks in the system).
>
> Shouldn't an unprivileged process be rate limited somehow to avoid
> flooding the machine with interrupts?  We restrict nonroot users from
> setting the RTC interrupt rate higher than 64Hz for a similar reason
> (granted, this limit dates back to the 486 days and should probably be
> increased to 1024 Hz).

Isn't that what /etc/security/limits.conf is for?
Just limit the CPU usage.

> Root and SCHED_FIFO tasks could be exempt from rate limiting, to avoid
> the need to introduce a new rlimit which would take years for
> userspace to catch up to.
>
> Lee

William Heimbigner
icxcnika@mar.tar.cc
